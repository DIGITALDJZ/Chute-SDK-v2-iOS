//
//  GCAsset.h
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCResource.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString * const GCAssetStatusChanged;
NSString * const GCAssetProgressChanged;

typedef enum {
    GCAssetStateNew = 0,
    GCAssetStateInitializingThumbnail,
    GCAssetStateInitializingThumbnailFailed,
    GCAssetStateGettingToken,
    GCAssetStateGettingTokenFailed,
    GCAssetStateUploadingToS3,
    GCAssetStateUploadingToS3Failed,
    GCAssetStateCompleting,
    GCAssetStateCompletingFailed,
    GCAssetStateFinished
} GCAssetStatus;

@interface GCAsset : GCResource

@property (nonatomic, retain) ALAsset *alAsset;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) GCAssetStatus status;

- (NSString*)urlStringForImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;

- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height;

- (void)imageForWidth:(NSUInteger)width 
            andHeight:(NSUInteger)height 
inBackgroundWithCompletion:(void (^)(UIImage *))aResponseBlock;

@end
