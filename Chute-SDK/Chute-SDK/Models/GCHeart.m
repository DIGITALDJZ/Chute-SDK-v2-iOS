//
//  GCHeart.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCHeart.h"
#import "GCServiceHeart.h"

@implementation GCHeart

@synthesize id, links, createdAt, updatedAt, identifier, albumId, assetId;

- (void)unheartAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCHeart *heart))success failure:(void(^)(NSError *error))failure
{
    [GCServiceHeart unheart:self.id assetWithID:assetID inAlbumWithID:albumID success:^(GCResponseStatus *response, GCHeart *heart) {
        success(response,heart);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
