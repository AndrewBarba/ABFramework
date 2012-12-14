//
//  UIView+AB.h
//  ABFramework
//
//  Created by Andrew Barba on 11/15/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABRequired.h"

@interface UIView (AB)
-(void)setHidden:(BOOL)hidden withAnimation:(CGFloat)time;
-(void)moveToPoint:(CGPoint)point;
-(void)moveToPoint:(CGPoint)point withAnimation:(CGFloat)time;
@end
