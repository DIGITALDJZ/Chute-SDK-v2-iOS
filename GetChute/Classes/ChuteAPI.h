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
- (void)getProfileInfoWithResponse:(ResponseBlock)aResponseBlock
                          andError:(ErrorBlock)anErrorBlock;

- (void)getMyChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                       andError:(ErrorBlock)anErrorBlock;

- (void)getPublicChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                           andError:(ErrorBlock)anErrorBlock;

- (void)getChutesForId:(NSString *)Id 
              response:(void (^)(NSArray *))aResponseBlock 
              andError:(ErrorBlock)anErrorBlock;

- (void)getAssetsForChuteId:(NSUInteger)chuteId
                   response:(void (^)(NSArray *))aResponseBlock 
                   andError:(ErrorBlock)anErrorBlock;

- (void)getInboxParcelsWithResponse:(void (^)(NSArray *))aResponseBlock
                           andError:(ErrorBlock)anErrorBlock;

- (void)getCommentsForChuteId:(NSString *)chuteId
                      assetId:(NSString *)assetId
                     response:(void (^)(NSArray *))aResponseBlock 
                     andError:(ErrorBlock)anErrorBlock;

- (void)getMetaDataforChuteId:(NSString *)Id 
                     response:(ResponseBlock)aResponseBlock 
                     andError:(ErrorBlock)anErrorBlock;

- (void)getMetaDataforAssetId:(NSString *)Id 
                     response:(ResponseBlock)aResponseBlock 
                     andError:(ErrorBlock)anErrorBlock;

- (void)getMyMetaDataWithResponse:(ResponseBlock)aResponseBlock
                         andError:(ErrorBlock)anErrorBlock;

//Post Data
- (void)createChute:(NSString *)name 
         withParent:(NSUInteger)parentId
 withPermissionView:(NSUInteger)permissionView
      andAddMembers:(NSUInteger)addMembers
       andAddPhotos:(NSUInteger)addPhotos
        andResponse:(ResponseBlock)responseBlock 
           andError:(ErrorBlock)errorBlock;

- (void)postComment:(NSString *)comment
         ForChuteId:(NSString *)chuteId
         andAssetId:(NSString *)assetId
           response:(void (^)(id))aResponseBlock 
           andError:(ErrorBlock)anErrorBlock;

- (void)setMetaData:(NSDictionary *)dictionary
         forChuteId:(NSString *)Id 
           response:(ResponseBlock)aResponseBlock 
           andError:(ErrorBlock)anErrorBlock;

- (void)setMetaData:(NSDictionary *)dictionary
         forAssetId:(NSString *)Id 
           response:(ResponseBlock)aResponseBlock 
           andError:(ErrorBlock)anErrorBlock;

- (void)setMyMetaData:(NSDictionary *)dictionary
         WithResponse:(ResponseBlock)aResponseBlock
             andError:(ErrorBlock)anErrorBlock;

//Helper methods for Asset Uploader
- (void)initThumbnail:(UIImage *)thumbnail
           forAssetId:(NSString *)assetId
          andResponse:(ResponseBlock)aResponseBlock
             andError:(ErrorBlock)anErrorBlock;

- (void)getTokenForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock;

- (void)completeForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock;


- (void) test;

- (void)startUploadingAssets:(NSArray *) assets forChutes:(NSArray *) chutes;

- (void)syncWithResponse:(void (^)(void))aResponseBlock
                andError:(ErrorBlock)anErrorBlock;

- (void)createParcelWithFiles:(NSArray *)filesArray
                    andChutes:(NSArray *)chutesArray
                  andResponse:(ResponseBlock)aResponseBlock
                     andError:(ErrorBlock)anErrorBlock;

@end
