//
//  ChuteResource.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "ChuteResource.h"

@implementation ChuteResource

#pragma mark - All 
/* Get all Objects of this class */
+ (NSArray *)all {
    NSString *_path                 = [[NSString alloc] init];
    NSMutableDictionary *_params    = [[NSMutableDictionary alloc] init];
    //To configure the all request this needs to be called
    [[self class] all_Path:&_path AndConfiguringParams:&_params];
    
    NSError *_error = nil;
    ChuteNetwork *chuteNetwork = [[ChuteNetwork alloc] init];
    id _response = [chuteNetwork getRequestWithPath:_path andParams:_params andError:&_error];
    DLog(@"%@", _response);
    [chuteNetwork release];
    return nil;
}

+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock andError:(ChuteErrorBlock) anErrorBlock {    
    DO_IN_BACKGROUND([self all], aResponseBlock, anErrorBlock);
}

/* Override this method in the subclass to configure the request */
+ (void)all_Path:(NSString **)path AndConfiguringParams:(NSMutableDictionary **)params {
    
}

#pragma mark - Instance Methods
#pragma mark - Init

- (id) init {
    self = [super init];
    if (self) {
        content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [content release];
    [super dealloc];
}

- (void)setObject:(id) aObject forKey:(id)aKey {
    [content setObject:aObject forKey:aKey];
}

- (id)objectForKey:(id)aKey {
    return [content objectForKey:aKey];
}

//Proxy for JSONRepresentation
- (id)proxyForJson {
    return content;
}

@end
