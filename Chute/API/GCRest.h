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

@interface GCRest : NSObject

- (NSMutableDictionary *)headers;

- (id)getRequestWithPath:(NSString *)path
                andError:(NSError **)error;

- (id)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                andError:(NSError **)error;

- (id)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                 andError:(NSError **)error 
                andMethod:(NSString *)method;

- (id)putRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                 andError:(NSError **)error;

- (id)deleteRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                 andError:(NSError **)error;

@end
