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
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    self.selectedCellData = [Customer modelForDocument: row.document];

    if(self.chooser && self.onSelectCustomer){
        [self didChooseCustomer:[Customer modelForDocument: row.document]];
    }else
        [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CustomerDetailsViewController class]] && sender == self){
        CustomerDetailsViewController* vc = segue.destinationViewController;
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
