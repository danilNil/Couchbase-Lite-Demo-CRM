
//
//  TextFieldView.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/25/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "TextFieldView.h"

@interface TextFieldView ()

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIImageView *background;

@end

@implementation TextFieldView

-(void)awakeFromNib {
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            self.textField = (UITextField*)view;
        } else if ([view isKindOfClass:[UIImageView class]]) {
            self.background = (UIImageView*)view;
        }
    }
    self.editMode = self.textField.enabled;
    NSAssert(self.textField, @"textField should not be nil");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.textField becomeFirstResponder];
}

- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    self.textField.enabled = editMode;
    if (editMode)
        [self.background setImage:[UIImage imageNamed:@"input_field.png"]];
    else
        [self.background setImage:[UIImage imageNamed:@"input_field_disabled.png"]];
}

@end
