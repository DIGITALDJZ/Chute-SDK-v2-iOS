//
//  AppDelegate.m
//  GCServiceAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 12/25/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "AppDelegate.h"
#import "GCClient.h"
#import "AFJSONRequestOperation.h"
#import "GCResponseStatus.h"
#import "GCServiceAlbum.h"
#import "GCServiceAsset.h"
#import "GCCoordinate.h"
#import "GCServiceAlbum.h"
#import "GCServiceAsset.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[GCClient sharedClient] setAuthorizationHeaderWithToken:@"092220d0ea809448f0070c2d60a9bc29e7b3d36ce57257a283face54bd0ade09"];
  
    
//    NSURL *url = [NSURL URLWithString:@"http://getchute.com/"];
//    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:@"50d9c930018d1672df00002e" secret:@"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
    
//    [oauthClient authenticateUsingOAuthWithPath:@"auth/chute" code:@"" redirectURI:@"http://getchute.com/oauth/callback" success:<#^(AFOAuthCredential *credential)success#> failure:<#^(NSError *error)failure#>

    

//    GCCoordinate *coord = [GCCoordinate new];
//    [coord setLatitude:@20.24];
//    [coord setLongitude:@20.13];
//    [GCServiceAsset getAssetsForCentralCoordinate:coord andRadius:@1000000 success:^(GCResponseStatus *response, NSArray *assets, GCPagination *pagination) {
//
//        NSLog(@"kex");
//
//    } failure:^(NSError *error) {
//
//        NSLog(@"dare");
//        
//    }];
//    
//    
//    [GCServiceAsset importAssetsFromURLs:@[@"http://chute.github.com/chute-api-v2-documentation/images/logo_developer.png"] forAlbumWithID:@2332606 success:^(GCResponseStatus *response, NSArray *assets, GCPagination *pagination) {
//        
//        NSLog(@"kex");
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"dare");
//        
//    }];


//    [GCServiceAlbum addAssets:@[@23131231, @12332423, @2343243232] ForAlbumWithID:@2332606 success:^(GCResponseStatus *response) {
//        
//        NSLog(@"kex");
//
//    } failure:^(NSError *error) {
//
//        NSLog(@"dare");
//        
//    }];
//
//    
//    [GCServiceAlbum updateAlbumWithID:@(2332606) name:@"Test Title" moderateMedia:YES moderateComments:YES success:^(GCResponseStatus *response, GCAlbum *album) {
//
//        NSLog(@"kex");
//
//    } failure:^(NSError *error) {
//
//        NSLog(@"dare");
//        
//    }];
//    
//    
//    [GCServiceAlbum createAlbumWithName:@"Kex's Photos" moderateMedia:YES moderateComments:YES success:^(GCResponseStatus *response, GCAlbum *album) {
//
//        NSLog(@"kex");
//
//    } failure:^(NSError *error) {
//        
//        NSLog(@"dare");
//        
//    }];
//    
//    [GCServiceAlbum getAlbumWithID:@(2332606) success:^(GCResponseStatus *response, GCAlbum *album) {
//        
//        NSLog(@"kex");
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"dare");
//        
//    }];
//    
//    [GCServiceAlbum getAlbumsWithSuccess:^(GCResponseStatus *response, NSArray *albums, GCPagination *pagination) {
//        NSLog(@"kex");
//    } failure:^(NSError *error) {
//        NSLog(@"dare");
//    }];
    
    //https://getchute.com/oauth/access_token?client_id=APP_ID&client_secret=APP_SECRET&code=CODE&grant_type=authorization_code&redirect_uri=REDIRECT_URI
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
