//
//  LoginViewController.h
//
//  Created by Achal Aggarwal on 09/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuteUIBaseViewController.h"

#define SERVICES_ARRAY [NSArray arrayWithObjects:@"facebook", @"evernote", @"chute", nil]

@interface ChuteLoginViewController : ChuteUIBaseViewController <UIWebViewDelegate> {
    IBOutlet UIButton *loginButton;
}

@property (nonatomic, retain) IBOutlet UIView *authView;
@property (nonatomic, retain) IBOutlet UIWebView *authWebView;

-(IBAction) login;

+(void)presentInController:(UIViewController *)controller;

@end
