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
    if ([segue.identifier isEqualToString:@"opportDetails"] && sender != self.tableView){
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.enabledForEditing = YES;
        vc.preselectedCustomer = self.customer;
    } else if ([segue.identifier isEqualToString:@"opportDetails"] && sender == self.tableView) {
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.enabledForEditing = NO;
        vc.preselectedCustomer = self.customer;
    }
}

@end
