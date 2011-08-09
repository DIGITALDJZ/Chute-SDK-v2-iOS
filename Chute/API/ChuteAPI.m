//
//  ChuteAPI.m
//
//  Created by Gaurav Sharma on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChuteAPI.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ChuteConstants.h"
#import "NSData+Base64.h"
#import "NSDictionary+QueryString.h"

static ChuteAPI *shared=nil;
NSString * const ChuteLoginStatusChanged = @"ChuteLoginStatusChanged";

@implementation ChuteAPI

@synthesize accountStatus;
@synthesize accessToken;

+ (ChuteAPI *)shared{
    @synchronized(shared){
		if (!shared) {
			shared = [[ChuteAPI alloc] init];
		}
	}
	return shared;
}

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    [accessToken release];
    [super dealloc];
}

#pragma mark -
#pragma mark Generate Request Headers

- (NSMutableDictionary *)headers{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            kDEVICE_NAME, @"x-device-name",
            kUDID, @"x-device-identifier",
            kDEVICE_OS, @"x-device-os",
            kDEVICE_VERSION, @"x-device-version",
            [NSString stringWithFormat:@"OAuth %@", [self accessToken]], @"Authorization",
            nil];
}

#pragma mark -
#pragma mark Access Token

- (void) setAccessToken:(NSString *)accessTkn {
    if (_accessToken) {
        [_accessToken release], _accessToken = nil;
    }
    _accessToken = [accessTkn retain];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_accessToken forKey:@"access_token"];
    [prefs synchronize];
}

- (NSString *) accessToken {
    if (_accessToken == nil) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _accessToken = [[prefs objectForKey:@"access_token"] retain];
    }
    return _accessToken;
}

#pragma mark -
#pragma mark User id

- (void) setUserId:(NSUInteger) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [prefs synchronize];
}

- (NSUInteger) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [[prefs objectForKey:@"user_id"] intValue];
}

#pragma mark -
#pragma mark GET and POST convinence methods

- (void)postRequestWithPath:(NSString *)path
                  andParams:(NSDictionary *)params
                andResponse:(ResponseBlock)aResponseBlock
                   andError:(ErrorBlock)anErrorBlock{
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:path]];
    
    [_request setRequestHeaders:[self headers]];
    
    for (id key in [params allKeys]) {
        [_request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [_request setCompletionBlock:^{
        if ([_request responseStatusCode] == 200 || [_request responseStatusCode] == 201) {
            aResponseBlock([[_request responseString] JSONValue]);
        } else {
            anErrorBlock([NSError errorWithDomain:@"Unidentified Error" code:[_request responseStatusCode] userInfo:nil]);
        }
    }];
    
    [_request setFailedBlock:^{
        anErrorBlock([_request error]);
    }];
    
    [_request setRequestMethod:@"POST"];
    
    [_request startAsynchronous];
}

- (void)getRequestWithPath:(NSString *)path
                 andParams:(NSMutableDictionary *)params
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock{
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    
    [_request setRequestHeaders:[self headers]];
    
    [_request setTimeOutSeconds:300.0];
    [_request setCompletionBlock:^{
        aResponseBlock([[_request responseString] JSONValue]);
    }];
    
    [_request setFailedBlock:^{
        anErrorBlock([_request error]);
    }];
    
    [_request startAsynchronous];
}

#pragma mark -
#pragma mark Authorization Methods

- (void) setAccountStatus:(ChuteAccountStatus)_accountStatus {
    accountStatus = _accountStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChuteLoginStatusChanged object:self];
}

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(void (^)(void))successBlock 
                                  andError:(ErrorBlock)errorBlock {
    if ([self accessToken]) {
        [self setAccountStatus:ChuteAccountStatusLoggedIn];
        successBlock();
        return;
    }
    
    [self setAccountStatus:ChuteAccountStatusLoggingIn];
    
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"profile" forKey:@"scope"];
    [params setValue:kOAuthClientID forKey:@"client_id"];
    [params setValue:kOAuthClientSecret forKey:@"client_secret"];
    [params setValue:@"authorization_code" forKey:@"grant_type"];
    [params setValue:kOAuthRedirectURL forKey:@"redirect_uri"];
    
    if (accessCode == nil) {
        errorBlock(nil);
        return;
    }
    else {
        [params setValue:accessCode forKey:@"code"];
    }

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kOAuthTokenURL]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request appendPostData:[[params stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    
    [request setTimeOutSeconds:300.0];
    [request setCompletionBlock:^{
        //save access code
        NSDictionary *_response = [[request responseString] JSONValue];
        [[ChuteAPI shared] setAccessToken:[_response objectForKey:@"access_token"]];
        
        //send request to save userid
        [[ChuteAPI shared] getProfileInfoWithResponse:^(id response) {
            [self setUserId:[[response valueForKey:@"id"] intValue]];
            [self setAccountStatus:ChuteAccountStatusLoggedIn];
            successBlock();
        } andError:^(NSError *error) {
            [self setAccountStatus:ChuteAccountStatusLoginFailed];
            errorBlock([request error]);
        }];
    }];
    
    [request setFailedBlock:^{
        [self setAccountStatus:ChuteAccountStatusLoginFailed];
        errorBlock([request error]);
    }];
    [request startAsynchronous];
}

- (void)reset {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"access_token"];
    [prefs setObject:nil forKey:@"id"];
    [prefs synchronize];
    [ASIHTTPRequest setSessionCookies:nil];
    if (_accessToken) {
        [_accessToken release], _accessToken = nil;
    }
}

