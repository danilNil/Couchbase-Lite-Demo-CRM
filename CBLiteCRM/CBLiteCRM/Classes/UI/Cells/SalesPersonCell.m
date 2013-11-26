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

@interface SalesPersonCell ()

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *checkmark;

@end

@implementation SalesPersonCell
@synthesize name, checkmark, checked, salesPerson;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {}
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)checkmarkTapped:(id)sender {
    if ([checkmark.titleLabel.text isEqualToString:@"X"])
        self.checked = YES;
    else
        self.checked = NO;
}

- (void)setChecked:(BOOL)_checked {
    NSError *err;
    self.salesPerson.approved = _checked;
    if ([self.salesPerson save:&err]) {
        checked = _checked;

    if (_checked == YES)
        [checkmark setTitle:@"√" forState:UIControlStateNormal];
    else
        [checkmark setTitle:@"X" forState:UIControlStateNormal];
    } else {
        self.salesPerson.approved = checked;
    }
}

- (void)setSalesPerson:(SalesPerson *)_salesPerson
{
    salesPerson = _salesPerson;
    name.text = salesPerson.email;
    self.checked = salesPerson.approved;
}

@end
