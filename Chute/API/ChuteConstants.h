//
//  ChuteConstants.h
//
//  Created by Achal Aggarwal on 09/07/11.
//  Copyright 2011 NA. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Set which service is to be used
// 0 - Facebook
// 1 - Evernote

#define kSERVICE 1

////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define IS_NULL(x)	((nil == x) || ([x isEqual: [NSNull null]]))

////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
#define LOCAL_SERVER
#ifdef LOCAL_SERVER
#define API_URL @"http://api.getchute.local:8080/v1/"
#define SERVER_URL @"http://getchute.local:8080"
#else
#define API_URL @"http://api.staging.getchute.com/v1/"
#define SERVER_URL @"http://staging.getchute.com"
#endif
#else
//Please change to Production URL before submitting
#define API_URL @"http://api.staging.getchute.com/v1/"
#define SERVER_URL @"http://staging.getchute.com"
#endif

#define kChutePathVerifyAssets          @"assets/verify"
#define kChuteParcels                   @"parcels"

////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kUDID               [[UIDevice currentDevice] uniqueIdentifier]
#define kDEVICE_NAME        [[UIDevice currentDevice] name]
#define kDEVICE_OS          [[UIDevice currentDevice] systemName]
#define kDEVICE_VERSION     [[UIDevice currentDevice] systemVersion]

#define kOAuthRedirectURL               @"http://getchute.local:8080/auth/chute/callback"
#define kOAuthRedirectRelativeURL       @"/auth/chute/callback"
#define kOAuthClientID                  @"4e366604ddccbf6a2a000001"
#define kOAuthClientSecret              @"f51e056905ea6becb1c911b10fabaaeb650a680870a4da30126e8a586cf39f78"
#define kOAuthTokenURL                  @"http://getchute.local:8080/oauth/access_token"