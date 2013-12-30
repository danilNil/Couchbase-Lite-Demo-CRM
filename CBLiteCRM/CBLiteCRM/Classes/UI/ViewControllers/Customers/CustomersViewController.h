//
//  CustomersViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "FilteringViewController.h"
#import "UIViewController+TableViewReadOnlyOrWriteMode.h"

@class Opportunity, Customer;
@interface CustomersViewController : FilteringViewController <EditableTableViewControllers>
@property (nonatomic) BOOL chooser;
@property (nonatomic, copy) void (^onSelectCustomer)(Customer * customer);

@end
