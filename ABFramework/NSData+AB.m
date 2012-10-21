//
//  NSData+AB.m
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "NSData+AB.h"

@implementation NSData (AB)
-(id)JSON
{
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                             error:nil];
}
@end
