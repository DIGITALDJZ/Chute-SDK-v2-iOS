//
//  GCAsset.m
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAsset.h"

@implementation GCAsset

- (NSString*)urlStringForImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    NSString *urlString = [self objectForKey:@"url"];
    
    if(urlString)
        urlString   = [urlString stringByAppendingFormat:@"/%dx%d",width,height];
    return urlString;
}

- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    
    NSString *urlString = [self urlStringForImageWithWidth:width andHeight:height];
    
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

#pragma mark - Super Class Methods
+ (NSString *)elementName {
    return @"assets";
}

@end
