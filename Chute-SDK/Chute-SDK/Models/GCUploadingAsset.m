//
//  GCUploadingAsset.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 5/14/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCUploadingAsset.h"

@implementation GCUploadingAsset

@synthesize uploadInfo, uploadProgress;

- (id)init {
    if (self = [super init])  {
        self.uploadProgress = @(0);
    }
    return self;
}

@end
