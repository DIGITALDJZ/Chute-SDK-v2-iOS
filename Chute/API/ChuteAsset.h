//
//  ChuteAsset.h
//  ChuteSDK
//
//  Created by Gaurav Sharma on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ChuteAsset : NSObject {
    ALAsset *alAsset;
    NSString *url;
    UIImage *thumbnail;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) ALAsset *alAsset;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat progress;


- (id)initWithAsset:(ALAsset *)anAlAsset andURL:(NSString *)url;
- (void) toggle;

@end
