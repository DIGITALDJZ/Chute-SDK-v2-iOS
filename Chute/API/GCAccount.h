//
//  ChuteAccount.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 30/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRest.h"
#import "GCConstants.h"
#import "ASIHTTPRequest.h"
#import "NSDictionary+QueryString.h"

//Notification which is fired whenever the Account Status is changed
NSString * const GCAccountStatusChanged;

typedef enum {
    GCAccountLoggedOut,
    GCAccountLoggingIn,
    GCAccountLoggedIn,
    GCAccountLoginFailed
} GCAccountStatus;

@interface GCAccount : NSObject {
    GCAccountStatus accountStatus;
    NSString *_accessToken;
}

@property (nonatomic) GCAccountStatus accountStatus;
@property (nonatomic, retain) NSString *accessToken;

+ (GCAccount *)sharedManager;

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(ChuteBasicBlock)successBlock 
                                  andError:(ChuteErrorBlock)errorBlock;
- (void)reset;

- (void)getProfileInfoWithResponse:(ChuteResponseBlock)aResponseBlock
                          andError:(ChuteErrorBlock)anErrorBlock;

@end
