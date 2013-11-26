//
//  SalesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesViewController.h"
#import "DataStore.h"
#import "User.h"
#import "SalesPersonOptionsViewController.h"

@interface SalesViewController ()

@property (nonatomic, unsafe_unretained) NSArray *sales_persons;
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

    self.sales_persons = [[DataStore sharedInstance] allOtherUsers];
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
    return [self.sales_persons count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SalesPersonHeaderCell"];
    } else if (indexPath.row > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
        User *user = (self.sales_persons)[indexPath.row - 1];
        cell.textLabel.text = user.email;
//        cell.textLabel.text = user.username;
//        cell.detailTextLabel.text = user.email;
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        SalesPersonOptionsViewController *salesPersonOptionsViewController = self.navigationController.viewControllers[2];
        salesPersonOptionsViewController.user = [[DataStore sharedInstance] allOtherUsers][indexPath.row - 1];
    }
}

@end
