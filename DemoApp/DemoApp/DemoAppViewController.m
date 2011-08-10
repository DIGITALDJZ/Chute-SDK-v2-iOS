//
//  DemoAppViewController.m
//  DemoApp
//
//  Created by Achal Aggarwal on 30/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "DemoAppViewController.h"
#import "ChuteSDK.h"

@implementation DemoAppViewController
@synthesize chuteName;

- (void) quickAlertWithTitle:(NSString *) title message:(NSString *) message button:(NSString *) buttonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (IBAction)test:(id)sender {
    [[ChuteAPI shared] test];
}

- (IBAction)create:(id)sender {
    [chuteName resignFirstResponder];
    [[ChuteAPI shared] createChute:chuteName.text withParent:0 withPermissionView:2 andAddMembers:2 andAddPhotos:2 andResponse:^(id response) {
        DLog(@"%@", response);
        [self quickAlertWithTitle:@"Chute Created" message:@"The Chute has been created" button:@"okay"];
    } andError:^(NSError *error) {
        DLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)listChutes:(id)sender {
    [[ChuteAPI shared] getMyChutesWithResponse:^(NSArray *array) {
        NSArray *arr = [array retain];
        DLog(@"%@", arr);
        [arr release];
        [self quickAlertWithTitle:@"Success" message:@"Chutes Listed on Console" button:@"okay"];
    } andError:^(NSError *error) {
        [self quickAlertWithTitle:@"error" message:[error localizedDescription] button:@"okay"];
    }];
}

- (IBAction)listParcels:(id)sender {
}

- (IBAction)showInbox:(id)sender {
}

- (IBAction)logout:(id)sender {
    [[ChuteAPI shared] reset];
    [ChuteLoginViewController presentInController:self];
}

- (IBAction)listPublicChutes:(id)sender {
    [[ChuteAPI shared] getPublicChutesWithResponse:^(NSArray *array) {
        NSArray *arr = [array retain];
        DLog(@"%@", arr);
        [arr release];
        [self quickAlertWithTitle:@"Success" message:@"Chutes Listed on Console" button:@"okay"];

    } andError:^(NSError *error) {
        [self quickAlertWithTitle:@"error" message:[error localizedDescription] button:@"okay"];
    }];
}

- (IBAction)sync:(id)sender {
    [[ChuteAPI shared] syncWithResponse:^(void) {
        
    } andError:^(id error) {
        
    }];
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
    [ChuteLoginViewController presentInController:self];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setChuteName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [chuteName release];
    [super dealloc];
}
@end
