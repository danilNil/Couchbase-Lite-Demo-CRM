//
//  TableViewController.m
//  SyncManagerController
//
//  Created by Danil on 18/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "TableViewController.h"
#import "DataSource.h"

@interface TableViewController ()
@property(nonatomic, strong) DataSource* ds;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    self.ds = [DataSource new];
    self.tableView.dataSource = self.ds;
    [super viewDidLoad];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
