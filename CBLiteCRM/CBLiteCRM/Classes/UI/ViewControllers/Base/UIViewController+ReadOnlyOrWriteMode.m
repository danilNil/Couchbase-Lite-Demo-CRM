//
//  UIViewController+ReadOnlyOrWriteMode.m
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UIViewController+ReadOnlyOrWriteMode.h"

@implementation UIViewController (ReadOnlyOrWriteMode)
@dynamic deleteButton, textFields, buttons;

- (void)setEditMode:(BOOL)editMode{
    [self changeRightButtonTitleForMode:editMode];
    self.deleteButton.hidden = !editMode;
    for (UITextField* tf in self.textFields) {
        tf.enabled = editMode;
    }
    for (UIButton* bt in self.buttons) {
        bt.enabled = NO;
    }
}

- (void)changeRightButtonTitleForMode:(BOOL)editMode{
    if(editMode)
        self.navigationItem.rightBarButtonItem.title = kSaveTitle;
    else
        self.navigationItem.rightBarButtonItem.title = kEditTitle;
}

@end
