//
//  AlbumsViewController.m
//  GCAPIv2TestApp
//
//  Created by ARANEA on 7/23/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumViewCell.h"
#import "ImagesViewController.h"

#import "GetChute.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworking/AFNetworking.h>


@interface AlbumsViewController ()
@property (nonatomic) BOOL isManagingAlbumsEnabled;
@property (strong, nonatomic) NSMutableArray *selectedAlbums;
@property (strong, nonatomic) UIBarButtonItem *manageButton;
@property (strong, nonatomic) UIBarButtonItem *deleteButton;

@end

@implementation AlbumsViewController

@synthesize albums;

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
    self.isManagingAlbumsEnabled = NO;
    [self setNavBarWithItems];
    [self setToolbarWithItems];
    self.selectedAlbums = [@[] mutableCopy];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GCClient *apiClient = [GCClient sharedClient];

    if ([apiClient isLoggedIn] == NO)
        [self performSegueWithIdentifier:@"login" sender:self.view];
    else
        [self getAlbums];
}

#pragma mark - CollectionView DataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albums count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    GCAlbum *album = (GCAlbum *)self.albums[indexPath.item];
    GCAsset *asset;
    if ([album coverAsset] != nil)
         asset = [album coverAsset];
    else if ([album asset] != nil)
        asset = [album asset];
    // just for initial version a simple label representing albumID.
    cell.albumTitleLabel.text = [album name];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[asset thumbnail]]] success:^(UIImage *image) {
        [cell.coverImage setImage:image];
    }];
    
    [operation start];
//    [cell.coverImage setImageWithURL:[NSURL URLWithString:asset.thumbnail]];

    
    if (cell.selected)
        cell.backgroundColor = [UIColor blueColor]; // highlight selection
    else
        cell.backgroundColor = [UIColor whiteColor]; // Default color
    
    return cell;
}

#pragma mark - CollectionView Delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isManagingAlbumsEnabled)
    {
        AlbumViewCell *cell = (AlbumViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor blueColor];
        GCAlbum *album = [self.albums objectAtIndex:indexPath.row];
        [self.selectedAlbums addObject:album];
        if([self.selectedAlbums count] > 0)
           [self.deleteButton setEnabled:YES];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isManagingAlbumsEnabled)
    {
        AlbumViewCell *cell = (AlbumViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        GCAlbum *album = [self.albums objectAtIndex:indexPath.row];
        [self.selectedAlbums removeObject:album];
        if([self.selectedAlbums count] == 0)
            [self.deleteButton setEnabled:NO];
    }

}

#pragma mark - SEGUE

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(self.isManagingAlbumsEnabled)
        return NO;
    else
        return YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowAssets"])
    {
        ImagesViewController *ivc = segue.destinationViewController;
            
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];

        GCAlbum *album = [albums objectAtIndex:indexPath.item];
        [ivc setAlbum:album];
        [self.collectionView deselectItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] animated:YES];
    }
}

#pragma mark - UIAlertView Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex)
    {
        UITextField *inputField = [alertView textFieldAtIndex:0];

        [GCAlbum createAlbumWithName:inputField.text moderateMedia:NO moderateComments:NO success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            [self getAlbums];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to create new album!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }
}

#pragma mark - Custom methods

-(void)getAlbums
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [GCAlbum getAllAlbumsWithSuccess:^(GCResponseStatus *responseStatus, NSArray *_albums, GCPagination *pagination) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        self.albums = [[NSMutableArray alloc] initWithArray:_albums];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot fetch albums!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)manageAlbums
{
    if(!self.isManagingAlbumsEnabled)
    {
        self.isManagingAlbumsEnabled = YES;
        [self.manageButton setTitle:@"Cancel"];
        [self.collectionView setAllowsMultipleSelection:YES];
        [self.navigationController setToolbarHidden:NO];
        [self setToolbarWithItems];
    }
    else
    {
        [self.navigationController setToolbarHidden:YES];
        self.isManagingAlbumsEnabled = NO;
        [self.manageButton setTitle:@"Manage"];
        [self.collectionView setAllowsMultipleSelection:NO];
        [self.collectionView reloadData];
        [self.selectedAlbums removeAllObjects];
    }
}

- (void)createAlbum
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create New Album With Name:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *inputField = [alertView textFieldAtIndex:0];
    inputField.keyboardType = UIKeyboardTypeDefault;
    [alertView show];
}

- (void)deleteSelectedAlbum
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        for (GCAlbum *album in self.selectedAlbums) {
            [album deleteAlbumWithSuccess:^(GCResponseStatus *responseStatus) {
                
            } failure:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot delete album!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }
    }];
    
    [HUD hide:YES];
    [HUD removeFromSuperview];
    
    [self getAlbums];
    [self manageAlbums];
}

- (void)setToolbarWithItems
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteSelectedAlbum)];
    [self.deleteButton setEnabled:NO];
    
    NSArray *toolbarItemsToBeAdd = [NSArray arrayWithObjects:flexibleSpace,self.deleteButton,flexibleSpace, nil];
    self.toolbarItems = toolbarItemsToBeAdd;
}

- (void)setNavBarWithItems
{
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    
    self.manageButton = [[UIBarButtonItem alloc] initWithTitle:@"Manage" style:UIBarButtonItemStyleBordered target:self action:@selector(manageAlbums)];
    UIBarButtonItem *addAlbumsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createAlbum)];
    NSArray *rightBarButtons = [NSArray arrayWithObjects:addAlbumsButton,self.manageButton, nil];
    
    self.navigationItem.leftBarButtonItem = logout;
    self.navigationItem.rightBarButtonItems = rightBarButtons;
}

- (void)logout
{
    GCClient *apiClient = [GCClient sharedClient];
    [apiClient clearAuthorizationHeader];
    [apiClient clearCookiesForChute];
    [self performSegueWithIdentifier:@"login" sender:self.view];
}

@end
