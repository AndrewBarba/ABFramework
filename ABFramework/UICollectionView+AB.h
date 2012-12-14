//
//  UICollectionView+AB.h
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABRequired.h"

@interface UICollectionView (AB)
-(void)reorderOldArray:(NSArray *)oldObjects toNewArray:(NSArray *)newArray;
@end
