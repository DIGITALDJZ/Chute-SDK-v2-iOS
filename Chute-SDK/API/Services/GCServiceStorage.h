//
//  GCServiceStorage.h
//  Pods
//
//  Created by ARANEA on 10/15/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    GCStorageTypePublic,
    GCStorageTypePrivate,
    GCStorageTypeTemp,
}GCStorageType;

extern NSString *const kGCStorageTypes[];

@class GCClient, GCResponseStatus,GCStorage;

@interface GCServiceStorage : NSObject


+ (void)getStorageForKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
+ (void)putThisInfo:(NSString *)info toStorageWithKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
+ (void)postThisInfo:(NSString *)info toStorageWithKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
+ (void)deleteStorageForKey:(NSString *)key forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;

@end
