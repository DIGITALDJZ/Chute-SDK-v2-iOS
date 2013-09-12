//
//  GCUploaderSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/7/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCUploader.h"
#import "GCClient.h"
#import "GCFile.h"
#import "GCUploads.h"
#import "GCUploadingAsset.h"

SPEC_BEGIN(GCUploaderSpec)

describe(@"GCUploader", ^{
        
    context(@"upload", ^{
        
        it(@"images", ^{
            
            __block NSNumber *isSuccess = nil;
            GCClient *apiClient = [GCClient sharedClient];
            [apiClient setAuthorizationHeaderWithToken:@"36de240aee63494fb0986ed74e87b3285616638698baf90a9eec511c2d4ee0f8"];
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *imagePath = [bundle pathForResource:@"chute" ofType:@"jpg"];
            NSString *imagePath2 = [bundle pathForResource:@"chute" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            UIImage *image2 = [UIImage imageWithContentsOfFile:imagePath2];
            NSArray *images = @[image, image2];
            
            [[GCUploader sharedUploader] uploadImages:images inAlbumWithID:@(2425529) progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
            } success:^(NSArray *assets){
                isSuccess = @YES;
            } failure:^(NSError *error) {
                isSuccess = @NO;
            }];
            
            [[expectFutureValue(isSuccess) shouldEventuallyBeforeTimingOutAfter(120.0)] equal:@NO];
            
        });
        
        it(@"should generate timestamp", ^{
            
            NSString *timestamp = [GCUploader generateTimestamp];
            [timestamp shouldNotBeNil];
            NSLog(@"Timestamp: %@", timestamp);
        });
        
        it(@"files", ^{
            GCClient *apiClient = [GCClient sharedClient];
            [apiClient setAuthorizationHeaderWithToken:@"36de240aee63494fb0986ed74e87b3285616638698baf90a9eec511c2d4ee0f8"];
            
            //            __block id fetchedUploads;
            //            __block id fetchedUploadingAsset;
            //            __block id fetchedID;
            //            __block id fetchedError;
            
            NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute" ofType:@"jpg"];
            NSString *filePath2 = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute2" ofType:@"jpg"];
            NSString *filePath3 = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute3" ofType:@"jpg"];
            NSString *filePath4 = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute4" ofType:@"jpg"];
            
            //            [GCUploader requestFilesForUpload:@[[GCFile fileAtPath:filePath]] success:^(GCUploads *uploads) {
            //                fetchedUploads = uploads;
            //                fetchedUploadingAsset = uploads.assets[0];
            //                fetchedID = uploads.id;
            //            } failure:^(NSError *error) {
            //                fetchedError = error;
            //            }];
            
            __block NSArray *assets = nil;
            __block NSError *error = nil;
            [[GCUploader sharedUploader] uploadFiles:@[[GCFile fileAtPath:filePath], [GCFile fileAtPath:filePath2], [GCFile fileAtPath:filePath3], [GCFile fileAtPath:filePath4]] progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
                
            }  success:^(NSArray *files) {
                assets = files;
            } failure:^(NSError *error) {
                error = error;
            }];
            
            [[expectFutureValue(assets) shouldEventuallyBeforeTimingOutAfter(120.0)] beNonNil];
            [[expectFutureValue(error) shouldEventuallyBeforeTimingOutAfter(300.0)] beNil];

        });
        
    });
});

SPEC_END


