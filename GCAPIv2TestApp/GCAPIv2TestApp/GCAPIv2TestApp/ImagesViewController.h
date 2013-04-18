//
//  ImagesViewController.h
//  GCAPIv2TestApp
//
//  Created by Aleksandar Trpeski on 4/16/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UICollectionViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *assets;

@end
