//
//  ABTableViewController.h
//  ABFramework
//
//  Created by Andrew Barba on 10/20/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ABRequired.h"

@protocol TableViewContentChangedDelegate <NSObject>
-(void)tableViewController:(UITableViewController *)controller contentDidChange:(NSUInteger)numberOfItems;
@end

@interface ABTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id <TableViewContentChangedDelegate> contentChangedDelegate;

// Dynamic Methods
-(void)changeRequestEntity:(NSString *)entity;
-(void)changeRequestPredicate:(NSPredicate *)predicate;
-(void)animateUpdates;
-(NSUInteger)numberOfObjects;
- (void)performFetch;
-(void)setUpResultsControllerWithEntity:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                                  limit:(NSInteger)limit
                     andSortDescriptors:(NSArray *)sortDescriptors;
-(void)setUpResultsControllerWithEntity:(NSString *)entityName
                              predicate:(NSPredicate *)predicate
                                  limit:(NSInteger)limit
                     andSortDescriptors:(NSArray *)sortDescriptors
                 withSectionNameKeyPath:(NSString *)sectionKeyPath;
@end
