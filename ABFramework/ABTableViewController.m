//
//  ABTableViewController.m
//  ABFramework
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UITableView+AB.h"

@interface ABTableViewController ()

@end

@implementation ABTableViewController

-(void)setUpResultsControllerWithEntity:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                                  limit:(NSInteger)limit
                     andSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    if (limit > 0) [request setFetchLimit:limit];
    if (predicate) request.predicate = predicate;
    if (sortDescriptors) request.sortDescriptors = sortDescriptors;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ABAppDelegate mainContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)changeRequestEntity:(NSString *)entity
{
    if (![entity isEqualToString:self.fetchedResultsController.fetchRequest.entity.description]) {
        self.fetchedResultsController.fetchRequest.entity =
        [NSEntityDescription entityForName:entity
                    inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
        [self animateUpdates];
    }
}

-(void)changeRequestPredicate:(NSPredicate *)predicate
{
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    [self animateUpdates];
}

-(void)animateUpdates
{
    NSArray *oldObjects = self.fetchedResultsController.fetchedObjects;
    [self performFetch];
    NSArray *newObjects = self.fetchedResultsController.fetchedObjects;
    [self.tableView reorderOldArray:oldObjects toNewArray:newObjects];
}

- (void)performFetch
{
    [self.fetchedResultsController performFetch:nil];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    if (_fetchedResultsController != newfrc) {
        _fetchedResultsController = newfrc;
        _fetchedResultsController.delegate = self;
        if (newfrc) {
            [self performFetch];
        } else {
            [self.tableView reloadData];
        }
    }
    [self.contentChangedDelegate contentDidChange:[self numberOfObjects]];
}

// TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

// NSFetchedResultsController Delegate Methods

-(NSUInteger)numberOfObjects
{
    return self.fetchedResultsController.fetchedObjects.count;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.contentChangedDelegate contentDidChange:[self numberOfObjects]];
    [self.tableView endUpdates];
    CGFloat delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}

- (void)controller:(NSFetchedResultsController *)controller
didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
atIndex:(NSUInteger)sectionIndex
forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.tableView.isEditing)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeMove:
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.tableView.isEditing)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeUpdate:
                //[self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }
}

@end
