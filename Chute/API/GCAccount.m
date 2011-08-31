//
//  ChuteAccount.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 30/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCAccount.h"

NSString * const GCAccountStatusChanged = @"GCAccountStatusChanged";
static GCAccount *sharedAccountManager = nil;

@implementation GCAccount

@synthesize accountStatus;
@synthesize accessToken;

#pragma mark - Access Token

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

#pragma mark - User id

- (void) setUserId:(NSUInteger) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [prefs synchronize];
}

- (NSUInteger) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [[prefs objectForKey:@"user_id"] intValue];
}

#pragma mark - Authorization Methods

- (void) setAccountStatus:(GCAccountStatus)_accountStatus {
    accountStatus = _accountStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAccountStatusChanged object:self];
}

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(ChuteBasicBlock)successBlock 
                                  andError:(ChuteErrorBlock)errorBlock {
    if ([self accessToken]) {
        [self setAccountStatus:GCAccountLoggedIn];
        successBlock();
        return;
    }
    
    [self setAccountStatus:GCAccountLoggingIn];
    
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
        [self setAccessToken:[_response objectForKey:@"access_token"]];
        
        //send request to save userid
        [self getProfileInfoWithResponse:^(id response) {
            [self setUserId:[[response valueForKey:@"id"] intValue]];
            [self setAccountStatus:GCAccountLoggedIn];
            successBlock();
        } andError:^(NSError *error) {
            [self setAccountStatus:GCAccountLoginFailed];
            errorBlock([request error]);
        }];
    }];
    
    [request setFailedBlock:^{
        [self setAccountStatus:GCAccountLoginFailed];
        errorBlock([request error]);
    }];
    [request startAsynchronous];
}

#pragma mark - Get Profile Info
- (void)getProfileInfoWithResponse:(ChuteResponseBlock)aResponseBlock
                          andError:(ChuteErrorBlock)anErrorBlock{
    NSString *_path = [[NSString alloc] initWithFormat:@"%@/me", API_URL];
    GCRest *chuteNetwork = [[GCRest alloc] init];
    [chuteNetwork getRequestInBackgroundWithPath:_path withResponse:^(id response) {
        aResponseBlock(response);
    } andError:^(NSError *error) {
        anErrorBlock(error);
    }];
    [chuteNetwork release];
    [_path release];
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

#pragma mark - Methods for Singleton class
+ (GCAccount *)sharedManager
{
    if (sharedAccountManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedAccountManager = [[super allocWithZone:NULL] init];
        });
    }
    return sharedAccountManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release;
{
    //nothing
}

- (id)autorelease
{
    return self;
}

@end
