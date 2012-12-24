//
//  ABAppDelegate.m
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABAppDelegate.h"

@interface ABAppDelegate()
@property (nonatomic, strong) UIManagedDocument *mainDocument;
@property (nonatomic, strong) NSManagedObjectContext *importContext;
@property (nonatomic) BOOL isFirstRun;
-(void)setupDocument;
@end

@implementation ABAppDelegate

/*** STATIC ACCESSORS ***/

+(ABAppDelegate *)appDelegate
{
    return (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(UIDocument *)mainDocument
{
    return [ABAppDelegate appDelegate].mainDocument;
}

+(NSManagedObjectContext *)mainContext
{
    return [ABAppDelegate appDelegate].mainDocument.managedObjectContext;
}

+(NSManagedObjectContext *)importContext
{
    return [ABAppDelegate appDelegate].importContext;
}

+(void)useDocument:(DoneHandler)complete
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate useDocument:complete];
}

+(void)resetDocument:(DoneHandler)complete
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate resetDocument:complete];
}

+(void)updateContexts
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate updateContexts];
}

+(void)saveDocument:(SuccessHandler)complete
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate saveDocument:complete];
}

/*
 * Imports data in the background and then updates the main context
 * You may need to update the context more often (manually) if importing a large data set
 * Generally I update sqrt(n) times for n pieces of data. I found this to be the best combo of speed and memory efficiency
 */
+(void)performImport:(DoneHandler)importBlock
{
    [[ABAppDelegate importContext] performBlock:^{
        importBlock();
        [ABAppDelegate updateContexts];
    }];
}

/*** LAUNCH SETUP ***/
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.isFirstRun = [ABRequired isFirstRun];
    return YES;
}

/*** CORE DATA PRIVATE SETUP ***/
/*** These should only be called by this class, use the static accessors ***/

-(void)setupDocument
{
    if (!self.mainDocument) {
        NSURL *fileURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        fileURL = [fileURL URLByAppendingPathComponent:@"MAIN_DOCUMENT"];
        self.mainDocument = [[UIManagedDocument alloc] initWithFileURL:fileURL];
        NSDictionary *options =
        @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
          NSInferMappingModelAutomaticallyOption:@(YES)};
        self.mainDocument.persistentStoreOptions = options;
    }
}

/*
 * Reset the document. Useful for modelchanges
 */
-(void)resetDocument:(DoneHandler)complete
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.mainDocument.fileURL path]]) {
        if (self.mainDocument.documentState == UIDocumentStateNormal) {
            [self.mainDocument closeWithCompletionHandler:^(BOOL done){
                [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
                [self useDocument:complete];
            }];
        } else {
            [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
            [self useDocument:complete];
        }
    }
}

/*
 * Begin using the document
 */
-(void)useDocument:(DoneHandler)complete
{
    [self setupDocument];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.mainDocument.fileURL path]]) {
        [self.mainDocument saveToURL:self.mainDocument.fileURL
                    forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL x){
                       [self setupImportContext];
                       if (complete) complete();
                   }];
    } else if (self.mainDocument.documentState == UIDocumentStateClosed) {
        [self.mainDocument openWithCompletionHandler:^(BOOL x){
            [self setupImportContext];
            if (complete) complete();
        }];
    } else if (self.mainDocument.documentState == UIDocumentStateNormal) {
        if (complete) complete();
    }
}

/*
 * Create the import context on a background thread
 */
-(void)setupImportContext
{
    self.importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.importContext setPersistentStoreCoordinator:self.mainDocument.managedObjectContext.persistentStoreCoordinator];
    [self.importContext setUndoManager:nil];
    [self initContextNotifications];
}

/*
 * Merge the import context and the main context
 */
-(void)merge:(NSNotification *)notification
{
    [self.mainDocument.managedObjectContext performBlockAndWait:^{
        [self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [self.importContext performBlock:^{
            [self.importContext reset];
        }];
    }];
}

/*
 * Setup a notifification to merge contexts everytime the import context save something
 */
-(void)initContextNotifications
{
    [self.mainDocument.managedObjectContext performBlock:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self.importContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(merge:)
                                                     name:NSManagedObjectContextDidSaveNotification object:self.importContext];
    }];
}

/*
 * Save the import context. If notifications are properly setup, this will automatically update the main context
 */
-(void)updateContexts
{
    [self.importContext performBlockAndWait:^{
        [self.importContext save:nil];
    }];
}

/*
 * Save the UIDocument to disk
 */
-(void)saveDocument:(SuccessHandler)complete
{
    [self.mainDocument performAsynchronousFileAccessUsingBlock:^{
        [self.mainDocument saveToURL:self.mainDocument.fileURL
                    forSaveOperation:UIDocumentSaveForOverwriting
                   completionHandler:complete];
    }];
}

/*** LIFECYLCLE METHODS ***

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveDocument];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}
*/
@end
