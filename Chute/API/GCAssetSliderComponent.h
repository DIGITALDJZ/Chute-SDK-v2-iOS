//
//  genericSliderController.h
//  realtyChute
//
//  Created by Brandon Coston on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChuteSDK.h"

@interface GCAssetSliderComponent : GCUIBaseViewController {
    NSMutableArray *sliderObjects;
    NSArray *objectDictionaries;
    IBOutlet UIScrollView *objectSlider;
    NSInteger currentPage;
}
@property (nonatomic, retain) NSArray *objectDictionaries;
@property (nonatomic, retain) NSMutableArray *sliderObjects;

//can override to add custom behavior when finished switching pages.  Reccomended to call [super loadObjectsForCurrentPosition] in your implementation though to insure views are loaded properly in slider.  This method is not required to be overridden.
- (void)loadObjectsForCurrentPosition;


//Implement in child class.  Page is zero indexed.  Any UIView or subclass should work, please retain any objects that you need to use with the view.  This method must be overridden.
- (UIView*)viewForPage:(NSInteger)page;

//Must override in child to load objects for use in slider.  Please load info into objectDictionaries array to properly set up slider.  sliderObjects may also be used to retain objects if needed, but is not required.  This method must be overridden but it is recomended to call [super prepareSliderObjects] at the end of your implemention to set up the slider unless you choose to set it up yourself in the implementation.
- (void)prepareSliderObjects;


- (void)resizeScrollView;

- (void)nextObject;
- (void)previousObject;

- (void)switchToObjectAtIndex:(NSUInteger)index animated:(BOOL)_animated;
//same as switchToObjectAtIndex: animated: with NO passed in to animated field
- (void)switchToObjectAtIndex:(NSNumber*)index;

//returns the size and position of a view for a given page.  Note that page is not zero indexed.  Page indexing starts at 1.
- (CGRect)rectForPage:(NSInteger)page;

- (void)queueObjectRetrievalForPage:(NSInteger)page;

@end
