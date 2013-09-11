//
//  ImageViewDetailsViewController.h
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/18/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAsset;
@class GCAlbum;

@interface ImageDetailsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) GCAsset *asset;
@property (strong, nonatomic) GCAlbum *album;
@property (strong, nonatomic) NSMutableArray *comments;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *socialView;

@property (strong, nonatomic) IBOutlet UIButton *heartButton;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;
@property (strong, nonatomic) IBOutlet UIButton *flagButton;

- (IBAction)heartUnheart:(UIButton *)sender;
- (IBAction)voteUnvote:(UIButton *)sender;
- (IBAction)flagUnflag:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *heartsLabel;
@property (strong, nonatomic) IBOutlet UILabel *votesLabel;
@property (strong, nonatomic) IBOutlet UILabel *flagLabel;

@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end
