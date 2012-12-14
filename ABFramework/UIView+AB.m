//
//  UIView+AB.m
//  ABFramework
//
//  Created by Andrew Barba on 11/15/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "UIView+AB.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (AB)
-(void)setHidden:(BOOL)hidden withAnimation:(CGFloat)time
{
    if (hidden) {
        [UIView animateWithDuration:time
                         animations:^{
                             self.layer.opacity = 0;
                         }completion:^(BOOL done){
                             if (done) [self setHidden:hidden];
                         }];
    } else {
        [UIView animateWithDuration:time animations:^{
            [self setHidden:hidden];
            self.layer.opacity = 1;
        }];
    }
}

-(void)moveToPoint:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

-(void)moveToPoint:(CGPoint)point withAnimation :(CGFloat)time
{
    [UIView animateWithDuration:time animations:^{
        [self moveToPoint:point];
    }];
}
@end
