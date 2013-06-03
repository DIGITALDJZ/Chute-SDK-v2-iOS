//
//  GCServiceAssetSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/24/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCServiceAlbum.h"
#import "GCAlbum.h"
#import "GCAsset.h"

SPEC_BEGIN(GCServiceAlbumSpec)


describe(@"GCServiceAlbum", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET album", ^{
       
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0" parameters:nil];
            [GCServiceAlbum getAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum getAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, GCAlbum *album) = ^(GCResponseStatus *responseStatus, GCAlbum *album){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum getAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

        });
        
    });
    
    context(@"GET all albums", ^{
       
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums" parameters:nil];
            [GCServiceAlbum getAlbumsWithSuccess:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum getAlbumsWithSuccess:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];

            void(^success)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination) = ^(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum getAlbumsWithSuccess:success failure:failure];
        
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

        });
        
    });

    context(@"POST create an album", ^{
        
        __block NSString *name;
        __block BOOL moderateMedia, moderateComments;
       
        beforeAll(^{
            
            name = @"MyAlbum";
            moderateMedia= YES; // works also with nil!
            moderateComments = YES;
            
        });
        
        it(@"should create a request", ^{
            
           
            NSDictionary *param = @{@"name":name, @"moderate_media":@(moderateMedia),@"moderate_comments":@(moderateComments)};
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums" parameters:param];
            [GCServiceAlbum createAlbumWithName:name moderateMedia:moderateMedia moderateComments:moderateComments success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum createAlbumWithName:name moderateMedia:moderateMedia moderateComments:moderateComments success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums" parameters:@{@"name":@"",@"moderate_media":@"",@"moderate_comments":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, GCAlbum *album) = ^(GCResponseStatus *responseStatus, GCAlbum *album){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            
            [GCServiceAlbum createAlbumWithName:name moderateMedia:moderateMedia moderateComments:moderateComments success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
        
    });
    
    context(@"PUT update an album", ^{
        
        __block NSString *name;
        __block BOOL moderateMedia, moderateComments;
        
        beforeAll(^{
            
            name = @"MyAlbum";
            moderateMedia= YES;
            moderateComments = YES;
            
        });
        
        it(@"should create a request", ^{
            
            
            NSDictionary *param = @{@"name":name, @"moderate_media":@(moderateMedia),@"moderate_comments":@(moderateComments)};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPUT path:@"albums/0" parameters:param];
            [GCServiceAlbum updateAlbumWithID:@(0) name:name moderateMedia:moderateMedia moderateComments:moderateComments success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum updateAlbumWithID:@(0) name:name moderateMedia:moderateMedia moderateComments:moderateComments success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:@"albums/0" parameters:@{@"name":@"",@"moderate_media":@"",@"moderate_comments":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, GCAlbum *album) = ^(GCResponseStatus *responseStatus, GCAlbum *album){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            
            [GCServiceAlbum updateAlbumWithID:@(0) name:name moderateMedia:moderateMedia moderateComments:moderateComments success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

            
        });
        
    });
    
    context(@"DELETE album", ^{
        
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0" parameters:nil];
            [GCServiceAlbum deleteAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should]receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum deleteAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum deleteAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

        });
        
    });
    
    context(@"POST add assets in album", ^{
        __block NSString *asset1, *asset2, *asset3;
        
        beforeAll(^{
            asset1 = @"23131231";
            asset2 = @"12332423";
            asset3 = @"2343243232";
        });
        
        it(@"should create a request", ^{
            
            NSDictionary *param = @{@"asset_ids":@[asset1, asset2, asset3]};
            
            [[[apiClient should]receive]requestWithMethod:kGCClientPOST path:@"albums/0/add_assets" parameters:param];
            [GCServiceAlbum addAssets:@[asset1, asset2, asset3] ForAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum addAssets:@[asset1, asset2, asset3] ForAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/add_assets" parameters:@{@"asset_ids":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];

            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum addAssets:@[asset1,asset2,asset3] ForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"POST add assets in album", ^{
        
        __block GCAsset *asset1 = [GCAsset new];
        __block GCAsset *asset2 = [GCAsset new];
        
        beforeAll(^{
            [asset1 setId:@(123)];
            [asset2 setId:@(234)];
        });
        
        it(@"should create a request", ^{
            
            NSDictionary *param  = @{@"asset_ids":@[asset1.id,asset2.id]};
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/add_assets" parameters:param];
            [GCServiceAlbum addAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum addAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/add_assets" parameters:@{@"asset_ids":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum addAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"POST remove assets from album", ^{
        
        __block NSString *asset1, *asset2, *asset3;
        
        beforeAll(^{
            asset1 = @"23131231";
            asset2 = @"12332423";
            asset3 = @"2343243232";
        });
        
        it(@"should create a request", ^{
            
             NSDictionary *param = @{@"asset_ids":@[asset1, asset2, asset3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/remove_assets" parameters:param];
            [GCServiceAlbum removeAssets:@[asset1,asset2,asset3] ForAlbumWithID:@(0) success:nil failure:nil];
        
        });
        
        it(@"call GCClient method", ^{
            [[apiClient should]receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum removeAssets:@[asset1,asset2,asset3] ForAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/remove_assets" parameters:@{@"asset_ids":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum removeAssets:@[asset1,asset2,asset3] ForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
        
    });
    
    context(@"POST remove assets from album", ^{
        __block GCAsset *asset1 = [GCAsset new];
        __block GCAsset *asset2 = [GCAsset new];
        
        beforeAll(^{
            
            [asset1 setId:@(123)];
            [asset2 setId:@(234)];
        });
        
        it(@"should create a request", ^{
            
            NSDictionary *param  = @{@"asset_ids":@[asset1.id,asset2.id]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/remove_assets" parameters:param];
            [GCServiceAlbum removeAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAlbum removeAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/remove_assets" parameters:@{@"asset_ids":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAlbum removeAssets:@[asset1,asset2] ForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });


});
SPEC_END