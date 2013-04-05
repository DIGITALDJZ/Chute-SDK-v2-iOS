//
//  GCClient.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 12/7/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import "GCClient.h"
#import "AFJSONRequestOperation.h"
#import "GCResponse.h"
#import "GCResponseStatus.h"
#import "GCPagination.h"
#import "DCKeyValueObjectMapping.h"

NSString * const kGCClientGET = @"GET";
NSString * const kGCClientPOST = @"POST";
NSString * const kGCClientPUT = @"PUT";
NSString * const kGCClientDELETE = @"DELETE";

static NSString * const kGCResponse = @"response";
static NSString * const kGCData = @"data";
static NSString * const kGCPagination = @"pagination";

@implementation GCClient

static NSString * const kGCBaseURLString = @"https://api.getchute.com/v2/";
static dispatch_queue_t serialQueue;

+ (GCClient *)sharedClient {
    static GCClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.serialqueue", NULL);
        _sharedClient = [[GCClient alloc] initWithBaseURL:[NSURL URLWithString:kGCBaseURLString]];
    });
    
    [_sharedClient setParameterEncoding:AFJSONParameterEncoding];
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Internet connection detected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
// Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//	[self setDefaultHeader:@"Accept" value:@"application/json"];
	[self setDefaultHeader:@"Content-Type" value:@"application/json"];

    
//    dispatch_sync(serialQueue, ^{
//        NSDictionary *user = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//        if ([user objectForKey:@"ApiToken"]) {
//            apiToken = [user objectForKey:@"ApiToken"];
//        }
//        if ([user objectForKey:@"Username"]) {
//            username = [user objectForKey:@"Username"];
//        }
//    });
    
    return self;
}

#pragma mark - Overrided Methods

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"OAuth %@", token]];
}

#pragma mark - the root of all evil
// request, class, success, failure

- (void)request:(NSMutableURLRequest *)request factoryClass:(Class)factoryClass success:(void (^)(GCResponse *))success failure:(void (^)(NSError *))failure {
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        DCKeyValueObjectMapping *responseParser = [DCKeyValueObjectMapping mapperForClass:[GCResponseStatus class]];
        DCKeyValueObjectMapping *dataParser = [DCKeyValueObjectMapping mapperForClass:factoryClass];
        DCKeyValueObjectMapping *paginationParser = [DCKeyValueObjectMapping mapperForClass:[GCPagination class]];
        
        GCResponse *gcResponse = [GCResponse new];
        gcResponse.response = [responseParser parseDictionary:[JSON objectForKey:kGCResponse]];
        
        if (factoryClass != nil) {
            if ([[JSON objectForKey:kGCData] isKindOfClass:[NSArray class]]) {
                gcResponse.data = [dataParser parseArray:[JSON objectForKey:kGCData]];
            } else {
                gcResponse.data = [dataParser parseDictionary:[JSON objectForKey:kGCData]];
            }
        }
        
        gcResponse.pagination = [paginationParser parseDictionary:[JSON objectForKey:kGCPagination]];
        
        success(gcResponse);
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", JSON);
        
        failure(error);
        
    }];
    
    [operation start];
}

@end
