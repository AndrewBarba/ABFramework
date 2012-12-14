//
//  ABAppDelegate.h
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ABRequired.h"

@interface ABAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

// Public Dynamic Methods
-(BOOL)isFirstRun;

// Static Get Methods
+(ABAppDelegate *)appDelegate;
+(UIDocument *)mainDocument;
+(NSManagedObjectContext *)mainContext;
+(NSManagedObjectContext *)importContext;

// UIDocument Methods
+(void)useDocument:(DoneHandler)complete;
+(void)resetDocument:(DoneHandler)complete;
+(void)updateContexts;
+(void)saveDocument:(SuccessHandler)complete;
@end
