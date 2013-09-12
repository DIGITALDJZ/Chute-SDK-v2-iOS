//
//  AppDelegate.m
//  GCServiceAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 12/25/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "AppDelegate.h"

#import <Chute-SDK/GetChute.h>
//#import "GCClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GCClient sharedClient] setAuthorizationHeaderWithToken:@"36de240aee63494fb0986ed74e87b3285616638698baf90a9eec511c2d4ee0f8"];
  
    
//    NSURL *url = [NSURL URLWithString:@"http://getchute.com/"];
//    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:@"50d9c930018d1672df00002e" secret:@"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
    
//    [oauthClient authenticateUsingOAuthWithPath:@"auth/chute" code:@"" redirectURI:@"http://getchute.com/oauth/callback" success:<#^(AFOAuthCredential *credential)success#> failure:<#^(NSError *error)failure#>

//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:@"GCToken"]) {
//        GCClient *apiClient = [GCClient sharedClient];
//        [apiClient setAuthorizationHeaderWithToken:[userDefaults objectForKey:@"GCToken"]];
//        [apiClient setIsLoggedIn:YES];
//    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    GCClient *apiClient = [GCClient sharedClient];
//    if ([apiClient isLoggedIn]) {
//        [userDefaults setObject:[apiClient authorizationToken] forKey:@"GCToken"];
//        [userDefaults synchronize];
//    }
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
