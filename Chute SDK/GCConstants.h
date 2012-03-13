//
//  GCConstants.h
//
//  Copyright 2011 Chute Corporation. All rights reserved.
//

//////////////////////////////////////////////////////////
//                                                      //
//                   VERSION 1.0.5                      //
//                                                      //
//////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Set which service is to be used
// 0 - Facebook
// 1 - Evernote
// 2 - Chute
// 3 - Twitter
// 4 - Foursquare

#define kSERVICE 0

////////////////////////////////////////////////////////////////////////////////////////////////////////

#define API_URL @"http://api.getchute.com/v1/"
#define SERVER_URL @"http://getchute.com"


////////////////////////////////////////////////////////////////////////////////////////////////////////

//#define kUDID               [[UIDevice currentDevice] uniqueIdentifier]
#define kDEVICE_NAME        [[UIDevice currentDevice] name]
#define kDEVICE_OS          [[UIDevice currentDevice] systemName]
#define kDEVICE_VERSION     [[UIDevice currentDevice] systemVersion]

//#error Please remove this line after changing the client id and client secret
#define kOAuthCallbackURL               @"http://www.costonb.com/oauth"
#define kOAuthCallbackRelativeURL       @"/oauth"
#define kOAuthAppID                     @"4efb7aff38ecef266f000004"
#define kOAuthAppSecret                 @"b0ebbd7db3366d746b8f1b3159139c58f58b3b9b60d05d7260b9beec0403fc5b"

#define kOAuthPermissions               @"all_resources manage_resources profile resources"

#define kOAuthTokenURL                  @"http://getchute.com/oauth/access_token"