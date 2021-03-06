//
//  NSDate+AB.m
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "NSDate+AB.h"

@implementation NSDate (AB)
-(NSString *)niceTime
{
    CGFloat diff = [self timeIntervalSinceNow];
    diff = fabs(diff);
    
    NSString *tense;
    
    if (diff < 60) {
        tense = @"second";
    } else if (diff < 60*60) {
        tense = @"minute";
        diff = floorf(diff/60);
    } else if (diff < 60*60*24) {
        tense = @"hour";
        diff = floorf(diff/60/60);
    } else if (diff < 60*60*24*7) {
        tense = @"day";
        diff = floorf(diff/60/60/24);
    } else if (diff < 60*60*24*7*4.33) {
        tense = @"week";
        diff = floorf(diff/60/60/24/7);
    } else if (diff < 60*60*24*7*4.33*12) {
        tense = @"month";
        diff = floorf(diff/60/60/24/7/4.33);
    } else if (diff < 60*60*24*7*4.33*12*10) {
        tense = @"year";
        diff = floorf(diff/60/60/24/7/4.33/10);
    }
    
    if (diff != 1) tense = [tense stringByAppendingString:@"s"];
    
    return [NSString stringWithFormat:@"%.0f %@ ago",diff,tense];
}

-(NSString *)niceTimeNew
{
    NSArray *times  = @[@60,      @60,      @24,    @7,    @4.3,   @10];
    NSArray *tenses = @[@"second",@"minute",@"hour",@"day",@"week",@"month",@"year"];
    
    __block CGFloat diff = fabs([self timeIntervalSinceNow]);
    __block NSString *tense;
    __block CGFloat acc = 1.0;
    [times enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop){
        acc *= [num floatValue];
        if (diff < acc) {
            if (index > 0) diff = floorf(diff/acc);
            tense = tenses[index];
            *stop = YES;
        }
    }];
    
    if (diff != 1) tense = [tense stringByAppendingString:@"s"];
    return [NSString stringWithFormat:@"%.0f %@ ago",diff,tense];
}
@end
