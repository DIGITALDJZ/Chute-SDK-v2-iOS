//
//  GCChute.h
//
//  Created by Achal Aggarwal on 01/09/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "GCResource.h"

typedef enum {
    GCPermissionTypePrivate = 0,
    GCPermissionTypeMembers,
    GCPermissionTypePublic,
    GCPermissionTypeFriends
} GCPermissionType;

@interface GCChute : GCResource


@property (nonatomic, readonly) NSUInteger assetsCount;
@property (nonatomic, readonly) NSUInteger contributersCount;
@property (nonatomic, readonly) NSUInteger membersCount;

@property (nonatomic, assign) GCPermissionType moderateComments;
@property (nonatomic, assign) GCPermissionType moderateMembers;
@property (nonatomic, assign) GCPermissionType moderatePhotos;

@property (nonatomic, assign) NSString *name;

@property (nonatomic, assign) GCPermissionType permissionAddComments;
@property (nonatomic, assign) GCPermissionType permissionAddMembers;
@property (nonatomic, assign) GCPermissionType permissionAddPhotos;
@property (nonatomic, assign) GCPermissionType permissionView;

@property (nonatomic, readonly) NSUInteger recentCount;
@property (nonatomic, readonly) NSUInteger recentParcelId;

@property (nonatomic, readonly) NSString *recentThumbnailUrl;

@property (nonatomic, readonly) NSUInteger recentUserId;

@property (nonatomic, readonly) NSString *shortcut;


/*
"assets_count" = 4;
"contributors_count" = 1;
"members_count" = 1;
 
"moderate_comments" = 0;
"moderate_members" = 0;
"moderate_photos" = 0;

 name = test1;

"permission_add_comments" = 1;
"permission_add_members" = 1;
"permission_add_photos" = 1;
"permission_view" = 2;

 "recent_count" = 1;
"recent_parcel_id" = 21;
"recent_thumbnail" = "http://media.edge.getchute.com/media/Mqftl";
"recent_user_id" = 9;
shortcut = tdpec;

user =     {
    avatar = "<null>";
    id = 9;
    name = "<null>";
};
*/

@end
