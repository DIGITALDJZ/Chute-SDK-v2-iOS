//
//  ListChutesViewController.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 08/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListChutesViewController : UIViewController <UITableViewDataSource> {
    UITableView *chuteList;
    NSArray *data;
}

@property (nonatomic, retain) IBOutlet UITableView *chuteList;

@end
