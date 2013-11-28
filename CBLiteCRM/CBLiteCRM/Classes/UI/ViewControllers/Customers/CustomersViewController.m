//
//  CustomersViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"
#import "DataStore.h"
#import "Customer.h"

@interface CustomersViewController ()
{
    CBLUITableSource* dataSource;
}
@end

@implementation CustomersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [CBLUITableSource new];
    dataSource.tableView = self.tableView;
    self.tableView.dataSource = dataSource;
    [self updateQuery];
}

- (void) updateQuery {
    dataSource.query = [[[DataStore sharedInstance] allCustomersQuery] asLiveQuery];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CustomerDetailsViewController class]]){
        CustomerDetailsViewController* vc = segue.destinationViewController;
        CBLQueryRow *row = [dataSource rowAtIndex:[self.tableView indexPathForSelectedRow].row];
        Customer *customer = [Customer modelForDocument: row.document];
        vc.currentCustomer = customer;
    }
}

@end
