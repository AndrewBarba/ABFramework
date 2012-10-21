//
//  ABAlertView.m
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/19/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABAlertView.h"

@interface ABAlertView()
@property (nonatomic, strong) IntegerCompletionHandler selectionHandler;
@end

@implementation ABAlertView

+(void)alertWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
     selectionHandler:(IntegerCompletionHandler)selectionHandler
{
    ABAlertView *alertView = [[ABAlertView alloc] initWithTitle:title
                                                        message:message
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                               selectionHandler:selectionHandler];
    [alertView show];
}

-(ABAlertView *)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             selectionHandler:(IntegerCompletionHandler)selectionHandler
{
    self = [super init];
    if (self) {
        [self setTitle:title];
        [self setMessage:message];

        for (NSString *buttonTitle in otherButtonTitles) {
            [self addButtonWithTitle:buttonTitle];
        }
        
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            [self setCancelButtonIndex:self.numberOfButtons-1];
        }
        
        _selectionHandler = selectionHandler;
    }
    return self;
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    if (self.selectionHandler) self.selectionHandler(buttonIndex);
}

@end
