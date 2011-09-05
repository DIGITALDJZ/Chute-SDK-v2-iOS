//
//  ChuteNetwork.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCMacros.h"
#import "GCConstants.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "GCResponseObject.h"
#import "GCError.h"

@interface GCRest : NSObject

- (NSMutableDictionary *)headers;

- (GCResponseObject *)getRequestWithPath:(NSString *)path;

- (GCResponseObject *)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params;

- (GCResponseObject *)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                andMethod:(NSString *)method;

- (GCResponseObject *)putRequestWithPath:(NSString *)path
                       andParams:(NSMutableDictionary *)params;

- (GCResponseObject *)deleteRequestWithPath:(NSString *)path
                          andParams:(NSMutableDictionary *)params;

//Background Calls
- (void)getRequestInBackgroundWithPath:(NSString *)path
                          withResponse:(GCResponseBlock)aResponseBlock;

- (void)postRequestInBackgroundWithPath:(NSString *)path
                              andParams:(NSMutableDictionary *)params
                           withResponse:(GCResponseBlock)aResponseBlock;

- (void)putRequestInBackgroundWithPath:(NSString *)path
                             andParams:(NSMutableDictionary *)params
                          withResponse:(GCResponseBlock)aResponseBlock;

- (void)deleteRequestInBackgroundWithPath:(NSString *)path
                                andParams:(NSMutableDictionary *)params
                             withResponse:(GCResponseBlock)aResponseBlock;
@end
