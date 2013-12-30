//
//  ContactsByCustomerViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsByCustomerViewController.h"
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"

@interface ContactsByCustomerViewController ()

@end

@implementation ContactsByCustomerViewController

- (void)updateQuery
{
    [super updateQuery];
    self.dataSource.query = [[(ContactsStore*)self.store queryContactsForCustomer:self.customer] asLiveQuery];
}

@end
