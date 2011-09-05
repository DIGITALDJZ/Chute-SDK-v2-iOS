//
//  ChuteResource.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResource.h"

@interface GCResource()

+ (NSString *)elementName;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end

@implementation GCResource

#pragma mark - All 
/* Get all Objects of this class */
+ (NSArray *)all {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@/me/%@", API_URL, [self elementName]];
    NSError *_error     = nil;
    GCRest *gcRest      = [[GCRest alloc] init];
    id _response        = [gcRest getRequestWithPath:_path andError:&_error];

    NSMutableArray *_result = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *_dic in [_response objectForKey:@"data"]) {
        id _obj = [[[self alloc] initWithDictionary:_dic] autorelease];
        [_result addObject:_obj];
    }
    
    [gcRest release];
    [_path release];
    return _result;
}

+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock andError:(ChuteErrorBlock) anErrorBlock {    
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@/me/%@", API_URL, [self elementName]];
    
    GCRest *gcRest      = [[GCRest alloc] init];
    
    [gcRest getRequestInBackgroundWithPath:_path withResponse:^(id response) {
        
        NSMutableArray *_result = [[[NSMutableArray alloc] init] autorelease];
        for (NSDictionary *_dic in [response objectForKey:@"data"]) {
            id _obj = [[[self alloc] initWithDictionary:_dic] autorelease];
            [_result addObject:_obj];
        }
        aResponseBlock(_result);
    } andError:anErrorBlock];
        
    [gcRest release];
    [_path release];
}

+ (id)findById:(NSUInteger) objectID {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [self elementName], objectID];
    NSError *_error     = nil;
    GCRest *gcRest      = [[GCRest alloc] init];
    id _response        = [gcRest getRequestWithPath:_path andError:&_error];
    
    //Parse the Response to make proper objects of this class.
    id _obj = nil;
    _obj = [[self alloc] initWithDictionary:_response];
    
    [gcRest release];
    [_path release];
    return [_obj autorelease];
}

+ (void)findById:(NSUInteger) objectID 
inBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock 
        andError:(ChuteErrorBlock) anErrorBlock {
    
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [self elementName], objectID];
    GCRest *gcRest      = [[GCRest alloc] init];
    [gcRest getRequestInBackgroundWithPath:_path withResponse:^(id response) {
        id _obj = [[[self alloc] initWithDictionary:response] autorelease];
        aResponseBlock(_obj);
    } andError:anErrorBlock];
    
    [gcRest release];
    [_path release];
}

#pragma mark - Override these methods in every Subclass
+ (NSString *)elementName {
    //for example, this should return the string "chutes", "assets", "bundles", "parcels"
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

- (id) initWithDictionary:(NSDictionary *) dictionary {
    [self init];
    for (NSString *key in [dictionary allKeys]) {
        [self setObject:[dictionary objectForKey:key] forKey:key];
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

#pragma mark - Common Meta Data Methods

- (NSDictionary *) getMetaData {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    
    NSError *_error     = nil;
    GCRest *gcRest      = [[GCRest alloc] init];
    id _response        = [gcRest getRequestWithPath:_path andError:&_error];
    [gcRest release];
    [_path release];
    return [_response objectForKey:@"data"];
}

- (id) getMetaDataForKey:(NSString *) key {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    
    NSError *_error     = nil;
    GCRest *gcRest      = [[GCRest alloc] init];
    id _response        = [gcRest getRequestWithPath:_path andError:&_error];
    [gcRest release];
    [_path release];
    return [_response objectForKey:@"data"];
}

- (BOOL) setMetaData:(NSDictionary *) metaData {
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[[metaData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];

    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    NSError *_error             = nil;
    
    GCRest *gcRest              = [[GCRest alloc] init];
    [gcRest postRequestWithPath:_path andParams:_params andError:&_error];
    [gcRest release];
    [_path release];
    [_params release];
    
    if (_error == nil) {
        return YES;
    }
    DLog(@"%@", [_error localizedDescription]);
    return NO;
}

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key {
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[data dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    NSError *_error             = nil;
    
    GCRest *gcRest              = [[GCRest alloc] init];
    [gcRest putRequestWithPath:_path andParams:_params andError:&_error];
    [gcRest release];
    [_path release];
    [_params release];
    
    if (_error == nil) {
        return YES;
    }
    DLog(@"%@", [_error localizedDescription]);
    return NO;
}

- (BOOL) deleteMetaData {
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta", API_URL, [[self class] elementName], [self objectID]];
    NSError *_error             = nil;
    
    GCRest *gcRest              = [[GCRest alloc] init];
    [gcRest deleteRequestWithPath:_path andParams:nil andError:&_error];
    [gcRest release];
    [_path release];
    
    if (_error == nil) {
        return YES;
    }
    return NO;
}

- (BOOL) deleteMetaDataForKey:(NSString *) key {
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@%@/%d/meta/%@", API_URL, [[self class] elementName], [self objectID], key];
    NSError *_error             = nil;
    
    GCRest *gcRest              = [[GCRest alloc] init];
    [gcRest deleteRequestWithPath:_path andParams:nil andError:&_error];
    [gcRest release];
    [_path release];
    
    if (_error == nil) {
        return YES;
    }
    return NO;
}

- (NSUInteger) objectID {
    return [[_content objectForKey:@"id"] intValue];
}

#pragma mark - Instance Method Calls

- (BOOL) save {
    return NO;
}

- (void) saveInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock 
                               andError:(ChuteErrorBlock) anErrorBlock {
    
}

- (BOOL) destroy {
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [[self class] elementName], [self objectID]];
    NSError *_error     = nil;
    
    GCRest *gcRest      = [[GCRest alloc] init];
    [gcRest deleteRequestWithPath:_path andParams:nil andError:&_error];
    [gcRest release];
    [_path release];
    
    if (_error == nil) {
        return YES;
    }
    return NO;
}

- (void) destroyInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock 
                                  andError:(ChuteErrorBlock) anErrorBlock {
    
    NSString *_path     = [[NSString alloc] initWithFormat:@"%@%@/%d", API_URL, [[self class] elementName], [self objectID]];
    GCRest *gcRest      = [[GCRest alloc] init];
    [gcRest deleteRequestInBackgroundWithPath:_path andParams:nil withResponse:aResponseBlock andError:anErrorBlock];
    [gcRest release];
    [_path release];
}

@end
