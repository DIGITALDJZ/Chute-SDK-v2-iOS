//
//  LoginViewController.m
//  NoteChute
//
//  Created by Achal Aggarwal on 09/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "ChuteLoginViewController.h"

@interface ChuteLoginViewController()
//-(void) loginWithAPIKey:(NSString *) apiKey;
-(void) hideAuthViewCompletion:(void (^)(void))completion;
@end


@implementation ChuteLoginViewController

@synthesize authView;
@synthesize authWebView;

+(void)presentInController:(UIViewController *)controller {
    [[ChuteAPI shared] verifyAuthorizationWithAccessCode:nil success:^(void) {
    } andError:^(NSError *error) {
        ChuteLoginViewController *loginController = [[ChuteLoginViewController alloc] init];
        [controller presentModalViewController:loginController animated:YES];
        [loginController release];
    }];
}

-(IBAction) login {
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.6, 0.6);
    CGAffineTransform t2 = CGAffineTransformMakeScale(0.99, 0.99);
    CGAffineTransform t3 = CGAffineTransformMakeScale(0.85, 0.85);
    
    [authWebView setDelegate:self];
    
    [authView setCenter:CGPointMake(160, 230)];
    [authView setTransform:t1];
    [authView setAlpha:0.0f];
    [self.view addSubview:authView];
    
    [UIView animateWithDuration:0.2f animations:^{
        [authView setAlpha:1.0f];
        [authView setTransform:t2]; 
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            [authView setTransform:t3]; 
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                [authView setTransform:CGAffineTransformIdentity]; 
            }]; 
        }];
    }];
    
    NSDictionary *params = [NSMutableDictionary new];
    [params setValue:@"profile" forKey:@"scope"];
    [params setValue:@"web_server" forKey:@"type"];
    [params setValue:@"code" forKey:@"response_type"];
    [params setValue:kOAuthClientID forKey:@"client_id"];
    [params setValue:kOAuthRedirectURL forKey:@"redirect_uri"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/%@?%@", 
                                                                               SERVER_URL, 
                                                                               [SERVICES_ARRAY objectAtIndex:kSERVICE],
                                                                               [params stringWithFormEncodedComponents]]]];
    [authWebView sizeToFit];
    [authWebView loadRequest:request];
    
    [params release];
}

-(void) hideAuthViewCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.3f animations:^{
        [authView setAlpha:0.0f];
        [authView setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    } completion:^(BOOL finished){
        [authWebView stopLoading];
        [authWebView setDelegate:nil];
        [authView removeFromSuperview];
        completion();
    }];
}


//-(void) loginWithAPIKey:(NSString *) apiKey {
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:apiKey forKey:@"api_key"];
//    [prefs synchronize];
//    
//    [[ChuteAPI shared] setApiKey:apiKey];
//    
//    [[ChuteAPI shared] loginSuccess:^(void) {
//        [self quickAlertWithTitle:@"" message:@"We're importing your notebooks and photos, this may take a few minutes or more" button:@"Okay"];
//        [super dismissModalViewControllerAnimated:YES];
//        [[ChuteAPI shared] syncDidComplete:^(void) {
//            DLog();
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncComplete" object:nil];
//        } andError:^(NSError *error) {
//            DLog();
//        }];   
//    } andError:^(NSError *error) {
//        DLog();
//        [loginButton setHidden:NO];
//        [self quickAlertWithTitle:@"Error" message:[error localizedDescription] button:@"Okay"];
//    }];
//}

#pragma mark WebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] path] isEqualToString:kOAuthRedirectRelativeURL]) {
        NSString *_code = [[NSDictionary dictionaryWithFormEncodedString:[[request URL] query]] objectForKey:@"code"];
        
        [[ChuteAPI shared] verifyAuthorizationWithAccessCode:_code success:^(void) {
            [self hideAuthViewCompletion:^{
                [super dismissModalViewControllerAnimated:YES];
            }];
        } andError:^(NSError *error) {
            DLog(@"%@", [error localizedDescription]);
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUDWithTitle:nil andOpacity:0.3f];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHUD];
}

- (void)dealloc
{
    [authView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
