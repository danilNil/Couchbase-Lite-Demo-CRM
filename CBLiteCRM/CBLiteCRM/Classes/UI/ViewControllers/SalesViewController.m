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

@interface SalesViewController ()
<
UISearchBarDelegate,
UISearchDisplayDelegate
>
{
    __weak SalesPerson *selectedUser;
}

@property (nonatomic, strong) NSArray *salesPersons;
@end

@implementation SalesViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.salesPersons count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SalesPersonHeaderCell"];
    } else if (indexPath.row > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
        SalesPerson *user = (self.salesPersons)[indexPath.row - 1];
        cell.textLabel.text = user.email;
//        cell.textLabel.text = user.username;
//        cell.detailTextLabel.text = user.email;
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedUser = self.salesPersons[indexPath.row - 1];
    return indexPath;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    salesPersonOptionsViewController.user = selectedUser;
}

#pragma mark - Search


@end
