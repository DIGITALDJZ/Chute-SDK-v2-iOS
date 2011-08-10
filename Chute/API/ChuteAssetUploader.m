//
//  ChuteAssetUploader.m
//  ChuteSDK
//
//  Created by Gaurav Sharma on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChuteAssetUploader.h"
#import "ChuteAPI.h"
#import "ChuteAssetManager.h"
#import "ASIHTTPRequest.h"
#import "ChuteAsset.h"

#import "SBJson.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <dispatch/dispatch.h>

NSString * const ChuteAssetUploaderStatusChanged = @"ChuteAssetUploaderStatusChanged";

static dispatch_queue_t _queue;
static dispatch_semaphore_t _semaphore;

@implementation ChuteAssetUploader

@synthesize assetDetails;
@synthesize status;
@synthesize delegate;
@synthesize thumbnail;
@synthesize uploadProgress;

- (id)initWithAsset:(NSDictionary *)anAsset{
    self = [super init];
    if (self) {
        self.assetDetails   = anAsset;
        self.status         = ChuteAssetUploaderStateNew;
    }
    return self;
}

- (void)dealloc{
    [assetDetails release];
    [delegate release];
    [thumbnail release];
    [super dealloc];
}

- (NSString *)statusDescription{
    switch (status) {
        case ChuteAssetUploaderStateNew:
            return @"New";
        case ChuteAssetUploaderStateInitializingThumbnail:
            return @"Initializing Thumbnail";
        case ChuteAssetUploaderStateInitializingThumbnailFailed:
            return @"Initializing Thumbnail Failed";
        case ChuteAssetUploaderStateGettingToken:
            return @"Generating Token";
        case ChuteAssetUploaderStateGettingTokenFailed:
            return @"Generating Token Failed";
        case ChuteAssetUploaderStateUploadingToS3:
            return @"Uploading to Server";
        case ChuteAssetUploaderStateUploadingToS3Failed:
            return @"Uploading to Server Failed";
        case ChuteAssetUploaderStateCompleting:
            return @"Completing";
        case ChuteAssetUploaderStateCompletingFailed:
            return @"Completion Failed";
        case ChuteAssetUploaderStateFinished:
            return @"Finished";
        default:
            return @"Unknown";
    }
}

- (BOOL)isInProgress{
    switch (status) {
        case ChuteAssetUploaderStateNew:
        case ChuteAssetUploaderStateInitializingThumbnail:
        case ChuteAssetUploaderStateGettingToken:
        case ChuteAssetUploaderStateUploadingToS3:
        case ChuteAssetUploaderStateCompleting:
            return YES;
        default:
            return NO;
    }
}

- (void)setStatus:(ChuteAssetUploaderStatus)astatus{
    status = astatus;
    
    if (![self isInProgress]) {
        dispatch_semaphore_signal(_semaphore);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChuteAssetUploaderStatusChanged object:self];
}

- (void)uploadAssetToS3:(ChuteAsset*)chuteAsset withDetails:(NSDictionary *)uploadDetails{
    self.status = ChuteAssetUploaderStateUploadingToS3;

    NSMutableData *_imageData = [UIImageJPEGRepresentation([UIImage imageWithCGImage:[[chuteAsset.alAsset defaultRepresentation] fullResolutionImage]], 1.0) mutableCopy];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[uploadDetails objectForKey:@"upload_url"]]];
	[request setDelegate:self];
    [request setUploadProgressDelegate:self];
	[request setRequestMethod:@"PUT"];
    [request setPostBody:_imageData];

	[request addRequestHeader:@"Date" value:[uploadDetails objectForKey:@"date"]];
	[request addRequestHeader:@"Authorization" value:[uploadDetails objectForKey:@"signature"]];
	[request addRequestHeader:@"Content-Type" value:[uploadDetails objectForKey:@"content_type"]];
    [request addRequestHeader:@"x-amz-acl" value:@"public-read"];

	[request setDidFinishSelector:@selector(fileUploadDone:)];
	[request setDidFailSelector:@selector(fileUploadFailed:)];

	[request startAsynchronous];
}

