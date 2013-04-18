//
//  AppDelegate.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 12/25/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "AppDelegate.h"
#import "GCClient.h"
#import "AFJSONRequestOperation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    GCClient *apiClient = [GCClient sharedClient];
    
    NSString *path = @"/auth/chute";//@"albums?oauth_token=36de240aee63494fb0986ed74e87b3285616638698baf90a9eec511c2d4ee0f8";
    NSDictionary *params = @{@"client_id":@"50d9c930018d1672df00002e"};
    //[NSString stringWithFormat:@"oauth/access_token?client_id=%@&client_secret=%@", @"50d9c930018d1672df00002e", @"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
    
    NSLog(@"baseURL: %@", [apiClient baseURL]);
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:@"GET" path:path parameters:params];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Success: %@", JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", JSON);

    }];
    
    [operation start];
    
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
