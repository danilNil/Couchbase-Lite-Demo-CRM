//
//  SalesPersonCell.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPersonCell.h"
#import "SalesPerson.h"

NSString *kSalesPersonCell = @"SalesPersonCell";

@implementation SalesPersonCell

- (IBAction)checkmarkTapped:(id)sender
{
    self.checked = !self.checkmark.selected;
}

- (void)setChecked:(BOOL)checked
{
    self.salesPerson.approved = checked;

    NSError *err;
    if ([self.salesPerson save:&err]) {
        _checked = checked;
        if (checked == YES)
            [self.checkmark setSelected:YES];
        else
            [self.checkmark setSelected:NO];
    } else {
        self.salesPerson.approved = _checked;
    }
}

- (void)setSalesPerson:(SalesPerson *)salesPerson
{
    _salesPerson = salesPerson;

    self.name.text  = salesPerson.username;
    self.email.text = salesPerson.email;
    self.checked    = salesPerson.approved;
}

@end
