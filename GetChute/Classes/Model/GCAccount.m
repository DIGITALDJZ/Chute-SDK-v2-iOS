//
//  GCAccount.m
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
@synthesize assetsArray;

#pragma mark - Load Assets

- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock {
    
    if (assetsArray) {
        [assetsArray release], assetsArray = nil;
    }
    
    assetsArray = [[NSMutableArray alloc] init];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if(result != nil)
        {
            GCAsset *_asset = [[GCAsset alloc] init];
            [_asset setAlAsset:result];
            [assetsArray addObject:_asset];
            [_asset release];
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            if (aCompletionBlock) {
                aCompletionBlock();
            }
            return;
        }
        
        [group enumerateAssetsUsingBlock:assetEnumerator];
    };
    
    void (^assetFailureBlock)(NSError *) = ^(NSError *error)
    {
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetFailureBlock];
    [assetsLibrary release];
}

- (void)loadAssets {
    [self loadAssetsCompletionBlock:nil];
}

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
                                   success:(GCBasicBlock)successBlock 
                                  andError:(GCErrorBlock)errorBlock {
    if ([self accessToken]) {
        [self setAccountStatus:GCAccountLoggedIn];
        successBlock();
        return;
    }
    
    [self setAccountStatus:GCAccountLoggingIn];
    
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kOAuthPermissions forKey:@"scope"];
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
        [self getProfileInfoWithResponse:^(GCResponse *response) {
            if ([response error]) {
                [self setAccountStatus:GCAccountLoginFailed];
                errorBlock([response error]);
            }
            else {
                [self setUserId:[[[response object] valueForKey:@"id"] intValue]];
                [self setAccountStatus:GCAccountLoggedIn];
                successBlock();
            }
        }];
    }];
    
    [request setFailedBlock:^{
        [self setAccountStatus:GCAccountLoginFailed];
        errorBlock([request error]);
    }];
    [request startAsynchronous];
}

#pragma mark - Get Profile Info
- (void)getProfileInfoWithResponse:(GCResponseBlock)aResponseBlock {
    NSString *_path = [[NSString alloc] initWithFormat:@"%@/me", API_URL];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    [gcRequest getRequestInBackgroundWithPath:_path withResponse:^(GCResponse *response) {
        if (aResponseBlock) {
            aResponseBlock(response);
        }
    }];
    
    [gcRequest release];
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
