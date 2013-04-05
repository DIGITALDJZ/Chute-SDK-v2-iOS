//
//  GCServiceAsset.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCPagination, GCAsset, GCCoordinate;

@interface GCServiceAsset : NSObject

+ (void)getAssetsForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *, NSArray *, GCPagination *))success failure:(void (^)(NSError *))failure;
+ (void)getAssetsWithSuccess:(void (^)(GCResponseStatus *response, NSArray *albums, GCPagination *pagination))success
                     failure:(void (^)(NSError *error))failure;
+ (void)importAssetsFromURLs:(NSArray *)urls success:(void (^)(GCResponseStatus *, NSArray *, GCPagination *))success failure:(void (^)(NSError *))failure;
+ (void)importAssetsFromURLs:(NSArray *)urls forAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *, NSArray *, GCPagination *))success failure:(void (^)(NSError *))failure;
+ (void)updateAssetWithID:(NSNumber *)assetID caption:(NSString *)caption success:(void (^)(GCResponseStatus *, GCAsset *))success failure:(void (^)(NSError *))failure;
+ (void)deleteAssetWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure;
+ (void)getGeoCoordinateForAssetWithID:(NSNumber *)assetID success:(void (^)(GCResponseStatus *, GCCoordinate *))success failure:(void (^)(NSError *))failure;
+ (void)getAssetsForCentralCoordinate:(GCCoordinate *)coordinate andRadius:(NSNumber *)radius success:(void (^)(GCResponseStatus *, NSArray *, GCPagination *))success failure:(void (^)(NSError *))failure;

@end
