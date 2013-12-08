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
#import "OpportunitiesStore.h"
#import "Opportunity.h"
#import "OpportunitiesStore.h"
#import "Customer.h"

@interface OpportunitiesViewController ()
<
CBLUITableDelegate
>
@property(nonatomic, strong) Opportunity* selectedCellData;

@end

@implementation OpportunitiesViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedCellData = [self opportForPath:indexPath];
    [self performSegueWithIdentifier:@"opportDetails" sender:tableView];
}

- (Opportunity*)opportForPath:(NSIndexPath*)indexPath{
    Opportunity* opp;
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    opp = [Opportunity modelForDocument: row.document];
    return opp;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && [sender isKindOfClass:[UITableView class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)navc.topViewController;
        vc.currentOpport = self.selectedCellData;
    }
}

- (void) updateQuery
{
    if (self.filteredCustomer) {
        self.dataSource.query = [[[DataStore sharedInstance].opportunitiesStore queryOpportunitiesForCustomer:self.filteredCustomer] asLiveQuery];
    } else {
        self.dataSource.query = [[[DataStore sharedInstance].opportunitiesStore queryOpportunities] asLiveQuery];
    }
}

-(UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:@"OpportunityCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OpportunityCell"];

    Opportunity *opportunity = [Opportunity modelForDocument:[source.rows[indexPath.row] document]];
    cell.textLabel.text = [opportunity getValueOfProperty:@"title"];
    cell.detailTextLabel.text = opportunity.customer.companyName;
    return cell;
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSError *err;
    CBLQuery *query = [[DataStore sharedInstance].opportunitiesStore filteredQuery];
    CBLQueryEnumerator *enumer = [query rows:&err];
    NSLog(@"%u", [[query rows:&err] count]);

    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow* row = [enumer rowAtIndex:i];
        Opportunity* opp = [Opportunity modelForDocument:row.document];
        if ([opp.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:opp.title];
    }
    query.keys = matches;
    NSLog(@"%u", [[query rows:&err] count]);
    self.filteredDataSource.query = [query asLiveQuery];
}

@end
