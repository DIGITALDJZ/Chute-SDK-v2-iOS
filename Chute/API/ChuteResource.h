//
//  ChuteResource.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//

#import "ChuteNetwork.h"

@interface ChuteResource : ChuteNetwork

/* Get all Objects of this class */
+ (NSArray *)all;
+ (void)allInBackgroundWithCompletion:(ChuteResponseBlock) aResponseBlock andError:(ChuteErrorBlock) anErrorBlock;
+ (void)all_Path:(NSString **)path AndConfiguringParams:(NSMutableDictionary **)params;

@end
