//
//  ChuteAPI.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "GCMacros.h"

typedef void (^ErrorBlock)(NSError *);
typedef void (^ResponseBlock)(id);

@interface ChuteAPI : NSObject {
}

+ (ChuteAPI *)shared;

//Data Wrappers
//Get Data
- (void)getPublicChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                           andError:(ErrorBlock)anErrorBlock;

- (void)getInboxParcelsWithResponse:(void (^)(NSArray *))aResponseBlock
                           andError:(ErrorBlock)anErrorBlock;

@end