#pragma mark -
#pragma mark Sync with 3rd party services

- (void) syncDidComplete:(void (^)(void))successBlock andError:(ErrorBlock)errorBlock {
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@me/chutes/evernote/sync", API_URL]]];
    [_request setTimeOutSeconds:300];
    [_request startAsynchronous];
    
    [_request setCompletionBlock:^{
        if ([_request responseStatusCode] == 200) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:[[[[_request responseString] JSONValue] objectAtIndex:0] objectForKey:@"id"] forKey:@"id"];
            [prefs synchronize];
            successBlock();
        } else {
            errorBlock([NSError errorWithDomain:@"Unidentified Error for Sync" code:[_request responseStatusCode] userInfo:nil]);
        }
    }];
    
    [_request setFailedBlock:^{
        errorBlock([_request error]);
    }];
}

#pragma mark -
#pragma mark Data Wrappers
/*
- (void)getChutesForResponse:(void (^)(id))aResponseBlock
                    andError:(void (^)(NSError *))anErrorBlock {
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@me/chutes/deep", API_URL] andParams: nil andResponse:^(id response) {
        if (_data) {
            [_data release], _data = nil;
        }
        
        DLog(@"%@", response);
        
        _data = [[NSMutableArray alloc] init];
        
        NSMutableSet *_sections = [[NSMutableSet alloc] init];
        
        for (NSDictionary *dic in [response objectForKey:@"data"]) {
            NSDictionary *_details = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [dic valueForKey:@"parent_id"], @"id",
                                     [dic valueForKey:@"parent_name"], @"name",
                                     nil];
            [_sections addObject:_details];
            [_details release];
        }
        
        for (NSDictionary *_section in _sections) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];    
            NSMutableArray *arr             = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in [response objectForKey:@"data"]) {
                if ([[_section objectForKey:@"name"] isEqualToString:[dic objectForKey:@"parent_name"]]) {
                    [arr addObject:dic];
                }
            }
            
            [dictionary setObject:arr forKey:_section];
            [_data addObject:dictionary];
            
            [arr release];
            [dictionary release];
        }
        
        [_sections release];
        
        aResponseBlock(response);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableView" object:nil];
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}
 */

