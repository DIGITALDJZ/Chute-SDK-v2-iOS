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
// 2 - Chute

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
//#define LOCAL_SERVER
#ifdef LOCAL_SERVER
#define API_URL @"http://api.getchute.local:8080/v1/"
#define SERVER_URL @"http://getchute.local:8080"
#else
#define API_URL @"http://api.p.getchute.com/v1/"
#define SERVER_URL @"http://p.getchute.com"
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

#define kOAuthRedirectURL               @"http://getchute.com/oauth/callback"
#define kOAuthRedirectRelativeURL       @"/oauth/callback"
#define kOAuthClientID                  @"4e3ef1af38ecef0aaa000001"
#define kOAuthClientSecret              @"dfa5876546b900562a87d7e58a753c27383ea142778b330286877fe399da4d4b"
#define kOAuthTokenURL                  @"http://p.getchute.com/oauth/access_token"