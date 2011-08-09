//
//  UIBaseViewController.m
//  KitchenSink
//
//  Created by Achal Aggarwal on 09/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "UIBaseViewController.h"

@implementation UIBaseViewController

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
