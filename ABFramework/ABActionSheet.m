//
//  ABActionSheet.m
//  ABFrameworkTest
//
//  Created by Andrew Barba on 10/19/12.
//  Copyright (c) 2012 Andrew Barba. All rights reserved.
//

#import "ABActionSheet.h"

@interface ABActionSheet()
@property (nonatomic, strong) IntegerHandler selectionHandler;
@end

@implementation ABActionSheet

+(void)showWithTitle:(NSString *)title
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
              inView:(UIView *)view
    selectionHandler:(IntegerHandler)selectionHandler
{
    ABActionSheet *sheet = [[ABActionSheet alloc] initWithTitle:title
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:otherButtonTitles
                                               selectionHandler:selectionHandler];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet showInView:view];
}

-(ABActionSheet *)initWithTitle:(NSString *)title
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
               selectionHandler:(IntegerHandler)selectionHandler
{
    self = [super init];
    if (self) {
        self.title = title;
        
        for (NSString *buttonTitle in otherButtonTitles) {
            [self addButtonWithTitle:buttonTitle];
        }
        
        if (destructiveButtonTitle) {
            [self addButtonWithTitle:destructiveButtonTitle];
            [self setDestructiveButtonIndex:self.numberOfButtons-1];
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
