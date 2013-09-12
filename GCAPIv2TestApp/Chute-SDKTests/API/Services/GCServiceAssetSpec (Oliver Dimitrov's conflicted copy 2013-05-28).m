//
//  GCServiceAssetSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/24/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCServiceAsset.h"
#import "GCAsset.h"

SPEC_BEGIN(GCServiceAssetSpec)

describe(@"GCServiceAsset", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET List Assets from album", ^{
       
        it(@"should create a request.", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"/albums/0/assets" parameters:@{@"per_page":@"100"}];
            [GCServiceAsset getAssetsForAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getAssetsForAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets" parameters:@{@"per_page":@"100"}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void (^success)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) = ^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceAsset getAssetsForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
    });
    
    // NEED IMPLEMENTING THE OTHER METHODS
});

SPEC_END