//
//  NSString+AB.m
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "NSString+AB.h"
#import "NSData+AB.h"

@implementation NSString (AB)
-(id)JSON
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] JSON];
}

-(NSString *)URLEncode
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) self,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    return escapedString;
}

-(NSString *)strip
{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@""];
}

-(BOOL)isEmpty
{
    return [self isEqualToString:@""];
}

-(NSDate *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-3600*5];
    formater.dateFormat = format;
    return [formater dateFromString:self];
}
@end
