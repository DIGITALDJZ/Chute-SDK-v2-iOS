//
//  ChuteAPI.h
//
//  Created by Gaurav Sharma on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
                                  andError:(void (^)(NSError *))errorBlock;

- (void)reset;

- (void)syncDidComplete:(void (^)(void))successBlock 
                andError:(void (^)(NSError *))errorBlock;

//Data Wrappers
//Get Data
- (void)getProfileInfoWithResponse:(void (^)(id))aResponseBlock
                          andError:(void (^)(NSError *))anErrorBlock;

- (void)getMyChutesWithResponse:(void (^)(NSArray *))aResponseBlock
                       andError:(void (^)(NSError *))anErrorBlock;

- (void)getChutesForId:(NSString *)chuteId 
              response:(void (^)(NSArray *))aResponseBlock 
              andError:(void (^)(NSError *))anErrorBlock;

/*
 - (void)getChutesForResponse:(void (^)(id))aResponseBlock
 andError:(void (^)(NSError *))anErrorBlock;
 
*/

//Post Data
- (void)createChute:(NSString *)name 
            withParent:(int)parentId
           andResponse:(void (^)(id))responseBlock 
              andError:(void (^)(NSError *))errorBlock;

//Helper methods for Asset Uploader
- (void)initThumbnail:(UIImage *)thumbnail
           forAssetId:(NSString *)assetId
          andResponse:(void (^)(id))aResponseBlock
             andError:(void (^)(NSError *))anErrorBlock;

- (void)getTokenForAssetId:(NSString *)assetId
               andResponse:(void (^)(id))aResponseBlock
                  andError:(void (^)(NSError *))anErrorBlock;

- (void)completeForAssetId:(NSString *)assetId
               andResponse:(void (^)(id))aResponseBlock
                  andError:(void (^)(NSError *))anErrorBlock;


- (void) test;

@end
