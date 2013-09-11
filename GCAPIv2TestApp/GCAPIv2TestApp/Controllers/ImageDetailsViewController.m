//
//  ImageViewDetailsViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/18/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "ImageDetailsViewController.h"
#import "CommentCell.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <Chute-SDK/GCAsset.h>
#import <Chute-SDK/GCServiceAsset.h>
#import <Chute-SDK/GCServiceHeart.h>
#import <Chute-SDK/GCServiceVote.h>
#import <Chute-SDK/GCServiceFlag.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFImageRequestOperation.h>
#import <Chute-SDK/GCHeartCount.h>
#import <Chute-SDK/GCVoteCount.h>
#import <Chute-SDK/GCFlagCount.h>
#import <Chute-SDK/GCComment.h>
#import <Chute-SDK/GCServiceComment.h>
#import <Chute-SDK/GCHeart.h>
#import <Chute-SDK/GCVote.h>
#import <Chute-SDK/GCFlag.h>
#import <Chute-SDK/GCAlbum.h>

@interface ImageDetailsViewController ()

{
    UITextField *commentTextField;
    NSArray *toolbarItemsToBeAdd;
    BOOL isItHearted;
    BOOL isItVoted;
    BOOL isItFlagged;
}

@end

@implementation ImageDetailsViewController
@synthesize scrollView,heartsLabel,votesLabel,flagLabel,commentsTable,tableViewHeightConstraint;
@synthesize heartButton,voteButton,flagButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarWithItems];
    
    [self updateFlagLabelCount];
    [self updateHeartLabelCount];
    [self updateVoteLabelCount];
    
    [self populateComments];
    
//    [self setComments:[NSMutableArray new]];

	// Do any additional setup after loading the view.
    
//    for (int i = 0; i < 10; i++) {
//        GCComment *comment = [GCComment new];
//        NSString *testString = @"test comment string ";
//        NSMutableString *text = [[NSMutableString alloc] initWithString:@""];
//        for (int j = 0; j < i; j++) {
//            [text appendString:testString];
//        }
//        [comment setCommentText:[NSString stringWithString:text]];
//        [self.comments addObject:comment];
//        text = [[NSMutableString alloc] initWithString:@""];
//    }
   
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setToolbarWithItems];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:[self.asset caption]];
    [self.imageView setImage:[UIImage imageNamed:@"chute.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.asset url]]]]];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.asset url]]] success:^(UIImage *image) {
        [self.imageView setImage:image];
    }];
    [operation start];
    
    [self adjustHeightOfTableview];
    [self setScrollViewContentSize];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#warning TODO: Initial version, just hearting, voting and flaging. Support for unheart, unvote and unflag later. It needs to be made remembering which user H/V/F which asset so it can be given diff options.

- (IBAction)heartUnheart:(UIButton *)sender {

    if(!isItHearted)
    {
        [GCServiceHeart heartAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCHeart *heart) {

            [self updateHeartLabelCount];
            isItHearted = YES;
            [self.heartButton setBackgroundImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"Unable to heart this asset!");
        }];
    }
    else
    {
        [GCServiceHeart unheartAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCHeart *heart) {

            [self updateHeartLabelCount];
            isItHearted = NO;
            [self.heartButton setBackgroundImage:[UIImage imageNamed:@"unheart.png"] forState:UIControlStateNormal];

        } failure:^(NSError *error) {
            NSLog(@"Unable to unheart this asset!");
        }];
    }

}

- (IBAction)voteUnvote:(UIButton *)sender {
    
    if(!isItVoted)
    {
        [GCServiceVote voteAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCVote *vote) {

            [self updateVoteLabelCount];
            isItVoted = YES;
            [self.voteButton setBackgroundImage:[UIImage imageNamed:@"vote"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"Unable to vote this asset!");
        }];
    }
    else
    {
        [GCServiceVote removeVoteForAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCVote *vote) {
            
            [self updateVoteLabelCount];
            isItVoted = NO;
            [self.voteButton setBackgroundImage:[UIImage imageNamed:@"unvote"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"Unable to remove vote from this asset!");
        }];
    }
}

- (IBAction)flagUnflag:(UIButton *)sender {
    if(!isItFlagged)
    {
        [GCServiceFlag flagAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCFlag *flag) {

            [self updateFlagLabelCount];
            isItFlagged = YES;
            [self.flagButton setBackgroundImage:[UIImage imageNamed:@"flag.png"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"Unable to flag this asset!");
        }];
    }
    else
    {
        [GCServiceFlag removeFlagForAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCFlag *flag) {
            
            [self updateFlagLabelCount];
            isItFlagged = NO;
            [self.flagButton setBackgroundImage:[UIImage imageNamed:@"unflag.png"] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            NSLog(@"Unable to flag this asset!");
        }];
    }
}


#pragma mark - Custom methods

- (void)adjustHeightOfTableview
{
    CGFloat height =self.commentsTable.contentSize.height;
    self.tableViewHeightConstraint.constant = height;
    [self.commentsTable needsUpdateConstraints];

}

-(void)setScrollViewContentSize
{
   
    CGFloat scrollViewContentSize = 0.0f;
    
    if([self.comments count] >0)
        scrollViewContentSize = self.imageView.frame.size.height+self.socialView.frame.size.height+self.commentsTable.contentSize.height;
    else
        scrollViewContentSize = self.imageView.frame.size.height+self.socialView.frame.size.height;
   
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.frame.size.width, scrollViewContentSize))];
}

