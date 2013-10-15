//
//  GCServiceStorage.m
//  Pods
//
//  Created by ARANEA on 10/15/13.
//
//

#import "GCServiceStorage.h"
#import "GCClient.h"
#import "GCResponseStatus.h"
#import "GCResponse.h"
#import "GCStorage.h"


NSString *const kGCStorageTypes[] = {
    @"public",
    @"private",
    @"temp"
};

@implementation GCServiceStorage

+ (void)getStorageForKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *, GCStorage *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"/storage/%@/%@",kGCStorageTypes[storageType],key];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:path parameters:nil];
    
    [apiClient request:request factoryClass:[GCStorage class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)putThisValue:(id)info toStorageWithKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *, GCStorage *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"storage/%@/%@",kGCStorageTypes[storageType],key];
    
    NSDictionary *params = @{@"data":info};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCStorage class] success:^(GCResponse *response) {
        success(response.response, response.data);
    } failure:failure];
}

+ (void)postThisInfo:(id)info toStorageWithKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *, int *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = [NSString stringWithFormat:@"storage/%@/%@",kGCStorageTypes[storageType],key];
    
    NSDictionary *params = @{@"data":info};
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:path parameters:params];
    
    [apiClient request:request factoryClass:[GCStorage class] success:^(GCResponse *response) {
        success(response.response,response.data);
    } failure:failure];
}

+ (void)deleteStorageForKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void (^)(GCResponseStatus *))success failure:(void (^)(NSError *))failure
{
    GCClient *apiClient = [GCClient sharedClient];

    NSString *path = [NSString stringWithFormat:@"storage/%@/%@",kGCStorageTypes[storageType],key];
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:path parameters:nil];
    
    [apiClient request:request factoryClass:nil success:^(GCResponse *response) {
        success(response.response);
    } failure:failure];
}

@end
