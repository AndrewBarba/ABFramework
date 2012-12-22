//
//  ABRequired.h
//  ABFramework
//
//  Created by Andrew Barba on 11/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABRequired : NSObject
// APP INFO
#define APP_NAME       @"abarba_app"
#define BUILD_KEY      [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]
#define FIRST_RUN_KEY  [NSString stringWithFormat:@"%@_%@",APP_NAME,BUILD_KEY]
#define VERSION_KEY    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// COMPLETION HANDLERS
typedef void(^DoneHandler)       (void);
typedef void(^SuccessHandler)    (BOOL);
typedef void(^ObjectHandler)     (id);
typedef BOOL(^ObjectHandlerTest) (id);
typedef void(^IntegerHandler)    (NSUInteger);
typedef void(^ArrayHandler)      (NSArray*);
typedef void(^DictionaryHandler) (NSDictionary*);
typedef void(^StringHandler)     (NSString*);
typedef void(^RequestHandler)    (NSString*,NSData*,NSError*);

+(BOOL)isFirstRun; // Should only be called by the app delegate
+(BOOL)isiPad;
+(BOOL)isiPhone;
+(void)alertTitle:(NSString *)title withMessage:(NSString *)message;
+(UIStoryboard *)iphoneStoryboard;
+(UIStoryboard *)ipadStoryboard;
+(void)initViewController:(NSString *)identifier inNavigationController:(UINavigationController *)nav;
+(BOOL)isTallScreen;
@end
