//
//  AB.h
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AB.h"
#import "NSString+AB.h"
#import "NSDate+AB.h"

// APP INFO
#define APP_NAME       @"abarba_app"
#define BUILD_KEY      [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]
#define REFRESH_DB_KEY [NSString stringWithFormat:@"%@_%@",APP_NAME,BUILD_KEY]
#define VERSION_KEY    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// COMPLETION HANDLERS
typedef void(^DoneCompletionHandler)(void);
typedef void(^SuccessCompletionHandler)(BOOL);
typedef void(^IntegerCompletionHandler)(NSUInteger);
typedef void(^ArrayCompletionHandler)(NSMutableArray*);
typedef void(^DictionaryCompletionHandler)(NSDictionary*);
typedef void(^StringCompletionHandler)(NSString*);
typedef void(^RequestCompletionHandler)(NSString*,NSError*);

@interface AB : NSObject
+(BOOL)isFirstRun;
+(BOOL)isiPad;
+(void)alertTitle:(NSString *)title withMessage:(NSString *)message;

@end
