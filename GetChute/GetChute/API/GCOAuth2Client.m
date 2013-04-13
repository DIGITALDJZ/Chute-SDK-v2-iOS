//
//  GCOAuth2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCOAuth2Client.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+QueryString.h"
#import "GCClient.h"

NSString * const kGCBaseURLString = @"https://getchute.com/";

NSString * const kGCScope = @"scope";
NSString * const kGCScopeDefaultValue = @"all_resources manage_resources profile resources";
NSString * const kGCType = @"type";
NSString * const kGCTypeValue = @"web_server";
NSString * const kGCResponseType = @"response_type";
NSString * const kGCResponseTypeValue = @"code";
NSString * const kGCClientID = @"client_id";
NSString * const kGCRedirectURI = @"redirect_uri";
NSString * const kGCRedirectURIDefaultValue = @"http://getchute.com/oauth/callback";

NSString * const kGCOAuth = @"oauth";

static NSString * kGCServices[] = {
    @"chute",
    @"facebook",
    @"twitter",
    @"google",
    @"trendabl",
    @"flickr",
    @"instagram",
    @"foursquare"
};

NSString * const kGCClientSecret = @"client_secret";
NSString * const kGCCode = @"code";
NSString * const kGCGrantType = @"grant_type";
NSString * const kGCGrantTypeValue = @"authorization_code";

@implementation GCOAuth2Client

+ (instancetype)clientWithBaseURL:(NSURL *)url {
    NSAssert(NO, @"GCOAuth2Client instance cannot be generated with this method.");
    return nil;
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:kGCRedirectURIDefaultValue scope:kGCScopeDefaultValue];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:_redirectURI scope:kGCScopeDefaultValue];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret scope:(NSString *)_scope {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:kGCRedirectURIDefaultValue scope:_scope];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI scope:(NSString *)_scope {
    return [[GCOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:kGCBaseURLString] clientID:_clientID clientSecret:_clientSecret redirectURI:_redirectURI scope:_scope];
}

- (id)initWithBaseURL:(NSURL *)url clientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI scope:(NSString *)_scope {
    
    NSParameterAssert(_clientID);
    NSParameterAssert(_clientSecret);
    NSParameterAssert(_redirectURI);
    NSParameterAssert(_scope);
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    clientID = _clientID;
    clientSecret = _clientSecret;
    redirectURI = _redirectURI;
    scope = _scope;
    
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Internet connection detected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    return self;
}

- (void)verifyAuthorizationWithAccessCode:(NSString *)code success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    NSDictionary *params = @{
                             kGCClientID:clientID,
                             kGCClientSecret:clientSecret,
                             kGCRedirectURI:redirectURI,
                             kGCCode:code,
                             kGCGrantType:kGCGrantTypeValue,
                             kGCScope:scope
                             };
    
    NSMutableURLRequest *request = [self requestWithMethod:kGCClientPOST path:@"oauth/access_token" parameters:params];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        GCClient *apiClient = [GCClient sharedClient];
        [apiClient setAuthorizationHeaderWithToken:[JSON objectForKey:@"access_token"]];
        success();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    
    [operation start];
}

- (NSURLRequest *)requestAccessForService:(GCService)service {
    
    NSDictionary *params = @{
                             kGCScope:scope,
                             kGCResponseType:kGCResponseTypeValue,
                             kGCType:kGCTypeValue,
                             kGCClientID:clientID,
                             kGCClientSecret:clientSecret,
                             kGCRedirectURI:redirectURI,
                             };
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/%@?%@",
                                                                               [self baseURL],
                                                                               kGCServices[service],
                                                                               [params stringWithFormEncodedComponents]]]];
    [self clearCookiesForService:service];
    return request;
}

- (void)clearCookiesForService:(GCService)service {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:kGCServices[service]];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }];
}

@end
