//
//  AlbumsViewController.h
//  GCAPIv2TestApp
//
//  Created by ARANEA on 7/23/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumsViewController : UICollectionViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *albums;

@end
