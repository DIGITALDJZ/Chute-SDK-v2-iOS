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
- (GCResponseObject *) getMetaData;
- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;
- (id) getMetaDataForKey:(NSString *) key;
- (BOOL) setMetaData:(NSDictionary *) metaData;
- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key;
- (BOOL) deleteMetaData;
- (BOOL) deleteMetaDataForKey:(NSString *) key;

//Common Get Data Methods
- (NSUInteger) objectID;

//Instance Method Calls
- (BOOL) save;
- (void) saveInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) destroy;
- (void) destroyInBackgroundWithCompletion:(GCBoolBlock) aResponseBlock;


@end
