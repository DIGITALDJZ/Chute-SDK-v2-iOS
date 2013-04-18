//
//  ImageViewDetailsViewController.h
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/18/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAsset;

@interface ImageDetailsViewController : UIViewController

@property (strong, nonatomic) GCAsset *asset;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
