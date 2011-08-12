//
//  ChuteAsset.m
//  ChuteSDK
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChuteAsset.h"


@implementation ChuteAsset

@synthesize alAsset;
@synthesize thumbnail;
@synthesize url;
@synthesize selected;
@synthesize progress;

- (id)initWithAsset:(ALAsset *)anAlAsset andURL:(NSString *)aurl{
    self = [super init];
    if (self) {
        self.alAsset = anAlAsset;
        self.url     = aurl;
        self.selected = NO;
    }
    return self;
}

- (void)dealloc{
    [url release];
    [thumbnail release];
    [super dealloc];
}

- (UIImage *)thumbnail{
    if (thumbnail) {
        return thumbnail;
    }
    thumbnail = [UIImage imageWithCGImage:[alAsset thumbnail]];
    return thumbnail;
}

- (void) toggle {
    self.selected = !self.selected;
}

@end
