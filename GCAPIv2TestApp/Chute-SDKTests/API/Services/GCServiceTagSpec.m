//
//  GCServiceTagSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/24/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCResponse.h"
#import "GCServiceTag.h"

SPEC_BEGIN(GCServiceTagSpec)

describe(@"GCServiceTag", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
    context(@"GET List Tags", ^{
       
        it(@"should create a request.", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0/assets/1/tags" parameters:nil];
            [GCServiceTag getTagsForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceTag getTagsForAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets/1/tags" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, NSArray *tags) = ^(GCResponseStatus *responseStatus, NSArray *tags) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceTag getTagsForAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    context(@"POST Add Tags", ^{
        
        __block NSString *tag1, *tag2, *tag3;
        
        beforeAll(^{
            tag1 = @"Test Tag";
            tag2 = @"Second Test Tag";
            tag3 = @"Third Test Tag";
        });
        
        it(@"should create a request.", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/tags" parameters:params];
            [GCServiceTag addTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceTag addTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/assets/1/tags" parameters:params];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, NSArray *tags) = ^(GCResponseStatus *responseStatus, NSArray *tags) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
                        
            [GCServiceTag addTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
//            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });

    context(@"PUT Replace Tags", ^{
        
        __block NSString *tag1, *tag2, *tag3;
        
        beforeAll(^{
            tag1 = @"Test Tag";
            tag2 = @"Second Test Tag";
            tag3 = @"Third Test Tag";
        });
        
        it(@"should create a request.", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPUT path:@"albums/0/assets/1/tags" parameters:params];
            [GCServiceTag replaceTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceTag replaceTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:@"albums/0/assets/1/tags" parameters:params];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, NSArray *tags) = ^(GCResponseStatus *responseStatus, NSArray *tags) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
                        
            [GCServiceTag replaceTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            
            [[requestSpy.argument should] equal:request];
//            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    context(@"DELETE Tags", ^{
        
        __block NSString *tag1, *tag2, *tag3;
        
        beforeAll(^{
            tag1 = @"Test Tag";
            tag2 = @"Second Test Tag";
            tag3 = @"Third Test Tag";
        });
        
        it(@"should create a request.", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/tags" parameters:params];
            [GCServiceTag deleteTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceTag deleteTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSDictionary *params = @{@"tags": @[tag1, tag2, tag3]};
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/tags" parameters:params];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, NSArray *tags) = ^(GCResponseStatus *responseStatus, NSArray *tags) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceTag deleteTags:@[tag1, tag2, tag3] forAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            
            [[requestSpy.argument should] equal:request];
            //            [[factoryClassSpy.argument should] beNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
});

SPEC_END


