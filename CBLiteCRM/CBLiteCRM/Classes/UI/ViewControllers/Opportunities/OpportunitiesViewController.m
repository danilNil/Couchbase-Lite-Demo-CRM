//
//  OpportunitiesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "OpportunityDetailesViewController.h"

//Data
#import "DataStore.h"
#import "Opportunity.h"

@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"opportDetails" sender:tableView];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[OpportunityDetailesViewController class]]){
            OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)navc.topViewController;
            CBLQueryRow *row = [self.dataSource rowAtIndex:[self.tableView indexPathForSelectedRow].row];
            vc.currentOpport = [Opportunity modelForDocument: row.document];
        }
    }
}

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance] queryOpportunities] asLiveQuery];
}

@end
