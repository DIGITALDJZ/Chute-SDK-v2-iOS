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

+ (GCUploader *)sharedUploader;
+ (NSString *)generateTimestamp;

- (void)uploadFiles:(NSArray *)files success:(void (^) (NSArray *files))success failure:(void (^)(NSError *error))failure;
- (void)uploadFiles:(NSArray *)files inAlbumsWithIDs:(NSArray *)albumIDs success:(void (^) (NSArray *files))success failure:(void (^)(NSError *error))failure;

@end
