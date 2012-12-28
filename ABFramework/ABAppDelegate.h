//
//  ABAppDelegate.h
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ABRequired.h"

@interface ABAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

#pragma mark Instance Methods

-(NSNumber *)isFirstRun;

#pragma mark Static Accessors

+(ABAppDelegate *)appDelegate;
+(UIDocument *)mainDocument;
+(NSManagedObjectContext *)mainContext;
+(NSManagedObjectContext *)importContext;

#pragma mark UIDocument

/*
 * Begin using the document. Creates document if it doesnt exist, opens if closed, nothing if opened
 */
+(void)useDocument:(DoneHandler)complete;

/*
 * Reset the document. Useful for modelchanges
 */
+(void)resetDocument:(DoneHandler)complete;

/*
 * Save the import context. If notifications are properly setup, this will automatically update the main context
 */
+(void)updateContexts;

/*
 * Save the UIDocument to disk
 */
+(void)saveDocument:(SuccessHandler)complete;

/*
 * Imports data in the background and then updates the main context
 * You may need to update the context more often (manually) if importing a large data set
 * Generally I update sqrt(n) times for n pieces of data. I found this to be the best combo of speed and memory efficiency
 */
+(void)performImport:(DoneHandler)importBlock;

#pragma mark Facebook

/*
 * Opens a Facebook session and shows the login UX if not iOS6.
 * Takes calls a block with the active auth_token when complete, nil on failure
 */
+(void)openFBSession:(StringHandler)complete;

/*
 * Requested permissions for Facebook login, override in subclass to provide additional permissions
 */
-(NSArray *)facebookAccessPermissions;

#define FBSessionStateChangedNotification @"com.abarba.Login:FBSessionStateChangedNotification"
@end
