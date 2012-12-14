//
//  ABDispatch.m
//  ABFramework
//
//  Created by Andrew Barba on 12/10/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABDispatch.h"

@implementation ABDispatch

+(void)dispatchMainQueue:(DoneHandler)block
{
    dispatch_async(dispatch_get_main_queue(),block);
}

+(void)dispatchBackgroundQueue:(DoneHandler)block
{
    dispatch_queue_t queue = dispatch_queue_create("com.abarba.dispatchQueue", NULL);
    dispatch_async(queue,block);
}

+(void)dispatchAfter:(CGFloat)seconds mainQueue:(DoneHandler)block
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

+(void)dispatchAfter:(CGFloat)seconds backgroundQueue:(DoneHandler)block
{
    dispatch_queue_t queue = dispatch_queue_create("com.abarba.dispatchQueue", NULL);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, queue, block);
}
@end
