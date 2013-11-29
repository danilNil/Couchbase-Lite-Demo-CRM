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

@interface OpportunitiesViewController (){
    CBLUITableSource* dataSource;
    Opportunity* selectedOpport;
}

@end

@implementation OpportunitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [CBLUITableSource new];
    dataSource.tableView = self.tableView;
    self.tableView.dataSource = dataSource;
    [self updateQuery];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBLQueryRow *row = [dataSource rowAtIndex:indexPath.row];
    selectedOpport = [Opportunity modelForDocument: row.document];
    [self performSegueWithIdentifier:@"opportDetails" sender:tableView];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[OpportunityDetailesViewController class]]){
            OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)navc.topViewController;
            vc.currentOpport = selectedOpport;
        }
    }
}

- (void) updateQuery {
    dataSource.query = [[[DataStore sharedInstance] queryOpportunities] asLiveQuery];
}

@end
