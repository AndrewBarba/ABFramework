//
//  AB.m
//  Template
//
//  Created by Andrew Barba on 10/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "AB.h"

@implementation AB
+(BOOL)isFirstRun
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_DB_KEY]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:REFRESH_DB_KEY];
        return YES;
    }
}

+(BOOL)isiPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+(void)alertTitle:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles: nil] show];
}

@end
