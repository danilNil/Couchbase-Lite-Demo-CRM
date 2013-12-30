//
//  UIViewController+TableViewReadOnlyOrWriteMode.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//


@protocol EditableTableViewControllers

@property (nonatomic) BOOL enableForEditing;

@end

@interface UIViewController (TableViewReadOnlyOrWriteMode)<EditableTableViewControllers>

@end
