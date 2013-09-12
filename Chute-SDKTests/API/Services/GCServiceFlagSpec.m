//
//  NewKiwiSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCServiceFlag.h"
#import "GCFlagCount.h"
#import "GCFlag.h"

SPEC_BEGIN(GCServiceFlagSpec)

describe(@"GCServiceFlag", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET Flags Count", ^{
        
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0/assets/1/flags" parameters:nil];
            [GCServiceFlag getFlagCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceFlag getFlagCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets/1/flags" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCFlagCount *flagCount) = ^(GCResponseStatus *responseStatus, GCFlagCount *heartCount) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceFlag getFlagCountForAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"POST Add Flag", ^{
        
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/flags" parameters:nil];
            [GCServiceFlag flagAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceFlag flagAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/flags" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCFlag *flag) = ^(GCResponseStatus *responseStatus, GCFlag *flag) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceFlag flagAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    context(@"DELETE a Flag", ^{
        
        it(@"should create a request.", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/flags/abc" parameters:nil];
            [GCServiceFlag removeFlag:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceFlag removeFlag:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/flags/abc" parameters:nil ];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCFlag *flag) = ^(GCResponseStatus *responseStatus, GCFlag *flag) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceFlag removeFlag:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
});

SPEC_END


