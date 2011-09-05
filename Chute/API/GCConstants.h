//
//  GCConstants.h
//
//  Copyright 2011 NA. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Set which service is to be used
// 0 - Facebook
// 1 - Evernote
// 2 - Chute
// 3 - Twitter
// 4 - Foursquare

#define kSERVICE 1

////////////////////////////////////////////////////////////////////////////////////////////////////////

#define API_URL @"http://api.developer.getchute.com/v1/"
#define SERVER_URL @"http://developer.getchute.com"

#define kChutePathVerifyAssets          @"assets/verify"
#define kChuteParcels                   @"parcels"

////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kUDID               [[UIDevice currentDevice] uniqueIdentifier]
#define kDEVICE_NAME        [[UIDevice currentDevice] name]
#define kDEVICE_OS          [[UIDevice currentDevice] systemName]
#define kDEVICE_VERSION     [[UIDevice currentDevice] systemVersion]

//#error Please remove this line after changing the client id and client secret
#define kOAuthRedirectURL               @"http://getchute.com/oauth/callback"
#define kOAuthRedirectRelativeURL       @"/oauth/callback"
#define kOAuthClientID                  @"4e44f307f3e3bd09ac000001"
#define kOAuthClientSecret              @"d6a9f6b219291ded44e763c22599e0d9f8daeef668898d088ab870d60911f642"

#define kOAuthTokenURL                  @"http://developer.getchute.com/oauth/access_token"