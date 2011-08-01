//
//  ChuteAPI.m
//  TTT
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

@synthesize apiKey;
@synthesize accountStatus;
@synthesize evernoteData = _evernoteData;
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
    [apiKey release];
    [super dealloc];
}

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

#pragma mark GET and POST convinence methods

- (void)postRequestWithPath:(NSString *)path
                  andParams:(NSDictionary *)params
                andResponse:(void (^)(id))aResponseBlock
                   andError:(void (^)(NSError *))anErrorBlock{
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
               andResponse:(void (^)(id))aResponseBlock
                  andError:(void (^)(NSError *))anErrorBlock{
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

#pragma mark Authorization Methods

- (void) setAccountStatus:(ChuteAccountStatus)_accountStatus {
    accountStatus = _accountStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:ChuteLoginStatusChanged object:self];
}

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(void (^)(void))successBlock 
                                  andError:(void (^)(NSError *))errorBlock {
    
    DLog();
    
    [self setAccountStatus:ChuteAccountStatusLoggingIn];
    
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"read write" forKey:@"scope"];
    [params setValue:@"profile" forKey:@"scope"];
    [params setValue:kOAuthClientID forKey:@"client_id"];
    [params setValue:kOAuthClientSecret forKey:@"client_secret"];
    [params setValue:@"authorization_code" forKey:@"grant_type"];
    [params setValue:kOAuthRedirectURL forKey:@"redirect_uri"];
    
    if (accessCode == nil) {
        DLog();
        if ([self accessToken] == nil) {
            DLog();
            errorBlock(nil);
            return;
        }
        DLog();
        [params setValue:[self accessToken] forKey:@"code"];
    }
    else {
        DLog();
        [params setValue:accessCode forKey:@"code"];
    }

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kOAuthTokenURL]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request appendPostData:[[params stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    
    [request setTimeOutSeconds:300.0];
    [request setCompletionBlock:^{
        DLog();
        //save access code
        NSDictionary *_response = [[request responseString] JSONValue];
        [[ChuteAPI shared] setAccessToken:[_response objectForKey:@"access_token"]];
        
        //send request to save userid
        [[ChuteAPI shared] getProfileInfoWithResponse:^(id response) {
            DLog(@"%@", response);
            [self setUserId:[[response valueForKey:@"id"] intValue]];
            [self setAccountStatus:ChuteAccountStatusLoggedIn];
            successBlock();
        } andError:^(NSError *error) {
            DLog(@"%@", [error localizedDescription]);
            [self setAccountStatus:ChuteAccountStatusLoginFailed];
            errorBlock([request error]);
        }];
    }];
    
    [request setFailedBlock:^{
        DLog();
        DLog(@"%@", [[request error] localizedDescription]);
        [self setAccountStatus:ChuteAccountStatusLoginFailed];
        errorBlock([request error]);
    }];
    
    [request startAsynchronous];
}

- (void)reset {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"api_key"];
    [prefs setObject:nil forKey:@"id"];
    [prefs synchronize];
    [_evernoteData release], _evernoteData = nil;
    [ASIHTTPRequest setSessionCookies:nil];
}

#pragma mark Sync with 3rd party services

- (void) syncDidComplete:(void (^)(void))successBlock andError:(void (^)(NSError *))errorBlock {
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

- (void)getChutesForResponse:(void (^)(id))aResponseBlock
                    andError:(void (^)(NSError *))anErrorBlock {
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@me/chutes/deep", API_URL] andParams: nil andResponse:^(id response) {
        if (_evernoteData) {
            [_evernoteData release], _evernoteData = nil;
        }
        
        DLog(@"%@", response);
        
        _evernoteData = [[NSMutableArray alloc] init];
        
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
            [_evernoteData addObject:dictionary];
            
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

- (void)createChute:(NSString *)name 
         withParent:(int)parentId
        andResponse:(void (^)(id))responseBlock 
           andError:(void (^)(NSError *))errorBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:name forKey:@"chute[name]"];
    [params setValue:[NSString stringWithFormat:@"%d", parentId] forKey:@"chute[parent_id]"];
    
    [self postRequestWithPath:[NSString stringWithFormat:@"%@chutes", API_URL] andParams:params andResponse:^(id response) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *syncURL = [NSString stringWithFormat:@"%@chutes/%d/sync/evernote/%d", API_URL, [[response valueForKey:@"id"] intValue], [[prefs objectForKey:@"id"] intValue]];
        
        [self postRequestWithPath:syncURL andParams:nil andResponse:^(id response) {
            responseBlock(response);
        } andError:^(NSError *error) {
            errorBlock(error);
        }];
        
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
    
    [params release];
}

- (void)getProfileInfoWithResponse:(void (^)(id))aResponseBlock
                          andError:(void (^)(NSError *))anErrorBlock{
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/me", API_URL] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

#pragma mark Helper methods for Asset Uploader

- (void)initThumbnail:(UIImage *)thumbnail
           forAssetId:(NSString *)assetId
          andResponse:(void (^)(id))aResponseBlock
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
               andResponse:(void (^)(id))aResponseBlock
                  andError:(void (^)(NSError *))anErrorBlock{
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/uploads/%@/token", API_URL, assetId] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void)completeForAssetId:(NSString *)assetId
               andResponse:(void (^)(id))aResponseBlock
                  andError:(void (^)(NSError *))anErrorBlock{
    
    [self getRequestWithPath:[NSString stringWithFormat:@"%@/uploads/%@/complete", API_URL, assetId] andParams: nil andResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
}

- (void) test {
    [self getRequestWithPath:[NSString stringWithFormat:@"%@chutes", API_URL] andParams: nil andResponse:^(id response) {
        DLog(@"%@", response);
        //aResponseBlock(response);
    } andError:^(NSError *error) {
        DLog(@"%@", [error localizedDescription]);
    }];
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:@"test" forKey:@"chute[name]"];
//    
//    [self postRequestWithPath:[NSString stringWithFormat:@"%@chutes", API_URL] andParams:params andResponse:^(id response) {
//        DLog(@"%@", response);
//    } andError:^(NSError *error) {
//        DLog(@"%@", [error localizedDescription]);
//    }];
//    
//    [params release];
    
///v1/:user_id/assets/all
    
}

@end
