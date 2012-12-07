//
//  NSArray+AB.m
//  ABFramework
//
//  Created by Andrew Barba on 11/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "NSArray+AB.h"

@implementation NSArray (AB)
-(void)map:(ObjectHandler)visit
{
    for (id obj in self) {
        if (visit) visit(obj);
    }
}
@end
