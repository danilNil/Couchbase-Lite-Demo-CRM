//
//  EnableForEditingViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/31/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "EditableViewController.h"

@implementation EditableViewController

- (void)setEnabledForEditing:(BOOL)enableForEditing
{
    _enabledForEditing = enableForEditing;
    [self setRightButtonEnabled:enableForEditing];
}

- (void)setRightButtonEnabled:(BOOL)enabled{
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

@end
