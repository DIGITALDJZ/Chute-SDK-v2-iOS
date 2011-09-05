//
//  GCObject.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 05/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResponseObject.h"
#import "GCError.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation GCResponseObject

@synthesize object;
@synthesize error;
@synthesize rawResponse;

- (id) initWithRequest:(ASIHTTPRequest *) request {
    self = [super init];
    
    if (self) {   
        [self setError:(GCError *)[request error]];
        
        if ([request responseStatusCode] >= 300) {
            NSMutableDictionary *_errorDetail = [[NSMutableDictionary alloc] init];
            [_errorDetail setValue:[[[request responseString] JSONValue] objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
            [self setError:[GCError errorWithDomain:@"GCError" code:[request responseStatusCode] userInfo:_errorDetail]];
            [_errorDetail release];
        }
        
        [self setRawResponse:[request responseString]];
        if ([[self rawResponse] length] > 1) {
            [self setObject:[[self rawResponse] JSONValue]];
        }
    }
    return self;
}

- (void) dealloc {
    [rawResponse release];
    [object release];
    [error release];
    [super dealloc];
}

@end
