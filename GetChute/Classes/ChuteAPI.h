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

- (void)getCommentsForChuteId:(NSString *)chuteId
                      assetId:(NSString *)assetId
                     response:(void (^)(NSArray *))aResponseBlock 
                     andError:(ErrorBlock)anErrorBlock;

- (void)getMyMetaDataWithResponse:(ResponseBlock)aResponseBlock
                         andError:(ErrorBlock)anErrorBlock;

//Post Data
- (void)postComment:(NSString *)comment
         ForChuteId:(NSString *)chuteId
         andAssetId:(NSString *)assetId
           response:(void (^)(id))aResponseBlock 
           andError:(ErrorBlock)anErrorBlock;

- (void)setMyMetaData:(NSDictionary *)dictionary
         WithResponse:(ResponseBlock)aResponseBlock
             andError:(ErrorBlock)anErrorBlock;

@end
