//
//  GCServiceVote.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceVote.h"
#import "GCClient.h"
#import "GCVoteCount.h"
#import "GCVote.h"
#import "GCResponse.h"

@implementation GCServiceVote

+ (void)getVoteCountForAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVoteCount *voteCount))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/votes", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCVoteCount class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)voteAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVote *vote))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/votes", albumID, assetID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCVote class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)removeVote:(NSString *)identifier assetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *response, GCVote *vote))success failure:(void (^)(NSError *))failure
{
    NSParameterAssert(identifier);
    NSParameterAssert(assetID);
    NSParameterAssert(albumID);
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/assets/%@/votes/%@", albumID, assetID, identifier];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCVote class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

@end
