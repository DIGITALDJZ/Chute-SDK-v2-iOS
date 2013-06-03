//
//  ViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 12/25/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "LoginViewController.h"
#import <Chute-SDK/GCLoginView.h>
#import <Chute-SDK/GCOAuth2Client.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginForService:(GCService)service fromStartPoint:(CGPoint)point {
    
    
    GCOAuth2Client *oauth2Client = [GCOAuth2Client clientWithClientID:@"50d9c930018d1672df00002e"  clientSecret:@"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
    [GCLoginView showInView:self.view fromStartPoint:point oauth2Client:oauth2Client service:service success:^{
        NSLog(@"Success");
        [self dismissViewControllerAnimated:YES completion:^{}];
    } failure:^(NSError *error) {
        NSLog(@"Failed: %@", [error localizedDescription]);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Login Not Successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma mark - IBActions


- (IBAction)chute:(id)sender {
    [self showLoginForService:GCServiceChute fromStartPoint:[sender layer].position];
}

- (IBAction)facebook:(id)sender {
    [self showLoginForService:GCServiceFacebook fromStartPoint:[sender layer].position];
}

- (IBAction)twitter:(id)sender {
    [self showLoginForService:GCServiceTwitter fromStartPoint:[sender layer].position];
}

- (IBAction)google:(id)sender {
    [self showLoginForService:GCServiceGoogle fromStartPoint:[sender layer].position];
}

- (IBAction)trendabl:(id)sender {
    [self showLoginForService:GCServiceTrendabl fromStartPoint:[sender layer].position];
}

- (IBAction)flickr:(id)sender {
    [self showLoginForService:GCServiceFlickr fromStartPoint:[sender layer].position];
}

- (IBAction)instagram:(id)sender {
    [self showLoginForService:GCServiceInstagram fromStartPoint:[sender layer].position];
}

- (IBAction)foursquare:(id)sender {
    [self showLoginForService:GCServiceFoursquare fromStartPoint:[sender layer].position];
}

@end
