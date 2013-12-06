//
//  OpportunitiesViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "FilteringViewController.h"

@class Customer;

@interface OpportunitiesViewController : FilteringViewController

@property (strong, nonatomic) Customer *filteredCustomer;

@end
