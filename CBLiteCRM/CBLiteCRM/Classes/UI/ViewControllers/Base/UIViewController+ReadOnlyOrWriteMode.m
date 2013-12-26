//
//  UIViewController+ReadOnlyOrWriteMode.m
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UIViewController+ReadOnlyOrWriteMode.h"
#import "TextFieldView.h"

@implementation UIViewController (ReadOnlyOrWriteMode)
@dynamic deleteButton, textFields, buttons;

- (void)setEditMode:(BOOL)editMode
{
    [self changeRightButtonTitleForMode:editMode];
    self.deleteButton.hidden = !editMode;
    for (TextFieldView* view in self.textFields)
        view.editMode = editMode;
    for (UIButton* btn in self.buttons)
        btn.enabled = editMode;
    [self editModeChanged:editMode];
}

- (BOOL)isEditMode
{
    return self.navigationItem.rightBarButtonItem.title == kSaveTitle;
}

- (void)changeRightButtonTitleForMode:(BOOL)editMode
{
    if(editMode)
        self.navigationItem.rightBarButtonItem.title = kSaveTitle;
    else
        self.navigationItem.rightBarButtonItem.title = kEditTitle;
}

- (void)editModeChanged:(BOOL)editMode{}

@end
