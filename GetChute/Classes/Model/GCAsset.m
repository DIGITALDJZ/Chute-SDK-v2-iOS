//
//  GCAsset.m
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAsset.h"
#import "GCAssetUploader.h"

NSString * const GCAssetStatusChanged   = @"GCAssetStatusChanged";
NSString * const GCAssetProgressChanged = @"GCAssetProgressChanged";

@implementation GCAsset

@synthesize alAsset;
@synthesize thumbnail;
@synthesize selected;
@synthesize progress;
@synthesize status;

- (NSDictionary *) uniqueRepresentation {
    ALAssetRepresentation *_representation = [alAsset defaultRepresentation];
    return [NSDictionary dictionaryWithObjectsAndKeys:[[_representation url] absoluteString], @"filename", 
     [NSString stringWithFormat:@"%d", [_representation size]], @"size", 
     [NSString stringWithFormat:@"%d", [_representation size]], @"md5", 
     nil];
}

- (NSString *) uniqueURL {
    return [[[alAsset defaultRepresentation] url] absoluteString];
}

#pragma mark - Upload

- (void) upload {
    [[GCAssetUploader sharedUploader] addAsset:self];
}

#pragma mark - Accessors Override
- (UIImage *) thumbnail {
    if ([self status] == GCAssetStateNew && alAsset) {
        return [UIImage imageWithCGImage:[alAsset thumbnail]];
    }
    else if([self status] == GCAssetStateFinished) {
        return [self imageForWidth:75 andHeight:75];
    }
    return nil;
}

- (void) setProgress:(CGFloat)aProgress {
    progress = aProgress;
    DLog(@"%f", progress*100);
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAssetProgressChanged object:self];
}

- (void) setStatus:(GCAssetStatus)aStatus {
    status = aStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAssetStatusChanged object:self];
}

- (NSString*)urlStringForImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    if ([self status] == GCAssetStateNew)
        return nil;
    
    NSString *urlString = [self objectForKey:@"url"];
    
    if(urlString)
        urlString   = [urlString stringByAppendingFormat:@"/%dx%d",width,height];
    return urlString;
}

- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height{
    if ([self status] == GCAssetStateNew)
        return nil;
    
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


#pragma mark - Memory Management
- (id) init {
    self = [super init];
    if (self) {
        [self setStatus:GCAssetStateNew];
    }
    return  self;
}

- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        [self setStatus:GCAssetStateFinished];
    }
    return self;
}

- (void) dealloc {
    [alAsset release];
    [super dealloc];
}

#pragma mark - Super Class Methods
+ (NSString *)elementName {
    return @"assets";
}

@end
