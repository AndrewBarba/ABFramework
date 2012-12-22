//
//  NSMutableArray+AB.h
//  ABFramework
//
//  Created by Andrew Barba on 12/21/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+AB.h"

@interface NSMutableArray (AB)
-(void)filter:(ObjectHandlerTest)filter;
@end
