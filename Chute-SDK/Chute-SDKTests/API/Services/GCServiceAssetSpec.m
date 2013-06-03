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
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"/albums/0/assets" parameters:@{@"per_page":@"100"}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            __block void (^success)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) = ^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {};
            __block void (^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceAsset getAssetsForAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
    });
    
    context(@"GET asset from album", ^{
        
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"albums/0/assets/1" parameters:nil];
            
            [GCServiceAsset getAssetWithID:@(1) fromAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getAssetWithID:@(1) fromAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"albums/0/assets/1" parameters:nil];
           
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void (^success)(GCResponseStatus *responseStatus, GCAsset *asset)=^(GCResponseStatus *responseStatus, GCAsset *asset){};
            void(^failure)(NSError *error) = ^(NSError *error) {};
            
            [GCServiceAsset getAssetWithID:@(1) fromAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
        
    });
    
    context(@"GET List of assets", ^{
        
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"assets" parameters:@{@"per_page":@"100"}];
            [GCServiceAsset getAssetsWithSuccess:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getAssetsWithSuccess:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"assets" parameters:@{@"per_page":@"100"}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];

            void(^success)(GCResponseStatus *responseStatus,NSArray *assets, GCPagination *pagination) = ^(GCResponseStatus *responseStatus,NSArray *assets, GCPagination *pagination){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset getAssetsWithSuccess:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

            
        });
    });
    
    context(@"GET asset", ^{
        
        it(@"should create a request", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"assets/1" parameters:nil];
            [GCServiceAsset getAssetWithID:@(1) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getAssetWithID:@(1) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"assets/1" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, GCAsset *asset) = ^(GCResponseStatus *responseStatus, GCAsset *asset){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset getAssetWithID:@(1) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
    });
    
    context(@"POST import assets", ^{
        
        __block NSString *url1, *url2, *url3;
        
        beforeAll(^{
            
            url1 = @"http://example.com/1";
            url2 = @"http://example.com/2";
            url3 = @"http://example.com/3";
        });
        
        it(@"should create a request", ^{
            
            NSDictionary *params = @{@"urls": @[url1, url2,url3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"assets/import" parameters:params];
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:nil success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:nil success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{

            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"assets/import" parameters:@{@"urls":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination)=^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:nil success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
    });
    
    context(@"POST import assets for album", ^{
        
        __block NSString *url1, *url2, *url3;
        
        beforeAll(^{
            
            url1 = @"http://example.com/1";
            url2 = @"http://example.com/2";
            url3 = @"http://example.com/3";
        });
        
        it(@"should create a request", ^{
            
            NSDictionary *params = @{@"urls": @[url1, url2,url3]};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPOST path:@"albums/0/assets/import" parameters:params];
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:@(0) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:@(0) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"albums/0/assets/import" parameters:@{@"urls":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination)=^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset importAssetsFromURLs:@[url1,url2,url3] forAlbumWithID:@(0) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
            
        });
    });
    
    context(@"PUT caption in asset", ^{
       
        it(@"should create a request", ^{
            
            NSString *caption = @"Test Caption";
            NSDictionary *params = @{@"caption": caption};
            
            [[[apiClient should] receive] requestWithMethod:kGCClientPUT path:@"assets/1" parameters:params];
            [GCServiceAsset updateAssetWithID:@(1) caption:caption success:nil failure:nil];
            
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset updateAssetWithID:@(1) caption:@"caption" success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPUT path:@"assets/1" parameters:@{@"caption":@""}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];

            void(^success)(GCResponseStatus *responseStatus, GCAsset *asset)= ^(GCResponseStatus *responseStatus, GCAsset *asset){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset updateAssetWithID:@(1) caption:@"caption" success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"DELETE asset", ^{
       
        it(@"should create a request", ^{
            [[[apiClient should] receive] requestWithMethod:kGCClientDELETE path:@"assets/1" parameters:nil];
            [GCServiceAsset deleteAssetWithID:@(1) success:nil failure:nil];
        });
        
        it(@"call GCClient factory method", ^{
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset deleteAssetWithID:@(1) success:nil failure:nil];
        });
        
        it(@"should use request, class, success & failure blocks", ^{
           
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientDELETE path:@"assets/1" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus) = ^(GCResponseStatus *responseStatus) {};
            void (^ failure) (NSError *error) = ^ (NSError *error) {};
            
            [GCServiceAsset deleteAssetWithID:@(1) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
        
    });
    
    context(@"GET geo coordinate for asset", ^{
        it(@"should create a request", ^{
            
            [[[apiClient should] receive] requestWithMethod:kGCClientGET path:@"assets/1/geo" parameters:nil];
            [GCServiceAsset getGeoCoordinateForAssetWithID:@(1) success:nil failure:nil];
            
        });
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getGeoCoordinateForAssetWithID:@(1) success:nil failure:nil];
            
        });
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"assets/1/geo" parameters:nil];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, GCCoordinate *coordinate) = ^(GCResponseStatus *responseStatus,GCCoordinate *coordinate) {};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            
            [GCServiceAsset getGeoCoordinateForAssetWithID:@(1) success:success failure:failure];
            
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];
        });
    });
    
    
    
/////////// JUST CHECK THIS CONTEXT, IS IT OK THE USE OF "COORDINATE" /////////////////
    
    
    
    context(@"GET assets for central coordinate", ^{
        
        __block GCCoordinate *coordinate = [GCCoordinate new];
        
        beforeAll(^{
            
            [coordinate setLatitude:@(1)];
            [coordinate setLongitude:@(2)];
            
        });
       
        it(@"should create a request", ^{
           
            [[[apiClient should]receive]requestWithMethod:kGCClientGET path:@"assets/geo/1,2/3" parameters:@{@"per_page":@"100"}];
            [GCServiceAsset getAssetsForCentralCoordinate:coordinate andRadius:@(3) success:nil failure:nil];
                        
        });
        
        it(@"call GCClient factory method", ^{
            
            [[apiClient should] receive:@selector(request:factoryClass:success:failure:)];
            [GCServiceAsset getAssetsForCentralCoordinate:coordinate andRadius:@(3) success:nil failure:nil];
            
        });
        
        it(@"should use request, class, success & failure blocks", ^{
            
            NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientGET path:@"assets/geo/1,2/3" parameters:@{@"per_page":@"100"}];
            
            KWCaptureSpy *requestSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:0];
            KWCaptureSpy *factoryClassSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:1];
            KWCaptureSpy *successSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:2];
            KWCaptureSpy *failureSpy = [apiClient captureArgument:@selector(request:factoryClass:success:failure:) atIndex:3];
            
            void(^success)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination ) = ^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination){};
            void(^failure)(NSError *error) = ^(NSError *error){};
            
            [GCServiceAsset getAssetsForCentralCoordinate:coordinate andRadius:@(3) success:success failure:failure];
           
            [[requestSpy.argument should] equal:request];
            [[factoryClassSpy.argument should] beNonNil];
            [[failureSpy.argument should] equal:failure];
            [[successSpy.argument should] beNonNil];

        });
        
    });
    
});

SPEC_END