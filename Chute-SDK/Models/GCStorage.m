//
//  GCStorage.m
//  GetChute
//
//  Created by ARANEA on 10/15/13.
//
//

#import "GCStorage.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCResponse.h"

@implementation GCStorage

@synthesize id,value,createdAt,updatedAt,url;

- (void)getStorageForStorageType:(GCStorageType)storageType success:(void (^)(int *, GCStorage *))success failure:(void (^)(NSError *))failure
{
    [GCServiceStorage getStorageForKey:self.id forStorageType:storageType success:^(GCResponseStatus *responseStatus, GCStorage *storage) {
        success(responseStatus,storage);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)putThisInfo:(id)info forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *, GCStorage *))success failure:(void (^)(NSError *))failure
{
    [GCServiceStorage putThisInfo:info toStorageWithKey:self.id forStorageType:storageType success:^(GCResponseStatus *responseStatus, GCStorage *storage) {
        success(responseStatus,storage);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)postThisInfo:(id)info forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *, GCStorage *))success failure:(void (^)(NSError *))failure
{
    [GCServiceStorage postThisInfo:info toStorageWithKey:self.id forStorageType:storageType success:^(GCResponseStatus *responseStatus, GCStorage *storage) {
        success(responseStatus,storage);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteForStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure
{
    [GCServiceStorage deleteStorageForKey:self.id forStorageType:storageType success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
