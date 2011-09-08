//
//  GCAssetUploader.m
//
//  Created by Achal Aggarwal on 08/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCAssetUploader.h"

static GCAssetUploader *sharedAssetUploader = nil;

@implementation GCAssetUploader

@synthesize queue;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"queue"]) {
        //Check for GCAssets with status new and start uploading them.
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Instance Methods

- (void) addAsset:(GCAsset *) anAsset {
    [[self queue] addObject:anAsset];
}

- (void) removeAsset:(GCAsset *) anAsset {
    [[self queue] removeObject:anAsset];
}

- (void) assetUpdated:(NSNotification *) notification {
    if ([[notification object] status] == GCAssetStateFinished) {
        [self removeAsset:[notification object]];
    }
}

#pragma mark - Methods for Singleton class
+ (GCAssetUploader *)sharedUploader
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
    return [[self sharedUploader] retain];
}

- (id) init {
    self = [super init];
    if (self) {
        queue = [[NSMutableSet alloc] init];
        [self addObserver:self forKeyPath:@"queue" options:0 context:nil];
    }
    return self;
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

- (void) dealloc {
    [queue release];
    [super dealloc];
}

@end
