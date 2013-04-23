//
//  GCOAuth2Spec.m
//  Chute-SDK
//
//  Created by Aleksandar Trpeski on 4/19/13.
//  Copyright 2013 Aleksandar Trpeski. All rights reserved.
//

#import "Kiwi.h"
#import "GCOAuth2Client.h"

SPEC_BEGIN(GCOAuth2Spec)

describe(@"GCOAuth2Spec", ^{
   
   context(@"", ^{
       
       it(@"should return an oauth request.", ^{
           GCOAuth2Client *oauthClient = [GCOAuth2Client clientWithClientID:@"50d9c930018d1672df00002e" clientSecret:@"ee9b33013c0592aa41d30d1f347ff62514b737e61e6ce9c64fb13a44d31917d9"];
           [oauthClient shouldNotBeNil];
           NSURLRequest *request = [oauthClient requestAccessForService:GCServiceFoursquare];
           [request shouldNotBeNil];
       });
       
   });
    
});

SPEC_END


