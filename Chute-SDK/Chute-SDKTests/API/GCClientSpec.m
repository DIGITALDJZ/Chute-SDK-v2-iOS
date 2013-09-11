//
//  GCClientSpec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/19/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCClient.h"
#import "GCAsset.h"
#import "GCAlbum.h"
#import "GCResponse.h"

@interface GCClient (testPrivateMethods)
- (void)parseJSON:(id)JSON withFactoryClass:(Class)factoryClass success:(void (^)(GCResponse *))success;
@end

SPEC_BEGIN(GCClientSpec)

describe(@"GCClient", ^{
    
    context(@"a singleton object", ^{
        
        __block GCClient *apiClient;
        
        beforeAll(^{
            apiClient = [GCClient sharedClient];
        });
        
        it(@"should not be nil.", ^{
            [apiClient shouldNotBeNil];
        });
        
        it(@"should have baseURL.", ^{
            [[apiClient baseURL] shouldNotBeNil];
        });
        
        it(@"should be singleton", ^{
            GCClient *secondClient = [GCClient sharedClient];
            [[apiClient should] beIdenticalTo:secondClient];
        });
        
    });
    
    context(@"parsing JSON response", ^{
       
        __block GCClient *apiClient;
        __block NSArray *responses;
        __block NSError *error;
        __block NSData *data;
        __block id JSON;
        
        beforeAll(^{
            apiClient = [GCClient sharedClient];
            
            NSString *listAlbums = @"{\r\n  \"response\": {\r\n    \"title\": \"Sample Request\",\r\n    \"version\": 2,\r\n    \"code\": 200,\r\n    \"href\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"api_limits\": {\r\n      \"max_monthly_calls\": 3720000,\r\n      \"available_monthly_calls\": 3719999,\r\n      \"max_hourly_calls\": 5000,\r\n      \"available_hourly_calls\": 4999\r\n    }\r\n  },\r\n  \"data\": [\r\n    {\r\n      \"id\": 1212,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\",\r\n          \"title\": \"Album Details\"\r\n        },\r\n        \"assets\": {\r\n          \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\/assets\",\r\n          \"title\": \"Asset Listing\"\r\n        }\r\n      },\r\n      \"counters\": {\r\n        \"photos\": 0,\r\n        \"videos\": 0,\r\n        \"inbox\": 0\r\n      },\r\n      \"shortcut\": \"jylfrd\",\r\n      \"name\": \"Name-2\",\r\n      \"user\": {\r\n        \"id\": 8280,\r\n        \"links\": {\r\n          \"self\": {\r\n            \"href\": \"http:\/\/api.chute.com:8989\/v2\/users\/8280\",\r\n            \"title\": \"User Details\"\r\n          }\r\n        },\r\n        \"name\": null,\r\n        \"username\": null,\r\n        \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n      },\r\n      \"moderate_media\": false,\r\n      \"moderate_comments\": false,\r\n      \"created_at\": \"2012-10-13T13:19:59Z\"\r\n    },\r\n    {\r\n      \"id\": 1212,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\",\r\n          \"title\": \"Album Details\"\r\n        },\r\n        \"assets\": {\r\n          \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\/assets\",\r\n          \"title\": \"Asset Listing\"\r\n        }\r\n      },\r\n      \"counters\": {\r\n        \"photos\": 0,\r\n        \"videos\": 0,\r\n        \"inbox\": 0\r\n      },\r\n      \"shortcut\": \"jylfrd\",\r\n      \"name\": \"Name-2\",\r\n      \"user\": {\r\n        \"id\": 8280,\r\n        \"links\": {\r\n          \"self\": {\r\n            \"href\": \"http:\/\/api.chute.com:8989\/v2\/users\/8280\",\r\n            \"title\": \"User Details\"\r\n          }\r\n        },\r\n        \"name\": null,\r\n        \"username\": null,\r\n        \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n      },\r\n      \"moderate_media\": false,\r\n      \"moderate_comments\": false,\r\n      \"created_at\": \"2012-10-13T13:19:59Z\"\r\n    }\r\n  ],\r\n  \"pagination\": {\r\n    \"total_pages\": 1,\r\n    \"current_page\": 1,\r\n    \"next_page\": null,\r\n    \"previous_page\": null,\r\n    \"first_page\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"last_page\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"per_page\": 5\r\n  }\r\n}";
            
            NSString *getAlbum = @"{\r\n  \"response\": {\r\n    \"title\": \"Sample Request\",\r\n    \"version\": 2,\r\n    \"code\": 200,\r\n    \"href\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"api_limits\": {\r\n      \"max_monthly_calls\": 3720000,\r\n      \"available_monthly_calls\": 3719999,\r\n      \"max_hourly_calls\": 5000,\r\n      \"available_hourly_calls\": 4999\r\n    }\r\n  },\r\n  \"data\": {\r\n    \"id\": 1212,\r\n    \"links\": {\r\n      \"self\": {\r\n        \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\",\r\n        \"title\": \"Album Details\"\r\n      },\r\n      \"assets\": {\r\n        \"href\": \"http:\/\/api.chute.com:8989\/v2\/albums\/1212\/assets\",\r\n        \"title\": \"Asset Listing\"\r\n      }\r\n    },\r\n    \"counters\": {\r\n      \"photos\": 0,\r\n      \"videos\": 0,\r\n      \"inbox\": 0\r\n    },\r\n    \"shortcut\": \"jylfrd\",\r\n    \"name\": \"Name-2\",\r\n    \"user\": {\r\n      \"id\": 8280,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.chute.com:8989\/v2\/users\/8280\",\r\n          \"title\": \"User Details\"\r\n        }\r\n      },\r\n      \"name\": null,\r\n      \"username\": null,\r\n      \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n    },\r\n    \"moderate_media\": false,\r\n    \"moderate_comments\": false,\r\n    \"created_at\": \"2012-10-13T13:19:59Z\"\r\n  }\r\n}";
            
            NSString *listAssets = @"{\r\n  \"response\": {\r\n    \"title\": \"Sample Request\",\r\n    \"version\": 2,\r\n    \"code\": 200,\r\n    \"href\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"api_limits\": {\r\n      \"max_monthly_calls\": 3720000,\r\n      \"available_monthly_calls\": 3719999,\r\n      \"max_hourly_calls\": 5000,\r\n      \"available_hourly_calls\": 4999\r\n    }\r\n  },\r\n  \"data\": [\r\n    {\r\n      \"id\": 27803615,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\",\r\n          \"title\": \"Asset Details\"\r\n        },\r\n        \"exif\": {\r\n          \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\/exif\",\r\n          \"title\": \"Exif Details\"\r\n        }\r\n      },\r\n      \"thumbnail\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\/75x75\",\r\n      \"url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\",\r\n      \"type\": \"image\",\r\n      \"caption\": \"some caption\",\r\n      \"dimensions\": {\r\n        \"width\": null,\r\n        \"height\": null\r\n      },\r\n      \"source\": {\r\n        \"source\": \"imported\",\r\n        \"source_id\": null,\r\n        \"source_url\": \"http:\/\/farm5.static.flickr.com\/4138\/4758470218_b0f3cf0d44.jpg\",\r\n        \"service\": null,\r\n        \"import_id\": null,\r\n        \"import_url\": null,\r\n        \"original_url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\"\r\n      },\r\n      \"user\": {\r\n        \"id\": 545,\r\n        \"links\": {\r\n          \"self\": {\r\n            \"href\": \"http:\/\/api.getchute.com\/v2\/users\/545\",\r\n            \"title\": \"User Details\"\r\n          }\r\n        },\r\n        \"name\": \"darko1002001\",\r\n        \"username\": \"darko1002001\",\r\n        \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n      }\r\n    },\r\n    {\r\n      \"id\": 27803615,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\",\r\n          \"title\": \"Asset Details\"\r\n        },\r\n        \"exif\": {\r\n          \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\/exif\",\r\n          \"title\": \"Exif Details\"\r\n        }\r\n      },\r\n      \"thumbnail\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\/75x75\",\r\n      \"url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\",\r\n      \"type\": \"image\",\r\n      \"caption\": \"some caption\",\r\n      \"dimensions\": {\r\n        \"width\": null,\r\n        \"height\": null\r\n      },\r\n      \"source\": {\r\n        \"source\": \"imported\",\r\n        \"source_id\": null,\r\n        \"source_url\": \"http:\/\/farm5.static.flickr.com\/4138\/4758470218_b0f3cf0d44.jpg\",\r\n        \"service\": null,\r\n        \"import_id\": null,\r\n        \"import_url\": null,\r\n        \"original_url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\"\r\n      },\r\n      \"user\": {\r\n        \"id\": 545,\r\n        \"links\": {\r\n          \"self\": {\r\n            \"href\": \"http:\/\/api.getchute.com\/v2\/users\/545\",\r\n            \"title\": \"User Details\"\r\n          }\r\n        },\r\n        \"name\": \"darko1002001\",\r\n        \"username\": \"darko1002001\",\r\n        \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n      }\r\n    }\r\n  ],\r\n  \"pagination\": {\r\n    \"total_pages\": 1,\r\n    \"current_page\": 1,\r\n    \"next_page\": null,\r\n    \"previous_page\": null,\r\n    \"first_page\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"last_page\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"per_page\": 5\r\n  }\r\n}";
            NSString *getAsset = @"{\r\n  \"response\": {\r\n    \"title\": \"Sample Request\",\r\n    \"version\": 2,\r\n    \"code\": 200,\r\n    \"href\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"api_limits\": {\r\n      \"max_monthly_calls\": 3720000,\r\n      \"available_monthly_calls\": 3719999,\r\n      \"max_hourly_calls\": 5000,\r\n      \"available_hourly_calls\": 4999\r\n    }\r\n  },\r\n  \"data\": {\r\n    \"id\": 27803615,\r\n    \"links\": {\r\n      \"self\": {\r\n        \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\",\r\n        \"title\": \"Asset Details\"\r\n      },\r\n      \"exif\": {\r\n        \"href\": \"http:\/\/api.getchute.com\/v2\/assets\/27803615\/exif\",\r\n        \"title\": \"Exif Details\"\r\n      }\r\n    },\r\n    \"thumbnail\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\/75x75\",\r\n    \"url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\",\r\n    \"type\": \"image\",\r\n    \"caption\": \"some caption\",\r\n    \"dimensions\": {\r\n      \"width\": null,\r\n      \"height\": null\r\n    },\r\n    \"source\": {\r\n      \"source\": \"imported\",\r\n      \"source_id\": null,\r\n      \"source_url\": \"http:\/\/farm5.static.flickr.com\/4138\/4758470218_b0f3cf0d44.jpg\",\r\n      \"service\": null,\r\n      \"import_id\": null,\r\n      \"import_url\": null,\r\n      \"original_url\": \"http:\/\/media.getchute.com\/media\/1SEZpxsjf\"\r\n    },\r\n    \"user\": {\r\n      \"id\": 545,\r\n      \"links\": {\r\n        \"self\": {\r\n          \"href\": \"http:\/\/api.getchute.com\/v2\/users\/545\",\r\n          \"title\": \"User Details\"\r\n        }\r\n      },\r\n      \"name\": \"darko1002001\",\r\n      \"username\": \"darko1002001\",\r\n      \"avatar\": \"http:\/\/static.getchute.com\/v1\/images\/avatar-100x100.png\"\r\n    }\r\n  }\r\n}";
           
            NSString *getTags = @"{\r\n  \"response\": {\r\n    \"title\": \"Sample Request\",\r\n    \"version\": 2,\r\n    \"code\": 200,\r\n    \"href\": \"http:\/\/api.getchute.com\/v2\/\",\r\n    \"api_limits\": {\r\n      \"max_monthly_calls\": 3720000,\r\n      \"available_monthly_calls\": 3719999,\r\n      \"max_hourly_calls\": 5000,\r\n      \"available_hourly_calls\": 4999\r\n    }\r\n  },\r\n  \"data\": [\r\n    \"Test1\",\r\n    \"Test2\"\r\n  ]\r\n}";
            
            responses = @[listAlbums, getAlbum, listAssets, getAsset, getTags];
        });
        
        beforeEach(^{
            error = nil;
            data = nil;
            JSON = nil;
        });
        
        it(@"should parse List Albums", ^{
            data = [responses[0] dataUsingEncoding:NSUTF8StringEncoding];
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            [error shouldBeNil];
            [apiClient parseJSON:JSON withFactoryClass:[GCAlbum class] success:^(GCResponse *response) {
                [response shouldNotBeNil];
                [response.data shouldNotBeNil];
                [response.response shouldNotBeNil];
                [response.pagination shouldNotBeNil];
            }];
        });
        
        it(@"should parse Get Album", ^{
            data = [responses[1] dataUsingEncoding:NSUTF8StringEncoding];
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            [error shouldBeNil];
            [apiClient parseJSON:JSON withFactoryClass:[GCAlbum class] success:^(GCResponse *response) {
                [response shouldNotBeNil];
                [response.data shouldNotBeNil];
                [response.response shouldNotBeNil];
                [response.pagination shouldBeNil];
            }];
        });
        
        it(@"should parse List Assets", ^{
            data = [responses[2] dataUsingEncoding:NSUTF8StringEncoding];
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            [error shouldBeNil];
            [apiClient parseJSON:JSON withFactoryClass:[GCAsset class] success:^(GCResponse *response) {
                [response shouldNotBeNil];
                [response.data shouldNotBeNil];
                [response.response shouldNotBeNil];
                [response.pagination shouldNotBeNil];
            }];
        });
        
        it(@"should parse Get Asset", ^{
            data = [responses[3] dataUsingEncoding:NSUTF8StringEncoding];
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            [error shouldBeNil];
            [apiClient parseJSON:JSON withFactoryClass:[GCAsset class] success:^(GCResponse *response) {
                [response shouldNotBeNil];
                [response.data shouldNotBeNil];
                [response.response shouldNotBeNil];
                [response.pagination shouldBeNil];
            }];
        });
        
        it(@"should parse Get Tags", ^{
            data = [responses[4] dataUsingEncoding:NSUTF8StringEncoding];
            JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            [error shouldBeNil];
            [apiClient parseJSON:JSON withFactoryClass:nil success:^(GCResponse *response) {
                [response shouldNotBeNil];
                [response.data shouldNotBeNil];
                [response.response shouldNotBeNil];
                [response.pagination shouldBeNil];
                
                [[response.data should] equal:@[@"Test1",@"Test2"]];
            }];
        });
        
    });
    
});

SPEC_END


