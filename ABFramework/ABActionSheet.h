//
//  ABActionSheet.h
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/19/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AB.h"

@interface ABActionSheet : UIActionSheet
+(void)showWithTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
   otherButtonTitles:(NSArray *)otherButtonTitles
              inView:(UIView *)view
    selectionHandler:(IntegerCompletionHandler)selectionHandler;
@end
