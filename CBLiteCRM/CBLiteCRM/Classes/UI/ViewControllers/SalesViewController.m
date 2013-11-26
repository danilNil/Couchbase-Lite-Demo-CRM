//
//  SalesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesViewController.h"
#import "DataStore.h"
#import "SalesPerson.h"
#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"

NSString *kSalesPersonHeaderCell = @"SalesPersonHeaderCell";
NSString *kPersonCell = @"PersonCell";

@interface SalesViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray *filteredSalesPersons;
@property (nonatomic, strong) NSArray *salesPersons;
@end

@implementation SalesViewController
@synthesize salesPersons, filteredSalesPersons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.salesPersons = [[DataStore sharedInstance] allOtherUsers];
    self.filteredSalesPersons = [NSMutableArray arrayWithCapacity:self.salesPersons.count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return self.filteredSalesPersons.count + 1;
    else
        return self.salesPersons.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSalesPersonHeaderCell];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSalesPersonHeaderCell];
    } else if (indexPath.row > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kPersonCell];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPersonCell];
        SalesPerson *salesPerson;
        if (tableView == self.searchDisplayController.searchResultsTableView)
            salesPerson = (self.filteredSalesPersons)[indexPath.row - 1];
        else
            salesPerson = (self.salesPersons)[indexPath.row - 1];
        cell.textLabel.text = salesPerson.email;
//        cell.textLabel.text = user.username;
//        cell.detailTextLabel.text = user.email;
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        [self performSegueWithIdentifier:@"SalesPersonOptions" sender:tableView];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    if(sender == self.searchDisplayController.searchResultsTableView) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        salesPersonOptionsViewController.salesPerson = filteredSalesPersons[indexPath.row - 1];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        salesPersonOptionsViewController.salesPerson = salesPersons[indexPath.row - 1];
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredSalesPersons removeAllObjects];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.email contains[c] %@", searchText];
    filteredSalesPersons = [NSMutableArray arrayWithArray:[salesPersons filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

@end
