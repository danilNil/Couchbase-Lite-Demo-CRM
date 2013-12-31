//
//  UIViewController+ReadOnlyOrWriteMode.h
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "EditableViewController.h"
@class TextFieldView;

@protocol EditableDetailsProtocol

@property (strong, nonatomic) IBOutletCollection(TextFieldView) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;


- (void)changeRightButtonTitleForMode:(BOOL)editMode;
- (BOOL)isEditMode;
- (void)setEditMode:(BOOL)editMode;
- (void)editModeChanged:(BOOL)editMode;

@end

@interface EditableViewController(DetailsReadOnlyOrWriteMode)<EditableDetailsProtocol>

@end
