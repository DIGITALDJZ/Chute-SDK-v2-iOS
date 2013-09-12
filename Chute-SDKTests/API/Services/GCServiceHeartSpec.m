//
//  GCServiceHeartSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/25/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCServiceHeart.h"
#import "GCHeartCount.h"
#import "GCHeart.h"

SPEC_BEGIN(GCServiceHeartSpec)

describe(@"GCServiceHeart", ^{
   
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET Hearts Count", ^{
    
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0/assets/1/hearts" parameters:nil];
            [GCServiceHeart getHeartCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceHeart getHeartCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });

        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets/1/hearts" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCHeartCount *heartCount) = ^(GCResponseStatus *responseStatus, GCHeartCount *heartCount) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceHeart getHeartCountForAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"POST Add Heart", ^{
        
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/hearts" parameters:nil];
            [GCServiceHeart heartAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceHeart heartAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/hearts" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCHeart *heart) = ^(GCResponseStatus *responseStatus, GCHeart *heart) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceHeart heartAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });

    context(@"DELETE a Heart. (Un-Heart an Asset)", ^{
        
        it(@"should create a request.", ^{
                        
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/hearts/abc" parameters:nil];
            [GCServiceHeart unheart:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceHeart unheart:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/hearts/abc" parameters:nil ];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCHeart *heart) = ^(GCResponseStatus *responseStatus, GCHeart *heart) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceHeart unheart:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
});

SPEC_END


