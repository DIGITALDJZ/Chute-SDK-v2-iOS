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
   
    context(@"Create an upload", ^{
       
        it(@"should generate timestamp", ^{
            
            NSString *timestamp = [GCUploader generateTimestamp];
            [timestamp shouldNotBeNil];
            NSLog(@"Timestamp: %@", timestamp);
        });
        
        it(@"should create an upload request", ^{
            GCClient *apiClient = [GCClient sharedClient];
            [apiClient setAuthorizationHeaderWithToken:@"36de240aee63494fb0986ed74e87b3285616638698baf90a9eec511c2d4ee0f8"];
            
            __block id fetchedUploads;
            __block id fetchedUploadingAsset;
            __block id fetchedID;
            __block id fetchedError;
            
            NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute" ofType:@"png"];
            
            [GCUploader requestFilesForUpload:@[[GCFile fileAtPath:filePath]] success:^(GCUploads *uploads) {
                fetchedUploads = uploads;
                fetchedUploadingAsset = uploads.assets[0];
                fetchedID = uploads.id;
            } failure:^(NSError *error) {
                fetchedError = error;
            }];
            
            [[expectFutureValue(fetchedError) shouldEventuallyBeforeTimingOutAfter(5.0)] beNil];
            [[expectFutureValue(fetchedUploads) shouldEventuallyBeforeTimingOutAfter(5.0)] beKindOfClass:[GCUploads class]];
            [[expectFutureValue(fetchedID) shouldEventuallyBeforeTimingOutAfter(5.0)] beKindOfClass:[NSString class]];
            [[expectFutureValue(fetchedUploadingAsset) shouldEventuallyBeforeTimingOutAfter(5.0)] beKindOfClass:[GCUploadingAsset class]];
            
            
//            NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"chute" ofType:@"png"];
//            DCParserConfiguration *configuration= [DCParserConfiguration configuration];
//            DCObjectMapping *fileNameMapper = [DCObjectMapping mapKeyPath:@"filename" toAttribute:@"fileName" onClass:[GCFile class]];
//            DCObjectMapping *fileSizeMapper = [DCObjectMapping mapKeyPath:@"size" toAttribute:@"fileSize" onClass:[GCFile class]];
//            DCObjectMapping *fileMD5Mapper = [DCObjectMapping mapKeyPath:@"md5" toAttribute:@"MD5Hash" onClass:[GCFile class]];
//            [configuration addObjectMapping:fileNameMapper];
//            [configuration addObjectMapping:fileSizeMapper];
//            [configuration addObjectMapping:fileMD5Mapper];
//            DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCFile class] andConfiguration:configuration];
//            NSArray *files = @[[mapping serializeObject:[GCFile fileAtPath:filePath]]];
//            
//            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"uploads" parameters:@{@"files":files}];
//            
//            __block id data;
//            
//            void (^success)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                data = JSON;
//                NSLog(@"DATA: %@", JSON);
//            };
//            void (^failure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                data = error;
//                NSLog(error);
//            };
//            
//            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
//            [operation start];
//            [[data shouldEventuallyBeforeTimingOutAfter(5.0)] beKindOfClass:[NSDictionary class]];
        });
        
    });
});

SPEC_END


