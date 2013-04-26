//
//  GCServiceVoteSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/26/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCServiceVote.h"
#import "GCVoteCount.h"
#import "GCVote.h"

SPEC_BEGIN(GCServiceVoteSpec)

describe(@"GCServiceVote", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET Votes Count", ^{
        
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0/assets/1/votes" parameters:nil];
            [GCServiceVote getVoteCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceVote getVoteCountForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets/1/votes" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCVoteCount *voteCount) = ^(GCResponseStatus *responseStatus, GCVoteCount *heartCount) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceVote getVoteCountForAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"POST Add Vote", ^{
        
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/votes" parameters:nil];
            [GCServiceVote voteAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceVote voteAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/votes" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCVote *vote) = ^(GCResponseStatus *responseStatus, GCVote *vote) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceVote voteAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    context(@"DELETE a Vote", ^{
        
        it(@"should create a request.", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/votes/abc" parameters:nil];
            [GCServiceVote removeVote:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceVote removeVote:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/votes/abc" parameters:nil ];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCVote *vote) = ^(GCResponseStatus *responseStatus, GCVote *vote) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceVote removeVote:@"abc" assetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
});

SPEC_END


