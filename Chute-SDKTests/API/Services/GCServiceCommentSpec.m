//
//  GCCommentService.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/22/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCServiceComment.h"
#import "GCClient.h"
#import "GCComment.h"
#import "GCResponse.h"

SPEC_BEGIN(GCServiceCommentSpec)

describe(@"GCServiceComment", ^{
    
    __block GCClient *apiClient = nil;
    
    beforeAll(^{
        
        apiClient = [GCClient sharedClient];
        
    });
    
   context(@"GET List Comments", ^{
       
       it(@"should create a request.", ^{
           [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/1/assets/0/comments" parameters:nil];
           [GCServiceComment getCommentsForAssetWithID:@(0) inAlbumWithID:@(1) success:nil failure:nil];

       });
              
       it(@"call GCClient factory method.", ^{
           
           [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
           [GCServiceComment getCommentsForAssetWithID:@(0) inAlbumWithID:@(1) success:nil failure:nil];
           
       });
       
       it(@"should use request, class, success & failure blocks", ^{
           
           
           NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/1/assets/0/comments" parameters:nil];
                      
           KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
           KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
           KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
           KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
           
           
           void (^success)(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination) = ^(GCResponseStatus *responseStatus, NSArray *comments, GCPagination *pagination) {};
           void (^failure)(NSError *error) = ^(NSError *error) {};

//           Class gcComment = [GCComment class];
           
           [GCServiceComment getCommentsForAssetWithID:@(0) inAlbumWithID:@(1) success:success failure:failure];
           
           [[requestSpy.argument should] equal:request];
           [[factoryClassSpy.argument should] beNonNil];
           [[failureSpy.argument should] equal:failure];
           [[successSpy.argument should] beNonNil];
       });
   });

    context(@"POST Create Comment", ^{
        
        it(@"should create a request.", ^{
            
            NSString *comment = @"Test Comment";
            NSString *name = @"Test Name";
            NSString *email = @"test@email.com";
            
            NSDictionary *params = @{@"comment_text":comment, @"name":name, @"email":email};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/1/assets/0/comments" parameters:params];
            [GCServiceComment createComment:comment forUserWithName:name andEmail:email forAssetWithID:@(0) inAlbumWithID:@(1) success:nil failure:nil];
        });

        it(@"should create a request (without name & email).", ^{
            
            NSString *comment = @"Test Comment";
            
            NSDictionary *params = @{@"comment_text":comment};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/1/assets/0/comments" parameters:params];
            [GCServiceComment createComment:comment forUserWithName:nil andEmail:nil forAssetWithID:@(0) inAlbumWithID:@(1) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceComment createComment:@"comment" forUserWithName:nil andEmail:nil forAssetWithID:@(0) inAlbumWithID:@(1) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/1/assets/0/comments" parameters:@{@"name":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCComment *comment) = ^(GCResponseStatus *responseStatus, GCComment *comment) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceComment createComment:@"" forUserWithName:nil andEmail:nil forAssetWithID:@(0) inAlbumWithID:@(1) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    context(@"DELETE Comment", ^{
       
        it(@"should create a request", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/comments/2" parameters:nil];
            [GCServiceComment deleteCommentWithID:@(2) forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method.", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];//request:request factoryClass:[GCComment class] success:nil failure:nil];
            [GCServiceComment deleteCommentWithID:@(2) forAssetWithID:@(1) inAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"albums/0/assets/1/comments/2" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            
            void (^success)(GCResponseStatus *responseStatus, GCComment *comment) = ^(GCResponseStatus *responseStatus, GCComment *comment) {};
            void (^failure)(NSError *error) = ^(NSError *error) {};
            
            //           Class gcComment = [GCComment class];
            
            [GCServiceComment deleteCommentWithID:@(2) forAssetWithID:@(1) inAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });

});

SPEC_END


