//
//  LoginViewController.h
//  NoteChute
//
//  Created by Achal Aggarwal on 09/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuteBaseViewController.h"

@interface ChuteLoginViewController : ChuteBaseViewController <UIWebViewDelegate> {
    IBOutlet UIButton *evernoteLogin;
}

@property (nonatomic, retain) IBOutlet UIView *authView;
@property (nonatomic, retain) IBOutlet UIWebView *authWebView;

-(IBAction) loginWithEvernote;

+(void)presentInController:(UIViewController *)controller;

@end
