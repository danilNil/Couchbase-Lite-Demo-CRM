//
//  SalesPersonOptionsViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@class SalesPerson;
@interface SalesPersonOptionsViewController : UIViewController

@property (nonatomic, unsafe_unretained) SalesPerson *salesPerson;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;

@end
