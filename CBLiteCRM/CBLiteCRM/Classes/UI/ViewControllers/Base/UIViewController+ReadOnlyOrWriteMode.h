//
//  UIViewController+ReadOnlyOrWriteMode.h
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditableViewControllers

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


- (void)setEditMode:(BOOL)editMode;
- (void)changeRightButtonTitleForMode:(BOOL)editMode;

@end

@interface UIViewController(ReadOnlyOrWriteMode)<EditableViewControllers>


@end
