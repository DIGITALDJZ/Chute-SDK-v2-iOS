//
//  GCUploader.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCUploader.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCFile.h"
#import "GCUploads.h"
#import "GCResponse.h"
#import "AFJSONRequestOperation.h"

static NSString * const kGCBaseURLString = @"https://upload.getchute.com/";

static NSString * const kGCFiles = @"files";
static NSString * const kGCData = @"data";

@implementation GCUploader

@synthesize assetsUploadedCount, assetsTotalCount, maxFileSize;

+ (NSString *)generateTimestamp
{
    //var timestamp =  ("" + (d.getTime()-d.getMilliseconds())/1000 + "-" + Math.random()).replace("0.", "")

    NSDate *date = [NSDate date];
    NSNumber *epochTime = @(floor([date timeIntervalSince1970]));
    NSString *timestamp = [NSString stringWithFormat:@"%@-%u%u", epochTime, arc4random(), arc4random()];
    return [timestamp substringToIndex:28];
}

+ (void)requestFilesForUpload:(NSArray *)files success:(void (^)(GCUploads *uploads))success failure:(void (^)(NSError *error))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    __block NSMutableArray *fileDictionaries = [[NSMutableArray alloc] initWithCapacity:[files count]];
    
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GCFile *file = (GCFile *)obj;
        [fileDictionaries addObject:[file serialize]];
    }];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"uploads" parameters:@{kGCFiles:fileDictionaries}];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        GCUploads *uploads = [GCUploads uploadsFromDictionary:[JSON objectForKey:kGCData]];
        success(uploads);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", JSON);
        
        failure(error);
        
    }];
    
    
    [operation start];
}

@end
