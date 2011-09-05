//
//  GCObject.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 05/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCError;
@class ASIHTTPRequest;

@interface GCResponseObject : NSObject

@property (nonatomic, retain) GCError *error;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) id rawResponse;

- (id) initWithRequest:(ASIHTTPRequest *) request;

@end
