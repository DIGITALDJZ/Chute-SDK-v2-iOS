//
//  ImagesViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "ImagesViewController.h"
#import <Chute-SDK/GCClient.h>
#import <Chute-SDK/GCServiceAsset.h>
#import <Chute-SDK/GCAsset.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ImageViewCell.h"
#import "ImageDetailsViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Chute-SDK/GCUploader.h>
#import <Chute-SDK/GCFile.h>

@interface ImagesViewController ()

@end

@implementation ImagesViewController

@synthesize assets;
@synthesize popOver;

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

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    GCClient *apiClient = [GCClient sharedClient];
            
    if ([apiClient isLoggedIn] == NO)
        [self performSegueWithIdentifier:@"login" sender:self.view];
    else
        [self getAssets];

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

#pragma mark - CollectionView Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    GCAsset *asset = (GCAsset *)assets[indexPath.item];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:asset.thumbnail]];
    
    return cell;
}

#pragma mark - AlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex) {
        
        UITextField *inputField = [alertView textFieldAtIndex:0];
        [GCServiceAsset importAssetsFromURLs:@[inputField.text] success:^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {
            
            [self getAssets];
            
        } failure:^(NSError *error) {
            
            [[[UIAlertView alloc] initWithTitle:@"Failed to import assets" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }];
        
    }
}

#pragma mark - UIImagePicker Delegate Methods


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.popOver) {
        [self.popOver dismissPopoverAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    
    
    GCUploader *uploader = [GCUploader sharedUploader];
    [uploader uploadFiles:@[[GCFile fileWithUIImage:[info objectForKey:UIImagePickerControllerOriginalImage]]] inAlbumsWithIDs:@[@(2425529)] progress:^(CGFloat currentUploadProgress, NSUInteger numberOfCompletedUploads, NSUInteger totalNumberOfUploads) {
        NSLog(@"Progress: %f", currentUploadProgress);
    } success:^(NSArray *_assets) {
        [self getAssets];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(NSError *error) {
        NSLog([error localizedDescription]);
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SEGUE 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"details"]) {
        
        ImageDetailsViewController *vc;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            vc = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        else
            vc = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        GCAsset *asset = [assets objectAtIndex:indexPath.item];
        [vc setAsset:asset];
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
    
    [GCServiceAsset getAssetsWithSuccess:^(GCResponseStatus *response, NSArray *_assets, GCPagination *pagination) {
        self.assets = [[NSMutableArray alloc] initWithArray:_assets];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
}

@end
