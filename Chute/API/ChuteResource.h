//
//  ChuteResource.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChuteNetwork.h"

@interface ChuteResource : NSObject {
    NSMutableDictionary *_content;
}

/* Get all Objects of this class */
+ (NSArray *)all;
+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock andError:(ChuteErrorBlock) anErrorBlock;

//Methods to Override in SubClass
+ (NSString *)pathForAllRequest;
+ (BOOL)supportsMetaData;
+ (NSString *)elementName;


- (void) setObject:(id) aObject forKey:(id)aKey;
- (id) objectForKey:(id)aKey;

//Common Get Data Methods
- (NSDictionary *) getMetaData;
- (NSUInteger) objectID;


@end
