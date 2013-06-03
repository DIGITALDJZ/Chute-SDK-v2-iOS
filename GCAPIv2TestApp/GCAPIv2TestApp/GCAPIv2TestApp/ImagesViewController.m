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

@interface ImagesViewController ()

@end

@implementation ImagesViewController

@synthesize assets;

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
//    return CGSizeMake(80.f, 80.f);
//}
//
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

#pragma mark - SEGUE 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"details"]) {
        ImageDetailsViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        GCAsset *asset = [assets objectAtIndex:indexPath.item];
        [vc setAsset:asset];
        [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)addAsset:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Import Asset from URL:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *inputField = [alertView textFieldAtIndex:0];
    inputField.keyboardType = UIKeyboardTypeURL;
    [alertView show];
}

#pragma mark - Custom Methods

- (void)getAssets {
    
    [GCServiceAsset getAssetsWithSuccess:^(GCResponseStatus *response, NSArray *_assets, GCPagination *pagination) {
        self.assets = _assets;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch assets!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
}

@end
