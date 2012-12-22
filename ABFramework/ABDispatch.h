//
//  ABDispatch.h
//  ABFramework
//
//  Created by Andrew Barba on 12/10/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABRequired.h"
#import "ABRequired.h"

@interface ABDispatch : NSObject
// Objective-C style functions
+(void)dispatchMainQueue:(DoneHandler)block;
+(void)dispatchBackgroundQueue:(DoneHandler)block;
+(void)dispatchAfter:(CGFloat)seconds mainQueue:(DoneHandler)block;       // Time in seconds
+(void)dispatchAfter:(CGFloat)seconds backgroundQueue:(DoneHandler)block; // Time in seconds

// C style functions
void ABDispatchMain(DoneHandler block);
void ABDispatchBackground(DoneHandler block);
void ABDispatchMainDelay(DoneHandler block, float after);       // Time in seconds
void ABDispatchBackgroundDelay(DoneHandler block, float after); // Time in seconds
@end
