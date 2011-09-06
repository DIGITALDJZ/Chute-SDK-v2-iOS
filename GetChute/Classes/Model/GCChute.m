//
//  GCChute.m
//
//  Created by Achal Aggarwal on 01/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCChute.h"

@implementation GCChute

@synthesize name;

- (id)proxyForJson {
    NSMutableDictionary *_temp = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *key in [_content allKeys]) {
        if ([key isEqualToString:@"user"])
            continue;
        [_temp setObject:[_content objectForKey:key] forKey:key];
    }
    return _temp;
}

- (NSString *) name {
    return [self objectForKey:@"name"];
}

- (void) setName:(NSString *)_name {
    [self setObject:_name forKey:@"name"];
}

+ (id) new {
    NSString *_base = @"{\"name\":\"Untitled\",\"permission_view\":0,\"permission_add_members\":0,\"permission_add_photos\":0,\"permission_add_comments\":0,\"moderate_members\":false,\"moderate_photos\":false,\"moderate_comments\":false}";
    return [self objectWithDictionary:[_base JSONValue]];
}

#pragma mark - Super Class Methods
+ (NSString *)elementName {
    return @"chutes";
}

@end
