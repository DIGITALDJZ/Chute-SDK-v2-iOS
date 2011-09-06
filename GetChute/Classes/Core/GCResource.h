//
//  ChuteResource.h
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRest.h"

@class GCResponseObject;

@interface GCResource : NSObject {
    NSMutableDictionary *_content;
}

/* Get all Objects of this class */
+ (GCResponseObject *)all;
+ (void)allInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

//Find Specific object data with Id
+ (GCResponseObject *)findById:(NSUInteger) objectID;
+ (void)findById:(NSUInteger) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

//Methods to Override in SubClass
+ (BOOL)supportsMetaData;
+ (NSString *)elementName;

- (void) setObject:(id) aObject forKey:(id)aKey;
- (id) objectForKey:(id)aKey;

//Common Meta Data Methods
+ (GCResponseObject *) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value;
+ (void) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (GCResponseObject *) getMetaData;
- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (id) getMetaDataForKey:(NSString *) key;
- (void) getMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) setMetaData:(NSDictionary *) metaData;
- (void) setMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key;
- (void) setMetaData:(NSString *) data forKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) deleteMetaData;
- (void) deleteMetaDataInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) deleteMetaDataForKey:(NSString *) key;
- (void) deleteMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

//Common Get Data Methods
- (NSUInteger) objectID;

//Instance Method Calls
- (BOOL) save;
- (void) saveInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) destroy;
- (void) destroyInBackgroundWithCompletion:(GCBoolBlock) aResponseBlock;


@end
