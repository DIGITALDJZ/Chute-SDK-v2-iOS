//
//  AssetManager.m
//  ChuteSDK
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChuteAssetManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ChuteAsset.h"
#import "ChuteAssetUploader.h"
#import "ChuteAPI.h"

static ChuteAssetManager *shared=nil;
NSString * const ChuteAssetManagerAssetsAdded = @"ChuteAssetManagerAssetsAdded";

@interface ChuteAssetManager (private)

- (void)assetEnumerationDidComplete;
- (void)addAsset:(id)asset;

@end

@implementation ChuteAssetManager
@synthesize assetsArray;
@synthesize uploadingAssets = uploads;
@synthesize responseBlock = b_ResponseBlock;
@synthesize errorBlock = b_ErrorBlock;


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

    [_asset release];
}

- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock {
    
    if (assetsArray) {
        [assetsArray release], assetsArray = nil;
    }
    
    assetsArray = [[NSMutableArray alloc] init];
    
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
            if (aCompletionBlock) {
                aCompletionBlock();
            }
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

- (void)loadAssets {
    [self loadAssetsCompletionBlock:nil];
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
    
    [[ChuteAPI shared] createParcelWithFiles:_filesToVerify andChutes:chutes andResponse:^(id response) {
        [ChuteAssetUploader uploadAssets:[response objectForKey:@"uploads"]];
        NSLog(@"%@", @"SUCCESS");
    } andError:^(NSError *error) {
        NSLog(@"%@", @"ERROR");
    }];
    
    [_filesToVerify release];
}


- (void)syncWithResponse:(void (^)(void))aResponseBlock
                andError:(void (^)(NSError *))anErrorBlock{
    // make sure only one sync process happens at once
    self.responseBlock = aResponseBlock;
    self.errorBlock    = anErrorBlock;
    
    
    __block typeof(self) bself = self;
    
    [self loadAssetsCompletionBlock:^(void) {
        [bself startUploadingAssets:bself.assetsArray forChutes:[NSArray array]];
    }];
}
@end
