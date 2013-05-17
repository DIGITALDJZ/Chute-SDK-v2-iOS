//
//  GCUploader.h
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/7/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class GCFile, GCUploads;

@interface GCUploader : AFHTTPClient {
    
}

@property (strong, nonatomic) NSNumber *assetsUploadedCount;
@property (strong, nonatomic) NSNumber *assetsTotalCount;

@property (strong, nonatomic) NSNumber *maxFileSize;

+ (NSString *)generateTimestamp;
+ (void)requestFilesForUpload:(NSArray *)files success:(void (^)(GCUploads *uploads))successsuccess failure:(void (^)(NSError *error))failure;

@end
