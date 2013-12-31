//
//  OpportunitiesByCustomerViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "OpportunitiesByCustomerViewController.h"
#import "OpportunityDetailesViewController.h"
#import "DataStore.h"
#import "OpportunitiesStore.h"

@interface OpportunitiesByCustomerViewController ()

@end

@implementation OpportunitiesByCustomerViewController

- (void)updateQuery
{
    [super updateQuery];
    self.dataSource.query = [[(OpportunitiesStore*)self.store queryOpportunitiesForCustomer:self.customer] asLiveQuery];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"opportDetails"] && sender != self.tableView)
        [self setCustomer:self.customer to:(OpportunityDetailesViewController*)((UINavigationController*)segue.destinationViewController).topViewController];
}

- (void)setCustomer:(Customer*)customer to:(OpportunityDetailesViewController*)vc
{
    vc.preselectedCustomer = customer;
}

@end
