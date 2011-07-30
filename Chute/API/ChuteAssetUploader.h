//
//  ChuteAssetUploader.h
//  ChuteSDK
//
//  Created by Gaurav Sharma on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const ChuteAssetUploaderStatusChanged;

typedef enum {
    ChuteAssetUploaderStateNew,
    ChuteAssetUploaderStateInitializingThumbnail,
    ChuteAssetUploaderStateInitializingThumbnailFailed,
    ChuteAssetUploaderStateGettingToken,
    ChuteAssetUploaderStateGettingTokenFailed,
    ChuteAssetUploaderStateUploadingToS3,
    ChuteAssetUploaderStateUploadingToS3Failed,
    ChuteAssetUploaderStateCompleting,
    ChuteAssetUploaderStateCompletingFailed,
    ChuteAssetUploaderStateFinished
} ChuteAssetUploaderStatus;

@interface ChuteAssetUploader : NSObject {
    NSDictionary *assetDetails;
    ChuteAssetUploaderStatus status;
    id delegate;
    UIImage *thumbnail;
    float uploadProgress;
}

@property (nonatomic, retain) NSDictionary *assetDetails;
@property (nonatomic, assign) ChuteAssetUploaderStatus status;
@property (nonatomic, assign) float uploadProgress;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIImage *thumbnail;

+ (void)uploadAssets:(NSArray *)uploads;
- (NSString *)statusDescription;

@end
