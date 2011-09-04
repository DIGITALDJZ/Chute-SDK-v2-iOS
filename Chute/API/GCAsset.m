//
//  GCAsset.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAsset.h"

@implementation GCAsset

-(UIImage*)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    NSString *urlString = [self objectForKey:@"url"];
    if(urlString)
    urlString = [urlString stringByAppendingFormat:@"/%ix%i",width,height];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = NULL;
    if(data)
        image = [UIImage imageWithData:data];
    return image;
}
- (void)imageInBackgroundForWidth:(NSUInteger)width andHeight:(NSUInteger)height WithCompletion:(void (^)(UIImage *))aResponseBlock andError:(ChuteErrorBlock) anErrorBlock {
    DO_IN_BACKGROUND(
                     [self imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height],
                     ^(id response){
                         if(response)
                             aResponseBlock((UIImage*)response);
                         else
                             anErrorBlock([NSError errorWithDomain:@"Image not found" code:404 userInfo:nil]);
                     },
                     anErrorBlock);
}

-(NSString*)assetID{
    if([self objectForKey:@"id"])
        return [NSString stringWithFormat:@"%@",[self objectForKey:@"id"]];
    return NULL;
}

//superclass methods
+ (NSString *)elementName {
    return @"assets";
}

+ (BOOL)supportsMetaData {
    return YES;
}



- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc{
    [super dealloc];
}

@end
