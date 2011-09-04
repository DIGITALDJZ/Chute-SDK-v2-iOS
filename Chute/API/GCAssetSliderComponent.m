//
//  genericSliderController.m
//  realtyChute
//
//  Created by Brandon Coston on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCAssetSliderComponent.h"


@implementation GCAssetSliderComponent
@synthesize objectDictionaries, sliderObjects;

- (CGRect)rectForPage:(NSInteger)page{
    CGRect imageRect = CGRectMake((objectSlider.frame.size.width*(page-1)), 0, objectSlider.frame.size.width, objectSlider.frame.size.height);
    return imageRect;
}

- (void) resizeScrollView
{
    NSUInteger size = [[self objectDictionaries] count];
    [objectSlider setContentSize:CGSizeMake(objectSlider.frame.size.width * size, objectSlider.frame.size.height)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{ 
    [self loadObjectsForCurrentPosition];
}

- (void)loadObjectsForCurrentPosition
{
    if(![self objectDictionaries])
        return;
    if([[self objectDictionaries] count] == 0)
        return;
    currentPage = ((objectSlider.contentOffset.x - objectSlider.frame.size.width / 2) / objectSlider.frame.size.width) + 2; 
    BOOL foundCurrent = NO;
    BOOL foundPrevious = NO;
    BOOL foundNext = NO;
    
    
    // Unload views too far away
    for (UIView *v in [objectSlider subviews])
    {
        if (v.tag == currentPage)
        {
            foundCurrent = YES;
            continue;
        }
        
        if (v.tag == (currentPage + 1))
        {
            foundNext = YES;
            continue;
        }
        
        if (v.tag == (currentPage - 1))
        {
            foundPrevious = YES;
            continue;
        }
        
        // Remove images
        if (v.tag != 0)
        {
            [v removeFromSuperview];
        }
    }
    
    // Load Images    
    if (foundCurrent == NO)
    {
        [self queueObjectRetrievalForPage:(currentPage)];
    }
    
    if (foundNext == NO)
    {
        [self queueObjectRetrievalForPage:(currentPage + 1)];
    }
    
    if (foundPrevious == NO)
    {
        [self queueObjectRetrievalForPage:(currentPage - 1)];
    }
}

-(UIView*) viewForPage:(NSInteger)page{
    //TODO Override in subclass
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NULL;
}

//varies depending on objects.  Implement in child class
- (void) queueObjectRetrievalForPage:(NSInteger)page
{
    if (page < 1 || page > ([[self objectDictionaries] count]))
    {
        return;
    }
    UIView* v = [self viewForPage:(page-1)];
    [v setFrame:[self rectForPage:page]];
    v.tag = page;
    [objectSlider addSubview:v];
}

//fill objectDictionaries in child's implementaion then call [super prepareSliderObjects]
-(void)prepareSliderObjects{
    [self resizeScrollView];
    [self loadObjectsForCurrentPosition];
}

- (void)switchToObjectAtIndex:(NSNumber*)index{
    [self switchToObjectAtIndex:[index unsignedIntValue] animated:NO];
}
- (void)switchToObjectAtIndex:(NSUInteger)index animated:(BOOL)_animated{
    if(index > [[self objectDictionaries] count])
        index = [[self objectDictionaries] count];
    [objectSlider scrollRectToVisible:[self rectForPage:index] animated:_animated];
    [self performSelector:@selector(loadObjectsForCurrentPosition) withObject:nil afterDelay:.4];
}


- (void)nextObject{
    if(currentPage >= ([[self objectDictionaries] count]))
        return;
    [self switchToObjectAtIndex:(currentPage+1) animated:YES];
}
- (void)previousObject{
    if(currentPage <= 1)
        return;
    [self switchToObjectAtIndex:(currentPage-1) animated:YES];
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self prepareSliderObjects];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[table setAllowsSelection:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
