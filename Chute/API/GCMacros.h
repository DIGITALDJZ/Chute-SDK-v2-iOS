//
//  GCMacros.h
//  KitchenSink
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 NA. All rights reserved.
//
#ifndef ChuteMacros_h
#define ChuteMacros_h

//Comment this line to stop debug log on the debugger console.
#define DEBUG

typedef void(^ChuteBasicBlock)(void);
typedef void(^ChuteErrorBlock)(NSError *error);
typedef void(^ChuteResponseBlock)(id response);

#define kJSONResponse 1

#define DO_IN_BACKGROUND(action, responseBlock, errorBlock) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {\
NSError *_error = nil;\
id _response = action;\
dispatch_async(dispatch_get_main_queue(), ^(void) {\
if (_error == nil) {\
if(responseBlock)\
responseBlock(_response);\
}\
else {\
if(errorBlock)\
errorBlock(_error);\
}\
});\
});

////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define IS_NULL(x)	((nil == x) || ([x isEqual: [NSNull null]]))

////////////////////////////////////////////////////////////////////////////////////////////////////////

#endif


