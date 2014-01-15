//
//  SalesPersonCell.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
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

    NSError *error;
    if ([self.salesPerson save:&error]) {
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

    self.name.text  = salesPerson.name;
    self.checked    = salesPerson.approved;
}

@end
