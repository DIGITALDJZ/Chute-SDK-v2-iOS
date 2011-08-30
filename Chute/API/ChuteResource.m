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
    NSString *_path                 = [[self pathForAllRequest] retain];
    
    NSError *_error = nil;
    ChuteNetwork *chuteNetwork = [[ChuteNetwork alloc] init];
    id _response = [chuteNetwork getRequestWithPath:_path andError:&_error];
    DLog(@"%@", _response);
    [chuteNetwork release];
    [_path release];
    return nil;
}

+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock andError:(ChuteErrorBlock) anErrorBlock {    
    DO_IN_BACKGROUND([self all], aResponseBlock, anErrorBlock);
}

#pragma mark - Override these methods in every Subclass
+ (NSString *)pathForAllRequest {
    //return an autoreleased NSString which is the path to get all
    return nil;
}

+ (NSString *)elementName {
    //for example, this should return the string "chutes", "assets"
    return nil;
}

+ (BOOL)supportsMetaData {
    return YES;
}

#pragma mark - Instance Methods
#pragma mark - Init

- (id) init {
    self = [super init];
    if (self) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [_content release];
    [super dealloc];
}

- (void)setObject:(id) aObject forKey:(id)aKey {
    [_content setObject:aObject forKey:aKey];
}

- (id)objectForKey:(id)aKey {
    return [_content objectForKey:aKey];
}

#pragma mark - Proxy for JSONRepresentation
- (id)proxyForJson {
    return _content;
}

#pragma mark - Common Get Data Methods

- (NSDictionary *) getMetaData {
    NSString *_path                 = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    
    NSError *_error = nil;
    ChuteNetwork *chuteNetwork = [[ChuteNetwork alloc] init];
    id _response = [chuteNetwork getRequestWithPath:_path andError:&_error];
    DLog(@"%@", _response);
    [chuteNetwork release];
    [_path release];
    return nil;
}

- (NSUInteger) objectID {
    return [[_content objectForKey:@"id"] intValue];
}

@end
