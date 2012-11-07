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

+(void)useDocument:(DoneCompletionHandler)complete
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate useDocument:complete];
}

+(void)resetDocument:(DoneCompletionHandler)complete
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate resetDocument:complete];
}

+(void)updateContexts
{
    ABAppDelegate *appDelegate = [ABAppDelegate appDelegate];
    [appDelegate updateContexts];
}

/*** LAUNCH SETUP ***/
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.isFirstRun = [AB isFirstRun];
    return YES;
}

/*** CORE DATA SETUP ***/

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

-(void)resetDocument:(DoneCompletionHandler)complete
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.mainDocument.fileURL path]]) {
        if (self.mainDocument.documentState == UIDocumentStateNormal) {
            [self.mainDocument closeWithCompletionHandler:^(BOOL done){
                [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
                [self setupDocument];
                [self useDocument:complete];
            }];
        } else {
            [[NSFileManager defaultManager] removeItemAtURL:self.mainDocument.fileURL error:nil];
            [self setupDocument];
            [self useDocument:complete];
        }
    }
}

-(void)useDocument:(DoneCompletionHandler)complete
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

-(void)setupImportContext
{
    self.importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.importContext setPersistentStoreCoordinator:self.mainDocument.managedObjectContext.persistentStoreCoordinator];
    [self.importContext setUndoManager:nil];
    [self initContextNotifications];
}

-(void)merge:(NSNotification *)notification
{
    [self.mainDocument.managedObjectContext performBlockAndWait:^{
        [self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [self.importContext performBlockAndWait:^{
            [self.importContext reset];
        }];
        NSLog(@"Merged importContext");
    }];
}

-(void)initContextNotifications
{
    [self.mainDocument.managedObjectContext performBlock:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self.importContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(merge:)
                                                     name:NSManagedObjectContextDidSaveNotification object:self.importContext];
    }];
}

-(void)updateContexts
{
    [self.importContext performBlockAndWait:^{
        [self.importContext save:nil];
    }];
}

@end
