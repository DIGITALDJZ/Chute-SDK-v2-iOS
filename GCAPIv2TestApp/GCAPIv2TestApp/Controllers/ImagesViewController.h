//
//  ImagesViewController.h
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCAlbum;

@interface ImagesViewController : UICollectionViewController <UIAlertViewDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) GCAlbum *album;

@property (strong, nonatomic) UIPopoverController *popOver;

@end
