
//
//  TextFieldView.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/25/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "TextFieldView.h"
#import "UIView+IsA.h"

@interface TextFieldView ()

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIButton    *actionButton;
@property (nonatomic, weak) UIImageView *background; // TODO: to be removed

@end

@implementation TextFieldView

-(void)awakeFromNib {
    for (UIView *view in [self subviews])
    {
        if ([view isUITextField]) {
            self.textField = (UITextField*)view;
        }
        else
        if ([view isUIButton]) {
            self.actionButton = (UIButton*)view;
        }
        else
        if ([view isUIImageView]) {
            self.background = (UIImageView*)view;
        }
    }
    self.editMode = self.textField.enabled;
    NSAssert(self.textField, @"textField should not be nil");
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    [self.textField becomeFirstResponder];
//}

- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    
    if([self hasActionButton]) {
        self.textField.hidden    =!editMode;
        self.actionButton.hidden = editMode;
        
        [self.actionButton setTitle:self.textField.text
                           forState:UIControlStateNormal];
    }

    self.textField.enabled       = editMode;
//    self.textField.textColor     = [self textFieldColor];
//    self.textField.rightViewMode = [self textFieldRightViewMode];

    
    if (editMode)
        [self.background setImage:[UIImage imageNamed:@"input_field.png"]];
    else
        [self.background setImage:[UIImage imageNamed:@"input_field_disabled.png"]];
}

//- (UIColor*) textFieldColor
//{
//    if (!self.editMode && self.actionField)
//        return kActionTextColor;
//    
//    return kTextColor;
//}

//- (UITextFieldViewMode)textFieldRightViewMode
//{
//    return (self.editMode) ? UITextFieldViewModeNever : UITextFieldViewModeAlways;
//}

- (BOOL) hasActionButton {
    return self.actionButton != nil;
}

@end
