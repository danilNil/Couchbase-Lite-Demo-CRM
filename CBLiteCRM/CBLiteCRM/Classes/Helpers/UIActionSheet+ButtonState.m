//
//  UIActionSheet+ButtonState.m
//  ProfileCode
//
//  Created by Danil on 9/16/13.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import "UIActionSheet+ButtonState.h"

@implementation UIActionSheet (ButtonState)
- (void)setButton:(NSInteger)buttonIndex toState:(BOOL)enabled {
    for (UIView* view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            if (buttonIndex == 0) {
                if ([view respondsToSelector:@selector(setEnabled:)])
                {
                    UIButton* button = (UIButton*)view;
                    button.enabled = enabled;
                }
            }
            buttonIndex--;
        }
    }
}
@end
