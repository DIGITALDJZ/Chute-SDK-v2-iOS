//
//  ChuteNetwork.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChuteMacros.h"

@interface ChuteNetwork : NSObject

- (NSMutableDictionary *)headers;

- (id)getRequestWithPath:(NSString *)path
                andError:(NSError **)error;

- (id)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                andError:(NSError **)error;

- (void)getRequestInBackgroundWithPath:(NSString *)path 
                          withResponse:(ChuteResponseBlock)aResponseBlock 
                              andError:(ChuteErrorBlock)anErrorBlock;

- (void)postRequestInBackgroundWithPath:(NSString *)path 
                              andParams:(NSMutableDictionary *)params 
                           withResponse:(ChuteResponseBlock)aResponseBlock 
                               andError:(ChuteErrorBlock)anErrorBlock;
@end
