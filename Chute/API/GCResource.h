//
//  ChuteResource.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRest.h"

@interface GCResource : NSObject {
    NSMutableDictionary *_content;
}

/* Get all Objects of this class */
+ (NSArray *)all;
+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock 
                             andError:(ChuteErrorBlock) anErrorBlock;

//Find Specific object data with Id
+ (id)findById:(NSUInteger) objectID;
+ (void)findById:(NSUInteger) objectID inBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock 
        andError:(ChuteErrorBlock) anErrorBlock;

//Methods to Override in SubClass
+ (BOOL)supportsMetaData;
+ (NSString *)elementName;


- (void) setObject:(id) aObject forKey:(id)aKey;
- (id) objectForKey:(id)aKey;

//Common Meta Data Methods
- (NSDictionary *) getMetaData;
- (BOOL) setMetaData:(NSDictionary *) metaData;

//Common Get Data Methods
- (NSUInteger) objectID;

@end
