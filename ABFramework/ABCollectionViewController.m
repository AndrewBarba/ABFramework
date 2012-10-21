//
//  ABCollectionViewController.m
//  ABFramework
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABCollectionViewController.h"
#import "ABAppDelegate.h"
#import "UICollectionView+AB.h"

@interface ABCollectionViewController ()
@property (nonatomic) BOOL beganUpdates;
@property (nonatomic, strong) NSMutableArray *insertIndexPaths;
@property (nonatomic, strong) NSMutableArray *removeIndexPaths;
@property (nonatomic, strong) NSMutableArray *fromIndexPaths;
@property (nonatomic, strong) NSMutableArray *toIndexPaths;
@property (nonatomic, strong) NSMutableArray *reloadIndexPaths;
@end

@implementation ABCollectionViewController

-(void)setUpResultsControllerWithEntity:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                                  limit:(NSInteger)limit
                     andSortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    if (limit > 0) [request setFetchLimit:limit];
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[ABAppDelegate mainContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)initChangeArrays
{
    self.insertIndexPaths = [NSMutableArray array];
    self.removeIndexPaths = [NSMutableArray array];
    self.fromIndexPaths   = [NSMutableArray array];
    self.toIndexPaths     = [NSMutableArray array];
    self.reloadIndexPaths = [NSMutableArray array];
}

-(void)changeRequestEntity:(NSString *)entity
{
    self.fetchedResultsController.fetchRequest.entity =
    [NSEntityDescription entityForName:entity inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    [self animateUpdates];
}

-(void)changeRequestPredicate:(NSPredicate *)predicate
{
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    [self animateUpdates];
}

-(void)animateUpdates
{
    NSArray *oldObjects = self.fetchedResultsController.fetchedObjects;
    [self.fetchedResultsController performFetch:nil];
    NSArray *newObjects = self.fetchedResultsController.fetchedObjects;
    [self.collectionView reorderOldArray:oldObjects toNewArray:newObjects];
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
            [self.collectionView reloadData];
        }
    }
    [self.contentChangedDelegate contentDidChange:[self numberOfObjects]];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
        [self initChangeArrays];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
        }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                if (newIndexPath) [self.insertIndexPaths addObject: newIndexPath];
                break;
                
            case NSFetchedResultsChangeDelete:
                if (indexPath) [self.removeIndexPaths addObject:indexPath];
                break;
                
            case NSFetchedResultsChangeUpdate:
                if (newIndexPath) [self.reloadIndexPaths addObject:newIndexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                if (indexPath && newIndexPath) {
                    [self.fromIndexPaths addObject:indexPath];
                    [self.toIndexPaths addObject:newIndexPath];
                }
                break;
        }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self.contentChangedDelegate respondsToSelector:@selector(contentDidChange:)]) [self.contentChangedDelegate contentDidChange:self.fetchedResultsController.fetchedObjects.count];
    if (self.beganUpdates) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:self.reloadIndexPaths];
            [self.collectionView insertItemsAtIndexPaths:self.insertIndexPaths];
            [self.collectionView deleteItemsAtIndexPaths:self.removeIndexPaths];
            if (!self.insertIndexPaths.count && !self.removeIndexPaths.count) {
                [self.fromIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *fromIndexPath, NSUInteger index, BOOL *stop){
                    NSIndexPath *toIndexPath = self.toIndexPaths[index];
                    [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                }];
            }
        }completion:nil];
    }
}

-(NSUInteger)numberOfObjects
{
    return self.fetchedResultsController.fetchedObjects.count;
}

@end
