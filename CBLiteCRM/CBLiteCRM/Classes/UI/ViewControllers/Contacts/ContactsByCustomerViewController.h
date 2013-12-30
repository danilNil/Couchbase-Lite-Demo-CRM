//
//  ContactsByCustomerViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsViewController.h"

@class Customer;

@interface ContactsByCustomerViewController : ContactsViewController

@property (strong, nonatomic) Customer* customer;

@end
