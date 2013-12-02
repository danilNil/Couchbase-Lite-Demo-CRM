//
//  ContactCell.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactCell.h"
#import "Contact.h"
#import "Customer.h"

NSString *kContactCellIdentifier = @"ContactCell";

@implementation ContactCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setContact:(Contact *)contact {
    _contact = contact;
    NSData *photoData = [[contact attachmentNamed:@"photo"] body];
    UIImage *photo = [UIImage imageWithData:photoData];
    [self.avatar setImage:photo];
    self.name.text = contact.email;
    self.company.text = contact.customer.companyName;
    self.position.text = contact.position;
}

@end
