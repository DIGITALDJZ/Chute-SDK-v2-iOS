//
//  AssetManager.m
//  ChuteSDK
//
//  Created by Gaurav Sharma on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChuteAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ChuteAsset.h"
#import "ChuteAssetUploader.h"

static ChuteAssetManager *shared=nil;
NSString * const ChuteAssetManagerAssetsAdded = @"ChuteAssetManagerAssetsAdded";

@interface ChuteAssetManager (private)

- (void)assetEnumerationDidComplete;
- (void)addAsset:(id)asset;

@end

@implementation ChuteAssetManager
@synthesize assetsArray;
@synthesize uploadingAssets = uploads;

+ (ChuteAssetManager*)shared{
	@synchronized(shared){
		if (!shared) {
			shared = [[ChuteAssetManager alloc] init];
		}
	}
	return shared;
}

- (id)init{
    self = [super init];
    if (self) {
        assetsArray = [[NSMutableArray alloc] init];
        uploads = [[NSMutableArray alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"prepareUpload" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        [uploads addObject:[self assetForURL:[notification object]]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadsUpdated" object:nil];
    }];
         
    [[NSNotificationCenter defaultCenter] addObserverForName:@"doneUpload" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        [uploads removeObject:[self assetForURL:[notification object]]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadsUpdated" object:nil];
    }];

    return self;
}

- (void)dealloc{
    [uploads release];
    [assetsArray release];
    [super dealloc];
}

- (void)addAsset:(id)anAlAsset{
    NSString *_url     = [[[anAlAsset defaultRepresentation] url] absoluteString];
    ChuteAsset *_asset = [[ChuteAsset alloc] initWithAsset:anAlAsset andURL:_url];
    
    [self.assetsArray addObject:_asset];
}

- (void)loadAssets {
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if(result != nil)
        {
            [self addAsset:result];
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            [self assetEnumerationDidComplete];
            return;
        }
        
        [group enumerateAssetsUsingBlock:assetEnumerator];
    };
    
    void (^assetFailureBlock)(NSError *) = ^(NSError *error)
    {
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetFailureBlock];
    [assetsLibrary release];
}

- (void)assetEnumerationDidComplete {
    [[NSNotificationCenter defaultCenter] postNotificationName:ChuteAssetManagerAssetsAdded object:self];
}

- (ChuteAsset *)assetForURL:(NSString *)url {
    for (ChuteAsset *_asset in assetsArray) {
        if ([url isEqualToString:[_asset url]]) {
            return _asset;
        }
    }
    return nil;
}

//Chutes is an array of Chute IDs
- (void)startUploadingAssets:(NSArray *) assets forChutes:(NSArray *) chutes {
    NSMutableArray *_filesToVerify = [NSMutableArray new];

    for (ChuteAsset *asset in assets) {
        ALAsset *_alAsset                       = asset.alAsset;
        ALAssetRepresentation *_representation  = [_alAsset defaultRepresentation];
        NSDictionary *_file                     = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   asset.url, @"filename", 
                                                   [NSString stringWithFormat:@"%d", [_representation size]], @"size", 
                                                   [NSString stringWithFormat:@"%d", [_representation size]], @"md5", 
                                                   nil];
        [_filesToVerify addObject:_file];
    }
    
    NSString *_fileAsString = [_filesToVerify JSONRepresentation];
    [_filesToVerify release];
    
    ASIFormDataRequest *postRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", API_URL, kChuteParcels]]];
    
    [postRequest setPostValue:_fileAsString forKey:@"files"];
    
    
    [postRequest setPostValue:[chutes JSONRepresentation] forKey:@"chutes"];
    [postRequest startSynchronous];
    
    [ChuteAssetUploader uploadAssets:[[[postRequest responseString] JSONValue] objectForKey:@"uploads"]];
}

@end
