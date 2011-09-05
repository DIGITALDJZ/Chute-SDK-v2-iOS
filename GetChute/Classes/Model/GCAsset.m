//
//  GCAsset.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAsset.h"

@implementation GCAsset

- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    
    NSString *urlString = [self objectForKey:@"url"];
    
    if(urlString)
        urlString   = [urlString stringByAppendingFormat:@"/%dx%d",width,height];
    
    NSURL *url      = [NSURL URLWithString:urlString];
    NSData *data    = [NSData dataWithContentsOfURL:url];
    UIImage *image  = nil;
    
    if(data)
        image = [UIImage imageWithData:data];
    return image;
}

- (void)imageForWidth:(NSUInteger)width 
            andHeight:(NSUInteger)height 
inBackgroundWithCompletion:(void (^)(UIImage *))aResponseBlock {    
    DO_IN_BACKGROUND([self imageForWidth:width andHeight:height], aResponseBlock);
}

//superclass methods
+ (NSString *)elementName {
    return @"assets";
}

@end