- (void)setProgress:(float)newProgress{
    self.uploadProgress = newProgress;
    if ([delegate respondsToSelector:@selector(progressChanged:)]) {
        [delegate performSelector:@selector(progressChanged:) withObject:self];
    }
    
    NSString *_fileUrl = [assetDetails objectForKey:@"file_path"];    
    ChuteAsset *_asset = [[ChuteAssetManager shared] assetForURL:_fileUrl];
    [_asset setProgress:newProgress];
}

- (void)fileUploadDone:(ASIHTTPRequest *)request{
    self.status = ChuteAssetUploaderStateCompleting;
    DLog();
    [[ChuteAPI shared] completeForAssetId:[assetDetails objectForKey:@"asset_id"] andResponse:^(id response) {
        self.status = ChuteAssetUploaderStateFinished;
        DLog(@"%@", response);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doneUpload" object:[assetDetails objectForKey:@"file_path"]];
    } andError:^(NSError *error) {
        self.status = ChuteAssetUploaderStateCompletingFailed;
        DLog(@"Asset Completion Failed: %@", [error localizedDescription]);
    }];
}

- (void)fileUploadFailed:(ASIHTTPRequest *)request{
    self.status = ChuteAssetUploaderStateUploadingToS3Failed;
    DLog(@"Upload Failed: %@", [[request error] localizedDescription]);
}

- (void)prepareToUpload{    
    NSString *_fileUrl = [assetDetails objectForKey:@"file_path"];
    
    ChuteAsset *_asset = [[ChuteAssetManager shared] assetForURL:_fileUrl];
    
    self.status     = ChuteAssetUploaderStateInitializingThumbnail;
    self.thumbnail  = _asset.thumbnail;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"prepareUpload" object:[assetDetails objectForKey:@"file_path"]];
    
    dispatch_async(_queue, ^{
        
        if ([[self.assetDetails objectForKey:@"status"] isEqualToString:@"new"]) {
            
            [[ChuteAPI shared] initThumbnail:self.thumbnail forAssetId:[assetDetails objectForKey:@"asset_id"] andResponse:^(id thumbnailResponse) {
                
                [[ChuteAPI shared] getTokenForAssetId:[assetDetails objectForKey:@"asset_id"] andResponse:^(id tokenResponse) {
                    [self uploadAssetToS3:_asset withDetails:tokenResponse];
                } andError:^(NSError *tokenError) {
                    self.status = ChuteAssetUploaderStateInitializingThumbnailFailed;
                    DLog(@"Token Failed: %@", [tokenError localizedDescription]);
                }];
                
            } andError:^(NSError *thumbnailerror) {
                DLog(@"Thumbnail Failed: %@", [thumbnailerror localizedDescription]);
            }];
            
        } else {
            
            [[ChuteAPI shared] getTokenForAssetId:[assetDetails objectForKey:@"asset_id"] andResponse:^(id tokenResponse) {
                [self uploadAssetToS3:_asset withDetails:tokenResponse];
            } andError:^(NSError *tokenError) {
                self.status = ChuteAssetUploaderStateInitializingThumbnailFailed;
                DLog(@"Token Failed: %@", [tokenError localizedDescription]);
            }];
            
        }
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    });
}

+ (void)uploadAssets:(NSArray *)uploads{
    _queue     = dispatch_queue_create("com.chute.upload", 0);
    _semaphore = dispatch_semaphore_create((long) 2);

    for (NSDictionary *_asset in uploads) {
        if ([[_asset objectForKey:@"status"] isEqualToString:@"new"] || 
            [[_asset objectForKey:@"status"] isEqualToString:@"initialized"] || 
            [[_asset objectForKey:@"status"] isEqualToString:@"error"]){
            
            ChuteAssetUploader *_uploader = [[ChuteAssetUploader alloc] initWithAsset:_asset];
            [_uploader prepareToUpload];
        }
    }
}

@end