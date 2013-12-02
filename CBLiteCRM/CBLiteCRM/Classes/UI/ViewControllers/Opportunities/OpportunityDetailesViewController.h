//
//  OpportunityDetailesViewController.h
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "TextFieldsViewController.h"

@class Opportunity;
@interface OpportunityDetailesViewController : TextFieldsViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(nonatomic, strong) Opportunity* currentOpport;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *stageField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *revenueField;
@property (weak, nonatomic) IBOutlet UITextField *winField;
@property (weak, nonatomic) IBOutlet UITextField *customerField;
- (IBAction)back:(id)sender;
- (IBAction)saveItem:(id)sender;
- (IBAction)deleteItem:(id)sender;
- (IBAction)customerDetails:(id)sender;
@end
