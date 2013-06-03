//
//  GCFlag.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCFlag.h"
#import "GCServiceFlag.h"

@implementation GCFlag

@synthesize id, links, createdAt, updatedAt, identifier, albumId, assetId;

- (void)removeFlagFromAssetWithID:(NSNumber *)assetID inAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus, GCFlag *flag))success failure:(void(^)(NSError *error))failure
{
    [GCServiceFlag removeFlag:self.id assetWithID:assetID inAlbumWithID:albumID success:^(GCResponseStatus *response, GCFlag *flag) {
        success(response,flag);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
