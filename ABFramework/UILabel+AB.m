//
//  UILabel+AB.m
//  ABFramework
//
//  Created by Andrew Barba on 11/14/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "UILabel+AB.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (AB)
-(void)setTextWithAnimation:(NSString *)text
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.layer.opacity = 0;
                     }
                     completion:^(BOOL done){
                         self.text = text;
                         [UIView animateWithDuration:0.1 animations:^{self.layer.opacity=1;}];
                     }];
}
@end
