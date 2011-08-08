//
//  ChuteAPI.h
//
//  Created by Gaurav Sharma on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ErrorBlock)(NSError *);
typedef void (^ResponseBlock)(id);

extern NSString * const ChuteLoginStatusChanged;

typedef enum {
    ChuteAccountStatusLoggedOut,
    ChuteAccountStatusLoggingIn,
    ChuteAccountStatusLoggedIn,
    ChuteAccountStatusLoginFailed
} ChuteAccountStatus;

@interface ChuteAPI : NSObject {
    BOOL loggedIn;
    ChuteAccountStatus accountStatus;
    NSString *_accessToken;
}

@property (nonatomic) ChuteAccountStatus accountStatus;
@property (nonatomic, retain) NSString *accessToken;

+ (ChuteAPI *)shared;

//Authorization Methods
- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(void (^)(void))successBlock 
                                  andError:(ErrorBlock)errorBlock;

- (void)reset;

- (void)syncDidComplete:(void (^)(void))successBlock 
                andError:(ErrorBlock)errorBlock;

//Data Wrappers
//Get Data
- (void)getProfileInfoWithResponse:(ResponseBlock)aResponseBlock
                          andError:(ErrorBlock)anErrorBlock;

- (void)getMyChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                       andError:(ErrorBlock)anErrorBlock;

- (void)getPublicChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                           andError:(ErrorBlock)anErrorBlock;

- (void)getChutesForId:(NSString *)Id 
              response:(void (^)(NSArray *))aResponseBlock 
              andError:(ErrorBlock)anErrorBlock;

- (void)getAssetsForChuteId:(NSUInteger)chuteId
                   response:(void (^)(NSArray *))aResponseBlock 
                   andError:(ErrorBlock)anErrorBlock;
/*
 - (void)getChutesForResponse:(void (^)(id))aResponseBlock
 andError:(void (^)(NSError *))anErrorBlock;
 
*/

//Post Data
- (void)createChute:(NSString *)name 
         withParent:(NSUInteger)parentId
 withPermissionView:(NSUInteger)permissionView
      andAddMembers:(NSUInteger)addMembers
       andAddPhotos:(NSUInteger)addPhotos
        andResponse:(ResponseBlock)responseBlock 
           andError:(ErrorBlock)errorBlock;

//Helper methods for Asset Uploader
- (void)initThumbnail:(UIImage *)thumbnail
           forAssetId:(NSString *)assetId
          andResponse:(ResponseBlock)aResponseBlock
             andError:(ErrorBlock)anErrorBlock;

- (void)getTokenForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock;

- (void)completeForAssetId:(NSString *)assetId
               andResponse:(ResponseBlock)aResponseBlock
                  andError:(ErrorBlock)anErrorBlock;


- (void) test;

@end