- (void)createChute:(NSString *)name 
         withParent:(NSUInteger)parentId
 withPermissionView:(NSUInteger)permissionView
      andAddMembers:(NSUInteger)addMembers
       andAddPhotos:(NSUInteger)addPhotos
        andResponse:(ResponseBlock)responseBlock 
           andError:(ErrorBlock)errorBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:name forKey:@"chute[name]"];
    [params setValue:[NSString stringWithFormat:@"%d", parentId] forKey:@"chute[parent_id]"];
    [params setValue:[NSString stringWithFormat:@"%d", permissionView] forKey:@"chute[permission_view]"];
    [params setValue:[NSString stringWithFormat:@"%d", addMembers] forKey:@"chute[permission_add_members]"];
    [params setValue:[NSString stringWithFormat:@"%d", addPhotos] forKey:@"chute[permission_add_photos]"];
    
    [self postRequestWithPath:[NSString stringWithFormat:@"%@chutes", API_URL] andParams:params andResponse:^(id response) {
        responseBlock(response);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
    
    [params release];
}

- (void)getProfileInfoWithResponse:(ResponseBlock)aResponseBlock
                          andError:(ErrorBlock)anErrorBlock{
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/me", API_URL] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void)getMyChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                       andError:(ErrorBlock)anErrorBlock{
    [self getChutesForId:@"me" response:aResponseBlock andError:anErrorBlock];
}

- (void)getPublicChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                       andError:(ErrorBlock)anErrorBlock{
    [self getChutesForId:@"public" response:aResponseBlock andError:anErrorBlock];
}

- (void)getChutesForId:(NSString *)Id 
              response:(void (^)(NSArray *))aResponseBlock 
              andError:(ErrorBlock)anErrorBlock {
    [self getRequestWithPath:[NSString stringWithFormat:@"%@%@/chutes", API_URL, Id] andParams: nil andResponse:^(id response) {
        NSArray *_arr = [[[NSArray alloc] initWithArray:[response objectForKey:@"data"]] autorelease];
        aResponseBlock(_arr);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void)getAssetsForChuteId:(NSUInteger)chuteId
                   response:(void (^)(NSArray *))aResponseBlock 
                   andError:(ErrorBlock)anErrorBlock {
    [self getRequestWithPath:[NSString stringWithFormat:@"%@chutes/%d/assets", API_URL, chuteId] andParams: nil andResponse:^(id response) {
        NSArray *_arr = [[[NSArray alloc] initWithArray:[response objectForKey:@"data"]] autorelease];
        aResponseBlock(_arr);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

#pragma mark -
#pragma mark Helper methods for Asset Uploader

- (void)initThumbnail:(UIImage *)thumbnail
           forAssetId:(NSString *)assetId
          andResponse:(ResponseBlock)aResponseBlock
             andError:(void (^)(NSError *))anErrorBlock{
    
    NSData *imageData           = UIImageJPEGRepresentation(thumbnail, 0.5);
    NSDictionary *postParams    = [NSDictionary dictionaryWithObjectsAndKeys:[imageData base64EncodingWithLineLength:0], @"thumbnail", nil];
    
    [self postRequestWithPath:[NSString stringWithFormat:@"%@/assets/%@/init", API_URL, assetId] andParams: postParams andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void)getTokenForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock{
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/uploads/%@/token", API_URL, assetId] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void)completeForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock{
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/uploads/%@/complete", API_URL, assetId] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void) test {

/////////////////////////////////////////////////////////////////////////////////
    
//    create chute
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:@"test" forKey:@"chute[name]"];
//    [params setValue:[NSString stringWithFormat:@"%d", parentId] forKey:@"chute[parent_id]"];
//    
//    [self postRequestWithPath:[NSString stringWithFormat:@"%@chutes", API_URL] andParams:params andResponse:^(id response) {
//        DLog(@"%@", response);
//    } andError:^(NSError *error) {
//        DLog(@"%@", [error localizedDescription]);
//    }];
//    
//    [params release];
    
/////////////////////////////////////////////////////////////////////////////////
    
//    assets
    
//    [self getRequestWithPath:[NSString stringWithFormat:@"%@me/assets", API_URL] andParams: nil andResponse:^(id response) {
//        DLog(@"%@", response);
//        //aResponseBlock(response);
//    } andError:^(NSError *error) {
//        DLog(@"%@", [error localizedDescription]);
//    }];
    
/////////////////////////////////////////////////////////////////////////////////
    
//    Inbox

    [self getRequestWithPath:[NSString stringWithFormat:@"%@inbox", API_URL] andParams: nil andResponse:^(id response) {
        DLog(@"%@", response);
        //aResponseBlock(response);
    } andError:^(NSError *error) {
        DLog(@"%@", [error localizedDescription]);
    }];

/////////////////////////////////////////////////////////////////////////////////

}

@end
