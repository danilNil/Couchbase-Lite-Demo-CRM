//
//  CustomersViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"

//Data
#import "DataStore.h"
#import "CustomersStore.h"
#import "Customer.h"

@interface CustomersViewController ()
<
CBLUITableDelegate
>
@property(nonatomic, strong) Customer* selectedCellData;

@end

@implementation CustomersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateUIForState:self.chooser];
}

- (void)updateUIForState:(BOOL)chooser{
    if(chooser)
        self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance].customersStore allCustomersQuery] asLiveQuery];
}

- (void)didChooseCustomer:(Customer*)cust{
    self.onSelectCustomer(cust);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomerCell"];

    Customer *customer = self.filteredSource[indexPath.row];
    cell.textLabel.text = customer.companyName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellData = [self customerForPath:indexPath];
    if(self.chooser && self.onSelectCustomer){
        [self didChooseCustomer:self.selectedCellData];
    }else
        [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (Customer*)customerForPath:(NSIndexPath*)indexPath{
    Customer* csmr;
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    if (self.filteredSource.count == 0){
        csmr = [Customer modelForDocument: row.document];
    } else {
        csmr = self.filteredSource[indexPath.row];
    }
    return csmr;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && sender == self){
        CustomerDetailsViewController* vc = (CustomerDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentCustomer = self.selectedCellData;
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredSource removeAllObjects];
    for (CBLQueryRow* row in self.dataSource.rows) {
        Customer *customer = [Customer modelForDocument:row.document];
        if ([customer.companyName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [self.filteredSource addObject:customer];
    }
}

@end
