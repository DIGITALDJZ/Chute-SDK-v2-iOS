//
//  ChuteNetwork.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCRest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "GCAccount.h"

@implementation GCRest

- (NSMutableDictionary *)headers{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            kDEVICE_NAME, @"x-device-name",
            kUDID, @"x-device-identifier",
            kDEVICE_OS, @"x-device-os",
            kDEVICE_VERSION, @"x-device-version",
            [NSString stringWithFormat:@"OAuth %@", [[GCAccount sharedManager] accessToken]], @"Authorization",
            nil];
}

- (id)getRequestWithPath:(NSString *)path
                andError:(NSError **)error{
    
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];    
    [_request setRequestHeaders:[self headers]];
    [_request setTimeOutSeconds:300.0];
    [_request startSynchronous];

    if ([_request responseStatusCode] != 200) {
        NSMutableDictionary *_errorDetail = [[NSMutableDictionary alloc] init];
        [_errorDetail setValue:[[[_request responseString] JSONValue] objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:_errorDetail];
        [_errorDetail release];
        return nil;
    }
    
    *error = [_request error];

    NSString *_responseString = [_request responseString];
    if (kJSONResponse) {
        if ([_responseString length] > 1)
            return [_responseString JSONValue];
    }
    else {
        return _responseString;
    }
    return nil;
}

- (id)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                 andError:(NSError **)error {
    return [self postRequestWithPath:path andParams:params andError:error andMethod:@"POST"];
}

- (id)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                 andError:(NSError **)error 
                andMethod:(NSString *)method {
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:path]];
    [_request setRequestHeaders:[self headers]];
    
    if ([params objectForKey:@"raw"]) {
        [_request setPostBody:[params objectForKey:@"raw"]];
    }
    else {
        [_request setPostBody:nil];
        for (id key in [params allKeys]) {
            [_request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    [_request setRequestMethod:method];
    [_request startSynchronous];
    
    *error = [_request error];
    NSString *_responseString = [_request responseString];
    
    if (kJSONResponse) {
        if ([_responseString length] > 1)
            return [_responseString JSONValue];
    }
    else {
        return _responseString;
    }
    return nil;
}

- (id)putRequestWithPath:(NSString *)path
               andParams:(NSMutableDictionary *)params
                andError:(NSError **)error {
    return [self postRequestWithPath:path andParams:params andError:error andMethod:@"PUT"];
}

- (id)deleteRequestWithPath:(NSString *)path
                  andParams:(NSMutableDictionary *)params
                   andError:(NSError **)error {
    return [self postRequestWithPath:path andParams:params andError:error andMethod:@"DELETE"];
}

#pragma mark - Background Method Calls

- (void)getRequestInBackgroundWithPath:(NSString *)path
                          withResponse:(ChuteResponseBlock)aResponseBlock 
                              andError:(ChuteErrorBlock)anErrorBlock {
    DO_IN_BACKGROUND([self getRequestWithPath:path andError:&_error], aResponseBlock, anErrorBlock);
}

- (void)postRequestInBackgroundWithPath:(NSString *)path
                              andParams:(NSMutableDictionary *)params
                           withResponse:(ChuteResponseBlock)aResponseBlock
                               andError:(ChuteErrorBlock)anErrorBlock {
    DO_IN_BACKGROUND([self postRequestWithPath:path andParams:params andError:&_error], aResponseBlock, anErrorBlock);
}

@end
