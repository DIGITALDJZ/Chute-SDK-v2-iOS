//
//  ImagesViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageViewCell.h"
#import "ImageDetailsViewController.h"

#import "GetChute.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface ImagesViewController ()

@property(nonatomic) BOOL isManagingAssetsEnabled;
@property (strong, nonatomic) NSMutableArray *selectedAssets;
@property (strong, nonatomic) UIBarButtonItem *manageButton;
@property (strong, nonatomic) UIBarButtonItem *deleteButton;

@end

@implementation ImagesViewController

@synthesize assets;
@synthesize popOver;

-(void)setAlbum:(GCAlbum *)newAlbum
{
    if(_album != newAlbum)
        _album = newAlbum;
}

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
    self.isManagingAssetsEnabled = NO;
    self.selectedAssets = [@[] mutableCopy];
    [self setNavBarWithItems];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    
    [self getAssets];

}

-(void)viewDidDisappear:(BOOL)animated
{
//    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Adjust cell size for orientation
////    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
////        return CGSizeMake(170.f, 170.f);
////    }
//    return CGSizeMake(75.f, 75.f);
//}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.collectionView performBatchUpdates:nil completion:nil];
//}

#pragma mark - CollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    GCAsset *asset = (GCAsset *)assets[indexPath.item];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:asset.thumbnail]];
    
    if (cell.selected)
        cell.backgroundColor = [UIColor blueColor]; // highlight selection
    else
        cell.backgroundColor = [UIColor whiteColor]; // Default color
    
    return cell;
}
#pragma mark - CollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isManagingAssetsEnabled)
    {
        ImageViewCell *cell = (ImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
        GCAsset *asset = [self.assets objectAtIndex:indexPath.row];
        [self.selectedAssets addObject:asset];
        if([self.selectedAssets count]>0)
            [self.deleteButton setEnabled:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
        ImageViewCell *cell = (ImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        GCAsset *asset = [self.assets objectAtIndex:indexPath.row];
        [self.selectedAssets removeObject:asset];
        if([self.selectedAssets count] == 0)
            [self.deleteButton setEnabled:NO];
}

#pragma mark - AlertView Delegate Method

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex) {
//        
//        UITextField *inputField = [alertView textFieldAtIndex:0];
//        [GCServiceAsset importAssetsFromURLs:@[inputField.text] success:^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {
//            
//            [self getAssets];
//            
//        } failure:^(NSError *error) {
//            
//            [[[UIAlertView alloc] initWithTitle:@"Failed to import assets" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            
//        }];
//        
//    }
//}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.popOver) {
        [self.popOver dismissPopoverAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    GCUploader *uploader = [GCUploader sharedUploader];
    
    [uploader uploadImages:@[[info objectForKey:UIImagePickerControllerOriginalImage]] inAlbumWithID:self.album.id progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
         NSLog(@"File %d of %d - Progress: %f", numberOfCompletedUploads, totalNumberOfUploads, currentUploadProgress);
    } success:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
        }];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self getAssets];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to upload images.Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SEGUE 
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(self.isManagingAssetsEnabled)
        return NO;
    else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PushAssetDetails"]) {
        
        ImageDetailsViewController *vc;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            vc = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        else
            vc = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        GCAsset *asset = [assets objectAtIndex:indexPath.item];
        [vc setAsset:asset];
        [vc setAlbum:self.album];
        [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)addAsset:(id)sender {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    [picker setDelegate:self];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (![[self popOver] isPopoverVisible]) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            self.popOver = popover;
        }
        else {
            [[self popOver] dismissPopoverAnimated:NO];
        }
    }
    else {
        [self presentViewController:picker animated:YES completion:nil];
    }
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Import Asset from URL:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField *inputField = [alertView textFieldAtIndex:0];
//    inputField.keyboardType = UIKeyboardTypeURL;
//    [alertView show];
}


#pragma mark - Custom Methods

- (void)getAssets {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.album getAllAssetsWithSuccess:^(GCResponseStatus *responseStatus, NSArray *_assets, GCPagination *pagination) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        self.assets = [[NSMutableArray alloc] initWithArray:_assets];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)manageAssets
{
    if(!self.isManagingAssetsEnabled)
    {
        self.isManagingAssetsEnabled = YES;
        [self.manageButton setTitle:@"Cancel"];
        [self.collectionView setAllowsMultipleSelection:YES];
        [self.navigationController setToolbarHidden:NO];
        [self setToolbarWithItems];
    }
    else
    {
        [self.navigationController setToolbarHidden:YES];
        self.isManagingAssetsEnabled = NO;
        [self.manageButton setTitle:@"Manage"];
        [self.collectionView setAllowsMultipleSelection:NO];
        [self.collectionView reloadData];
        [self.selectedAssets removeAllObjects];
    }
}


- (void)deleteSelectedAssets
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.album removeAssets:self.selectedAssets success:^(GCResponseStatus *responseStatus) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [self getAssets];
        [self manageAssets];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot delete assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }];
}

- (void)setToolbarWithItems
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteSelectedAssets)];
    [self.deleteButton setEnabled:NO];
    NSArray *toolbarItemsToBeAdd = [NSArray arrayWithObjects:flexibleSpace,self.deleteButton,flexibleSpace, nil];
    self.toolbarItems = toolbarItemsToBeAdd;
}

- (void)setNavBarWithItems
{
    self.manageButton = [[UIBarButtonItem alloc] initWithTitle:@"Manage" style:UIBarButtonItemStyleBordered target:self action:@selector(manageAssets)];
    UIBarButtonItem *addAssetsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAsset:)];
    NSArray *navBarItems = [NSArray arrayWithObjects:addAssetsButton,self.manageButton, nil];
    
    self.navigationItem.rightBarButtonItems = navBarItems;
}

- (void)viewDidUnload {
    [self setManageButton:nil];
    [super viewDidUnload];
}
@end
