//
//  SalesPersonOptionsViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//
#import "LogoutProtocol.h"
@class SalesPerson;
@interface SalesPersonOptionsViewController : UIViewController<LogoutProtocol>

@property (nonatomic, unsafe_unretained) SalesPerson *salesPerson;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@end
