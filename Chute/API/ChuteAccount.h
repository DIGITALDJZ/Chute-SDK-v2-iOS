//
//  ChuteAccount.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 30/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChuteREST.h"
#import "ChuteConstants.h"
#import "ASIHTTPRequest.h"
#import "NSDictionary+QueryString.h"

//Notification which is fired whenever the Account Status is changed
NSString * const ChuteAccountStatusChanged;

typedef enum {
    ChuteAccountLoggedOut,
    ChuteAccountLoggingIn,
    ChuteAccountLoggedIn,
    ChuteAccountLoginFailed
} ChuteAccountStatus;

@interface ChuteAccount : NSObject {
    ChuteAccountStatus accountStatus;
    NSString *_accessToken;
}

@property (nonatomic) ChuteAccountStatus accountStatus;
@property (nonatomic, retain) NSString *accessToken;

+ (ChuteAccount *)sharedManager;

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(ChuteBasicBlock)successBlock 
                                  andError:(ChuteErrorBlock)errorBlock;
- (void)reset;

- (void)getProfileInfoWithResponse:(ChuteResponseBlock)aResponseBlock
                          andError:(ChuteErrorBlock)anErrorBlock;

@end
