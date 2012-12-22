//
//  NSMutableArray+AB.m
//  ABFramework
//
//  Created by Andrew Barba on 12/21/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "NSMutableArray+AB.h"

@implementation NSMutableArray (AB)
-(void)filter:(ObjectHandlerTest)filter
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        if (!filter(obj)) [self removeObjectAtIndex:index];
    }];
}

@end
