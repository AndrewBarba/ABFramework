//
//  ABAlertView.h
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/19/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABRequired.h"

@interface ABAlertView : UIAlertView
+(void)alertWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
     selectionHandler:(IntegerHandler)selectionHandler;
@end
