//
//  UIViewController+ReadOnlyOrWriteMode.m
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UIViewController+DetailsReadOnlyOrWriteMode.h"
#import "TextFieldView.h"

@implementation UIViewController (DetailsReadOnlyOrWriteMode)
@dynamic deleteButton, textFields, buttons, enableForEditing;

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
    return [self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle];
}

- (void)changeRightButtonTitleForMode:(BOOL)editMode
{
    if(editMode)
        self.navigationItem.rightBarButtonItem.title = kSaveTitle;
    else
        self.navigationItem.rightBarButtonItem.title = kEditTitle;
}

-(void)setEnableForEditing:(BOOL)enableForEditing
{
    if (!enableForEditing) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)editModeChanged:(BOOL)editMode{}

@end
