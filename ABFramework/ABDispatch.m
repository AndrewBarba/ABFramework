//
//  ABDispatch.m
//  ABFramework
//
//  Created by Andrew Barba on 12/10/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABDispatch.h"

@implementation ABDispatch

void ABDispatchMain(DoneHandler block)
{
    dispatch_async(dispatch_get_main_queue(),block);
}

void ABDispatchMainDelay(DoneHandler block, float after)
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}

void ABDispatchBackground(DoneHandler block)
{
    dispatch_queue_t queue = dispatch_queue_create("com.abarba.dispatchQueue", NULL);
    dispatch_async(queue,block);
}

void ABDispatchBackgroundDelay(DoneHandler block, float after)
{
    dispatch_queue_t queue = dispatch_queue_create("com.abarba.dispatchQueue", NULL);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
    dispatch_after(popTime, queue, block);
}

+(void)dispatchMainQueue:(DoneHandler)block
{
    ABDispatchMain(block);
}

+(void)dispatchBackgroundQueue:(DoneHandler)block
{
    ABDispatchBackground(block);
}

+(void)dispatchAfter:(CGFloat)seconds mainQueue:(DoneHandler)block
{
    ABDispatchMainDelay(block,seconds);
}

+(void)dispatchAfter:(CGFloat)seconds backgroundQueue:(DoneHandler)block
{
    ABDispatchBackgroundDelay(block,seconds);
}

@end
