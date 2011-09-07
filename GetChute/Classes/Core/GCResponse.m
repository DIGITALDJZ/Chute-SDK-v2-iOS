//
//  GCObject.m
//
//  Created by Achal Aggarwal on 05/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResponse.h"

@implementation GCResponse

@synthesize object;
@synthesize error;
@synthesize rawResponse;
@synthesize data;

- (BOOL) isSuccessful {
    if (IS_NULL([self error])) {
        return YES;
    }
    DLog(@"%@", [[self error] localizedDescription]);
    return NO;
}

- (id) object {
    if (object)
        return object;
    return [self data];
}

- (id) objectForKey:(id)key {
    if ([[self data] class] == [NSDictionary class]) {
        return [[self data] objectForKey:key];
    }
    return nil;
}

- (id) valueForKey:(NSString *)key {
    if ([[self data] class] == [NSDictionary class]) {
        return [[self data] valueForKey:key];
    }
    return nil;
}

- (id) data {
    return [data objectForKey:@"data"];
}

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
            [self setData:[[self rawResponse] JSONValue]];
        }
    }
    return self;
}

- (void) dealloc {
    [data release];
    [rawResponse release];
    [object release];
    [error release];
    [super dealloc];
}

@end
