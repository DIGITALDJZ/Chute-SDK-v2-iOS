//
//  AssetManager.h
//  ChuteSDK
//
//  Created by Gaurav Sharma on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChuteConstants.h"

extern NSString * const ChuteAssetManagerAssetsAdded;

@class ChuteAsset;

@interface ChuteAssetManager : NSObject {    
    NSMutableArray *assetsArray;
    NSMutableArray *uploads;
}

@property (nonatomic, retain) NSMutableArray *assetsArray;
@property (nonatomic, readonly) NSMutableArray *uploadingAssets;

+ (ChuteAssetManager*)shared;
- (void)loadAssets;

- (void)startUploadingAssets:(NSArray *) assets forChutes:(NSArray *) chutes;
- (ChuteAsset *)assetForURL:(NSString *)url;

@end
