//
//  GCUploadComponent.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCUIBaseViewController.h"

@interface GCUploadComponent : GCUIBaseViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *images;
    NSMutableSet *selected;
    IBOutlet UIImageView *selectedIndicator;
    IBOutlet UITableView *imageTable;
    IBOutlet UIScrollView *selectedSlider;
    NSArray *uploadChutes;
}
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) IBOutlet UIImageView *selectedIndicator;
@property (nonatomic, retain) NSArray *uploadChutes;

-(NSArray*)selectedImages;
-(IBAction)uploadAssets:(id)sender;

@end
