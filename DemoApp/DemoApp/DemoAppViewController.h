//
//  DemoAppViewController.h
//  DemoApp
//
//  Created by Achal Aggarwal on 30/07/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoAppViewController : UIViewController {
    UITextField *chuteName;
}

@property (nonatomic, retain) IBOutlet UITextField *chuteName;

- (void) quickAlertWithTitle:(NSString *) title message:(NSString *) message button:(NSString *) buttonTitle;

- (IBAction)test:(id)sender;

- (IBAction)create:(id)sender;
- (IBAction)listChutes:(id)sender;
- (IBAction)listParcels:(id)sender;
- (IBAction)showInbox:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)listPublicChutes:(id)sender;
- (IBAction)sync:(id)sender;

@end
