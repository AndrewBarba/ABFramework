//
//  NSArray+AB.h
//  ABFramework
//
//  Created by Andrew Barba on 11/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequired.h"

@interface NSArray (AB)
-(void)map:(ObjectHandler)visit;
@end
