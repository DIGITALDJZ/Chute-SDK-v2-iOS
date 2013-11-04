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
    
    [GCLoginView showInView:self.view fromStartPoint:point withLoginType:loginType success:^{
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
