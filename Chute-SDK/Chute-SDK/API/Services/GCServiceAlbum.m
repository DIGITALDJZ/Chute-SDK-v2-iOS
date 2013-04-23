//
//  GCServiceAlbum.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCServiceAlbum.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCAlbum.h"
#import "GCAsset.h"
#import "GCResponse.h"

static NSString * const kGCDefaultAlbumName = @"Album";

@implementation GCServiceAlbum

+ (void)getAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *, GCAlbum *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getAlbumsWithSuccess:(void (^)(GCResponseStatus *, NSArray *, GCPagination *))success
                     failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = @"albums";
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data, response.pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)createAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *, GCAlbum *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums"];
    
    /*
     GCAlbum *album = [GCAlbum new];
     [album setName:name];
     [album setModerateMedia:moderateMedia];
     [album setModerateComments:moderateComments];
     
     DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCAlbum class]];
     
     NSDictionary *params = [mapping serializeObject:album];
     */
    
    if (moderateMedia == nil)
        moderateMedia = NO;
    if (moderateComments == nil)
        moderateComments = NO;
    if (name == nil)
        name = @"Album";
    
    NSDictionary *params = @{@"name":name,
                             @"moderate_media":@(moderateMedia),
                             @"moderate_comments":@(moderateComments)};
    
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+ (void)updateAlbumWithID:(NSNumber *)albumID name:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *, GCAlbum *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    /*
     GCAlbum *album = [GCAlbum new];
     [album setName:name];
     [album setModerateMedia:moderateMedia];
     [album setModerateComments:moderateComments];
     
     DCKeyValueObjectMapping *mapping = [DCKeyValueObjectMapping mapperForClass:[GCAlbum class]];
     
     NSDictionary *params = [mapping serializeObject:album];
     */
    
    if (moderateMedia == nil)
        moderateMedia = NO;
    if (moderateComments == nil)
        moderateComments = NO;
    if (name == nil)
        name = kGCDefaultAlbumName;
    
    NSDictionary *params = @{@"name":name,
                             @"moderate_media":@(moderateMedia),
                             @"moderate_comments":@(moderateComments)};
    
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCAlbum class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)deleteAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"albums/%@", albumID];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)addAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    if ([assetsArray count] == 0) {
        return;
    }
    else if([assetsArray[0] isKindOfClass:[GCAsset class]]) {
        
        NSMutableArray *arrayWithIDs = [NSMutableArray new];
        
        [assetsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [arrayWithIDs insertObject:[obj id] atIndex:idx];
            
        }];
        
        assetsArray = arrayWithIDs;
        
    }
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/add_assets", albumID];
    
    NSDictionary *params = @{@"asset_ids":assetsArray};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];

    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)removeAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    if ([assetsArray count] == 0) {
        return;
    }
    else if([assetsArray[0] isKindOfClass:[GCAsset class]]) {
        
        NSMutableArray *arrayWithIDs = [NSMutableArray new];
        
        [assetsArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [arrayWithIDs insertObject:[obj id] atIndex:idx];
            
        }];
        
        assetsArray = arrayWithIDs;
        
    }
    
    NSString *path = [NSString stringWithFormat:@"albums/%@/remove_assets", albumID];
    
    NSDictionary *params = @{@"asset_ids":assetsArray};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


@end
