//
//  ImageViewDetailsViewController.m
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/18/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "ImageDetailsViewController.h"
#import <Chute-SDK/GCAsset.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFImageRequestOperation.h>

@interface ImageDetailsViewController ()

@end

@implementation ImageDetailsViewController

@synthesize asset;

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTitle:[asset caption]];
    [self.imageView setImage:[UIImage imageNamed:@"chute.png"]];
//    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[asset url]]] success:^(UIImage *image) {
//        [self.imageView setImage:image];
//    }];
//    [operation start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[asset url]]]]];
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

@end