-(void)setToolbarWithItems
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)
            commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 400, 25)];
        else
            commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 235, 30)];
    else
        commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 450, 30)];
    commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    commentTextField.font = [UIFont systemFontOfSize:15];
    commentTextField.placeholder = @"Write your comment..";
    commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    commentTextField.keyboardType = UIKeyboardTypeDefault;
    commentTextField.returnKeyType = UIReturnKeyDone;
    commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTextField.delegate = self;

    UIBarButtonItem *commentField = [[UIBarButtonItem alloc] initWithCustomView:commentTextField];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postComment)];
    
    
    toolbarItemsToBeAdd = [NSArray arrayWithObjects:flexibleSpace,commentField,flexibleSpace,postButton,flexibleSpace, nil];
    
    self.toolbarItems = toolbarItemsToBeAdd;
}

-(void)updateHeartLabelCount
{
    [GCServiceHeart getHeartCountForAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCHeartCount *heartCount) {
        
        self.heartsLabel.text = [heartCount.count stringValue];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to obtain heart count!");
    }];
}
-(void)updateVoteLabelCount
{
    [GCServiceVote getVoteCountForAssetWithID:self.asset.id
                                inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCVoteCount *voteCount) {
                                    
                                    self.votesLabel.text = [voteCount.count stringValue];
                                    
                                } failure:^(NSError *error) {
                                    NSLog(@"Failed to obtain vote count!");
                                }];
}
-(void)updateFlagLabelCount
{
    [GCServiceFlag getFlagCountForAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *response, GCFlagCount *flagCount) {
        
        self.flagLabel.text = [flagCount.count stringValue];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to obtain flag count!");
        
    }];
}

-(void)populateComments
{
    [GCServiceComment getCommentsForAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination) {
        [self setComments:[NSMutableArray arrayWithArray:comments]];
        [self.commentsTable reloadData];
        [self adjustHeightOfTableview];
        [self setScrollViewContentSize];
    } failure:^(NSError *error) {
        NSLog([error localizedDescription]);
    }];

}

-(void)postComment
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [GCServiceComment createComment:commentTextField.text forUserWithName:@"Me" andEmail:@"mine-email@someemail.com" forAssetWithID:self.asset.id inAlbumWithID:self.album.id success:^(GCResponseStatus *responseStatus, GCComment *comment) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [self.comments addObject:comment];
        [commentTextField resignFirstResponder];
        [commentTextField setText:@""];
        [commentTextField setPlaceholder:@"Write your comment..."];
        [self populateComments];

    } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Comment text can't be blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];

}

#pragma mark - Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentCell";
    
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    GCComment *comment = [self.comments objectAtIndex:indexPath.row];
    
    cell.commentLabel.text = [comment commentText];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCComment *comment = [self.comments objectAtIndex:indexPath.row];
    int heightForRow;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
         heightForRow = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:17.0]
                                       constrainedToSize: CGSizeMake(500, CGFLOAT_MAX)
                                           lineBreakMode: UILineBreakModeWordWrap].height;
    else
        heightForRow = [comment.commentText sizeWithFont:[UIFont systemFontOfSize:17.0]
                                       constrainedToSize: CGSizeMake(280, CGFLOAT_MAX)
                                           lineBreakMode: UILineBreakModeWordWrap].height;
    return heightForRow + 21;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        GCComment *comment = [self.comments objectAtIndex:indexPath.row];
        [GCServiceComment deleteCommentWithID:comment.id success:^(GCResponseStatus *responseStatus, GCComment *comment) {
            [self populateComments];
            [self adjustHeightOfTableview];
            [self setScrollViewContentSize];
        } failure:^(NSError *error) {
            NSLog([error localizedDescription]);
        }];
    }
}
#pragma mark - NSNotification methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [self.navigationController.toolbar setItems:toolbarItemsToBeAdd animated:YES];
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.navigationController.toolbar.frame;
    if([[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeRight)
    {
        if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
            frame.origin.y = self.view.frame.size.height - 150.0;
        else
            frame.origin.y = self.view.frame.size.height - 27.0;
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
            frame.origin.y = self.view.frame.size.height - 110.0;
        else
            frame.origin.y = self.view.frame.size.height - 180.0;
    }
    self.navigationController.toolbar.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.navigationController.toolbar setItems:toolbarItemsToBeAdd animated:YES];
    /* Move the toolbar back to bottom of the screen */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.navigationController.toolbar.frame;
    if([[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeLeft && [[UIDevice currentDevice] orientation] != UIInterfaceOrientationLandscapeRight)
    {
        if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
            frame.origin.y = self.view.frame.size.height+62.0;
        else
            frame.origin.y = self.view.frame.size.height+45.0;
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)
            frame.origin.y = self.view.frame.size.height+50.0;
        else
            frame.origin.y = self.view.frame.size.height+45.0;
    }
    
    self.navigationController.toolbar.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Setters

-(void)setAsset:(GCAsset *)newAsset
{
    if(newAsset != _asset)
    {
        _asset = newAsset;
    }
}
- (void)setAlbum:(GCAlbum *)newAlbum
{
    if(newAlbum != _album)
        _album = newAlbum;
}

#pragma mark - ViewDidUnload

- (void)viewDidUnload {
    [self setSocialView:nil];
    [self setHeartsLabel:nil];
    [self setVotesLabel:nil];
    [self setFlagLabel:nil];
    [self setTableViewHeightConstraint:nil];
    [self setComments:nil];
    [self setCommentsTable:nil];
    [self setHeartButton:nil];
    [self setVoteButton:nil];
    [self setFlagButton:nil];
    [super viewDidUnload];
}
@end
