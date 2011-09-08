//
//  GCAssetUploader.m
//
//  Created by Achal Aggarwal on 08/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCAssetUploader.h"

static GCAssetUploader *sharedAssetUploader = nil;

@implementation GCAssetUploader

#pragma mark - Methods for Singleton class
+ (GCAssetUploader *)sharedManager
{
    if (sharedAssetUploader == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedAssetUploader = [[super allocWithZone:NULL] init];
        });
    }
    return sharedAssetUploader;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release;
{
    //nothing
}

- (id)autorelease
{
    return self;
}

@end
