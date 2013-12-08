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
    self.filteredDataSource.labelProperty = @"companyName";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellData = [self customerForPath:indexPath];
    if(self.chooser && self.onSelectCustomer)
        [self didChooseCustomer:self.selectedCellData];
    else
        [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (Customer*)customerForPath:(NSIndexPath*)indexPath{
    Customer* csmr;
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    csmr = [Customer modelForDocument: row.document];
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
    NSError *err;
    CBLQuery *query = [[DataStore sharedInstance].customersStore filteredQuery];
    CBLQueryEnumerator *enumer = [query rows:&err];
    NSLog(@"%u", [[query rows:&err] count]);
    
    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow* row = [enumer rowAtIndex:i];
        Customer* cust = [Customer modelForDocument:row.document];
        if ([cust.companyName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:cust.companyName];
    }
    query.keys = matches;
    NSLog(@"%u", [[query rows:&err] count]);

    self.filteredDataSource.query = [query asLiveQuery];

}

@end
