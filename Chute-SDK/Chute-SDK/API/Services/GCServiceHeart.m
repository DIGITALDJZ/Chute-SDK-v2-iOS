//
//  GCServiceHeart.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceHeart.h"
#import "GCClient.h"
#import "GCHeartCount.h"
#import "GCHeart.h"
#import "GCResponse.h"

@implementation GCServiceHeart

+ (void)getHeartCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeartCount *heartCount))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/hearts", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCHeartCount class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)heartAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeart *heartCount))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/hearts", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCHeart class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)unheart:(NSString *)identifier assetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCHeart *heartCount))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(identifier);
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/hearts/%@", albumID, assetID, identifier];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCHeart class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}


@end
