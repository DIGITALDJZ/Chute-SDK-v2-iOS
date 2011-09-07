//
//  GCChute.m
//
//  Created by Achal Aggarwal on 01/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCChute.h"

@implementation GCChute


@synthesize assetsCount;
@synthesize contributersCount;
@synthesize membersCount;

@synthesize moderateComments;
@synthesize moderateMembers;
@synthesize moderatePhotos;

@synthesize name;

@synthesize permissionAddComments;
@synthesize permissionAddMembers;
@synthesize permissionAddPhotos;
@synthesize permissionView;

@synthesize recentCount;
@synthesize recentParcelId;

@synthesize recentThumbnailUrl;

@synthesize recentUserId;

@synthesize shortcut;

#pragma mark - Accessors Override
- (NSUInteger)assetsCount
{
    return [[self objectForKey:@"assets_count"] intValue];
}

- (NSUInteger)contributersCount
{
    return [[self objectForKey:@"contributers_count"] intValue];
}

- (NSUInteger)membersCount
{
    return [[self objectForKey:@"members_count"] intValue];
}

- (GCPermissionType)moderateComments
{
    return [[self objectForKey:@"moderate_comments"] intValue];
}

- (void)setModerateComments:(GCPermissionType)aModerateComments
{
    [self setObject:[NSString stringWithFormat:@"%d", aModerateComments] forKey:@"moderate_comments"];
}

- (GCPermissionType)moderateMembers
{
    return [[self objectForKey:@"moderate_members"] intValue];
}
- (void)setModerateMembers:(GCPermissionType)aModerateMembers
{
    [self setObject:[NSString stringWithFormat:@"%d", aModerateMembers] forKey:@"moderate_members"];
}

- (GCPermissionType)moderatePhotos
{
    return [[self objectForKey:@"moderate_photos"] intValue];
}
- (void)setModeratePhotos:(GCPermissionType)aModeratePhotos
{
    [self setObject:[NSString stringWithFormat:@"%d", aModeratePhotos] forKey:@"moderate_photos"];
}

- (NSString *)name
{
    return [[[self objectForKey:@"name"] retain] autorelease]; 
}
- (void)setName:(NSString *)aName
{
    [aName retain];
    [self setObject:aName forKey:@"name"];
    [aName release];
}

- (GCPermissionType)permissionAddComments
{
    return [[self objectForKey:@"permission_add_comments"] intValue];
}
- (void)setPermissionAddComments:(GCPermissionType)aPermissionAddComments
{
    [self setObject:[NSString stringWithFormat:@"%d", aPermissionAddComments] forKey:@"permission_add_comments"];
}

- (GCPermissionType)permissionAddMembers
{
    return [[self objectForKey:@"permission_add_members"] intValue];
}
- (void)setPermissionAddMembers:(GCPermissionType)aPermissionAddMembers
{
    [self setObject:[NSString stringWithFormat:@"%d", aPermissionAddMembers] forKey:@"permission_add_members"];
}

- (GCPermissionType)permissionAddPhotos
{
    return [[self objectForKey:@"permission_add_photos"] intValue];
}
- (void)setPermissionAddPhotos:(GCPermissionType)aPermissionAddPhotos
{
    [self setObject:[NSString stringWithFormat:@"%d", aPermissionAddPhotos] forKey:@"permission_add_photos"];
}

- (GCPermissionType)permissionView
{
    return [[self objectForKey:@"permission_view"] intValue];
}
- (void)setPermissionView:(GCPermissionType)aPermissionView
{
    [self setObject:[NSString stringWithFormat:@"%d", aPermissionView] forKey:@"permission_view"];
}

- (NSUInteger)recentCount
{
    return [[self objectForKey:@"recent_count"] intValue];
}

- (NSUInteger)recentParcelId
{
    return [[self objectForKey:@"recent_parcel_id"] intValue];
}

- (NSString *)recentThumbnailUrl
{
    return [[[self objectForKey:@"recent_thumbnail_url"] retain] autorelease];
}

- (NSUInteger)recentUserId
{
    return [[self objectForKey:@"recent_user_id"] intValue];
}

- (NSString *)shortcut
{
    return [[[self objectForKey:@"shortcut"] retain] autorelease];
}


#pragma mark - JSON Representation Method
- (id)proxyForJson {
    NSMutableDictionary *_temp = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *key in [_content allKeys]) {
        if ([key isEqualToString:@"user"])
            continue;
        [_temp setObject:[_content objectForKey:key] forKey:key];
    }
    return _temp;
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
