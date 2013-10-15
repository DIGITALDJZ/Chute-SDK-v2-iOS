//
//  GCStorage.h
//  GetChute
//
//  Created by ARANEA on 10/15/13.
//
//


#import <Foundation/Foundation.h>
#import "GCServiceStorage.h"

@interface GCStorage : NSObject

@property (nonatomic, strong) NSString  *id; // key
@property (nonatomic, strong) NSString  *value;
@property (nonatomic, strong) NSDate    *createdAt;
@property (nonatomic, strong) NSDate    *updatedAt;
@property (nonatomic, strong) NSString  *url;

- (void)getStorageForStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
- (void)putThisInfo:(id)info forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
- (void)postThisInfo:(id)info forStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus, GCStorage *storage))success failure:(void(^)(NSError *error))failure;
- (void)deleteForStorageType:(GCStorageType)storageType success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure;
@end
