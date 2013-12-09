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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [Opportunity class];
    self.searchableProperty = @"title";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCellData = [self opportForPath:indexPath];
    [self performSegueWithIdentifier:@"opportDetails" sender:tableView];
}

- (Opportunity*)opportForPath:(NSIndexPath*)indexPath{
    Opportunity* opp;
    NSAssert(self.currentSource, @"currentSource should not be nil");
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
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
    self.store = [DataStore sharedInstance].opportunitiesStore;
    if (self.filteredCustomer)
        self.dataSource.query = [[(OpportunitiesStore*)self.store queryOpportunitiesForCustomer:self.filteredCustomer] asLiveQuery];
    else
        self.dataSource.query = [[(OpportunitiesStore*)self.store queryOpportunities] asLiveQuery];
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

@end
