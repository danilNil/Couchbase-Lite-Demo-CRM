//
//  ContactsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactsViewController.h"
#import "DataStore.h"

@interface ContactsViewController (){
    CBLUITableSource* dataSource;
}
@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [CBLUITableSource new];
    dataSource.tableView = self.tableView;
    self.tableView.dataSource = dataSource;
    [self updateQuery];
}

- (void) updateQuery {
    dataSource.query = [[[DataStore sharedInstance] queryContacts] asLiveQuery];
}

@end
