//
//  ViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 12/25/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "GetChute.h"

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

- (void)showLoginForLoginType:(GCLoginType)loginType fromStartPoint:(CGPoint)point {
    
    
    GCOAuth2Client *oauth2Client = [GCOAuth2Client clientWithClientID:@"50d9c930018d1672df00002e"  clientSecret:@"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
    [GCLoginView showInView:self.view fromStartPoint:point oauth2Client:oauth2Client withLoginType:loginType success:^{
        GCLogInfo(@"Logged in.");
        [self dismissViewControllerAnimated:YES completion:^{}];
    } failure:^(NSError *error) {
        GCLogWarning(@"Failed: %@", [error localizedDescription]);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Login Not Successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma mark - IBActions


- (IBAction)chute:(id)sender {
    [self showLoginForLoginType:GCLoginTypeChute fromStartPoint:[sender layer].position];
}

- (IBAction)facebook:(id)sender {
    [self showLoginForLoginType:GCLoginTypeFacebook fromStartPoint:[sender layer].position];
}

- (IBAction)twitter:(id)sender {
    [self showLoginForLoginType:GCLoginTypeTwitter fromStartPoint:[sender layer].position];
}

- (IBAction)google:(id)sender {
    [self showLoginForLoginType:GCLoginTypeGoogle fromStartPoint:[sender layer].position];
}

- (IBAction)flickr:(id)sender {
    [self showLoginForLoginType:GCLoginTypeFlickr fromStartPoint:[sender layer].position];
}

- (IBAction)instagram:(id)sender {
    [self showLoginForLoginType:GCLoginTypeInstagram fromStartPoint:[sender layer].position];
}

- (IBAction)foursquare:(id)sender {
    [self showLoginForLoginType:GCLoginTypeFoursquare fromStartPoint:[sender layer].position];
}

@end
