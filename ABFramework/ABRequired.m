//
//  ABRequired.m
//  ABFramework
//
//  Created by Andrew Barba on 11/9/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABRequired.h"

@implementation ABRequired
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

+(BOOL)isiPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+(void)alertTitle:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles: nil] show];
}

+ (UIStoryboard *)iphoneStoryboard
{
    return [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
}

+ (UIStoryboard *)ipadStoryboard
{
    return [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
}

+ (void)initViewController:(NSString *)identifier inNavigationController:(UINavigationController *)nav
{
    if ([ABRequired isiPad]) {
        UIViewController *vc = [[ABRequired ipadStoryboard] instantiateViewControllerWithIdentifier:identifier];
        [nav pushViewController:vc animated:NO];
    } else {
        UIViewController *vc = [[ABRequired iphoneStoryboard] instantiateViewControllerWithIdentifier:identifier];
        [nav pushViewController:vc animated:NO];
    }
}

+(BOOL)isTallScreen
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return [ABRequired isiPhone] && screenSize.height > 480.0f;
}

@end
