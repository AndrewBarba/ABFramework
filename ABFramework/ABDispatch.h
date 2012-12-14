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
+(void)dispatchMainQueue:(DoneHandler)block;
+(void)dispatchBackgroundQueue:(DoneHandler)block;
+(void)dispatchAfter:(CGFloat)seconds mainQueue:(DoneHandler)block;
+(void)dispatchAfter:(CGFloat)seconds backgroundQueue:(DoneHandler)block;
@end
