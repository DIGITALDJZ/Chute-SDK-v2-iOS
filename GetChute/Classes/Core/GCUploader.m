//
//  GCUploader.m
//
//  Created by Achal Aggarwal on 09/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCUploader.h"

static GCUploader *sharedUploader = nil;

@implementation GCUploader

@synthesize queue;

- (void) addParcel:(GCParcel *) _parcel {
    [queue addObject:_parcel];
}

- (void) removeParcel:(GCParcel *) _parcel {
    [queue addObject:_parcel];
}

#pragma mark - Methods for Singleton class
+ (GCUploader *)sharedUploader
{
    if (sharedUploader == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedUploader = [[super allocWithZone:NULL] init];
        });
    }
    return sharedUploader;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedUploader] retain];
}

- (id) init {
    self = [super init];
    if (self) {
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
    [super dealloc];
}

@end
