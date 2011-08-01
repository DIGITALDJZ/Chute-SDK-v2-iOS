//
//  LoginViewController.h
//  NoteChute
//
//  Created by Achal Aggarwal on 09/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuteBaseViewController.h"

#define SERVICES_ARRAY [NSArray arrayWithObjects:@"facebook", @"evernote", nil]

@interface ChuteLoginViewController : ChuteBaseViewController <UIWebViewDelegate> {
    IBOutlet UIButton *loginButton;
}

@property (nonatomic, retain) IBOutlet UIView *authView;
@property (nonatomic, retain) IBOutlet UIWebView *authWebView;

-(IBAction) login;

+(void)presentInController:(UIViewController *)controller;

@end
