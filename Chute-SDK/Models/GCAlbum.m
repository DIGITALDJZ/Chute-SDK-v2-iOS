//
//  GCAlbum.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAlbum.h"
#import "GCClient.h"
#import "AFJSONRequestOperation.h"
#import "DCKeyValueObjectMapping.h"
#import "GCAsset.h"
#import "GCServiceAsset.h"
#import "GCServiceAlbum.h"

@implementation GCAlbum

@synthesize id, links, counters, shortcut, name, user, moderateMedia, moderateComments, createdAt, updatedAt, description, coverAsset, imagesCount,asset;

+ (void)getAllAlbumsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum getAlbumsWithSuccess:^(GCResponseStatus *response, NSArray *albums, GCPagination *pagination) {
        success(response,albums,pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum getAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus,album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)createAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    
    [GCServiceAlbum createAlbumWithName:name withCoverAssetWithID:nil moderateMedia:moderateMedia moderateComments:moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus, album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)createAlbumWithName:(NSString *)name withCoverAssetWithID:(NSNumber *)coverAssetID moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    [GCServiceAlbum createAlbumWithName:name withCoverAssetWithID:coverAssetID moderateMedia:moderateMedia moderateComments:moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus,album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)updateAlbumWithName:(NSString *)_name coverAssetID:(NSNumber *)coverAssetID moderateMedia:(BOOL)_moderateMedia moderateComments:(BOOL)_moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    [GCServiceAlbum updateAlbumWithID:self.id name:_name coverAssetID:coverAssetID moderateMedia:_moderateMedia moderateComments:_moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus, album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)updateAlbumWithName:(NSString *)_name moderateMedia:(BOOL)_moderateMedia moderateComments:(BOOL)_moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    [GCServiceAlbum updateAlbumWithID:self.id name:_name coverAssetID:nil moderateMedia:_moderateMedia moderateComments:_moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus, album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum deleteAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)addAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum addAssets:asssetsArray ForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)removeAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum removeAssets:asssetsArray ForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAssetWithID:(NSNumber *)assetID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset getAssetWithID:assetID fromAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, GCAsset *asset) {
        success(responseStatus,asset);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAllAssetsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset getAssetsForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {
        success(responseStatus,assets,pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)importAssetsFromURLs:(NSArray *)urls success:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset importAssetsFromURLs:urls forAlbumWithID:self.id success:^(GCResponseStatus *reponseStatus, NSArray *assets, GCPagination *pagination) {
        success(reponseStatus, assets, pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
