//
//  GCChute.m
//
//  Created by Achal Aggarwal on 01/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCChute.h"

@implementation GCChute

+ (id) new {
    id _obj = [self alloc];
    
    return _obj;
}

#pragma mark - Super Class Methods
+ (NSString *)elementName {
    return @"chutes";
}

@end
