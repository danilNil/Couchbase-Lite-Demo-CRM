//
//  UIActionSheet+ButtonState.h
//  ProfileCode
//
//  Created by Danil on 9/16/13.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (ButtonState)
- (void)setButton:(NSInteger)buttonIndex toState:(BOOL)enbaled;
@end
