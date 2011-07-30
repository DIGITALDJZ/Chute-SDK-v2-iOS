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
    NSString *apiKey;
    BOOL loggedIn;
    
    ChuteAccountStatus accountStatus;
    
    NSMutableArray *_evernoteData;
}

@property (nonatomic) ChuteAccountStatus accountStatus;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *accessToken;

@property (nonatomic, readonly) NSMutableArray *evernoteData;

+ (ChuteAPI *)shared;

- (void)loginSuccess:(void (^)(void))successBlock 
             andError:(void (^)(NSError *))errorBlock;

- (void)syncDidComplete:(void (^)(void))successBlock 
                andError:(void (^)(NSError *))errorBlock;

- (void)getChutesForResponse:(void (^)(id))aResponseBlock
                    andError:(void (^)(NSError *))anErrorBlock;

- (void)createChute:(NSString *)name 
            withParent:(int)parentId
           andResponse:(void (^)(id))responseBlock 
              andError:(void (^)(NSError *))errorBlock;

- (void)reset;

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

- (void)getProfileInfoWithResponse:(void (^)(id))aResponseBlock
                          andError:(void (^)(NSError *))anErrorBlock;


@end
