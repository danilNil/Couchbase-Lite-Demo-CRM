//
//  SalesPersonOptionsViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//
#import "LogoutProtocol.h"
#import "EditableViewController.h"
#import "EditableViewController+DetailsReadOnlyOrWriteMode.h"

@class SalesPerson;
@interface SalesPersonOptionsViewController : EditableViewController <LogoutProtocol, EditableDetailsProtocol>

@property (nonatomic, unsafe_unretained) SalesPerson *salesPerson;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;

@end
