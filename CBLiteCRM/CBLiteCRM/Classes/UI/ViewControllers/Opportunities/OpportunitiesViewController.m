//
//  OpportunitiesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "DataStore.h"

@interface OpportunitiesViewController (){
    CBLUITableSource* dataSource;
}

@end

@implementation OpportunitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [CBLUITableSource new];
    dataSource.tableView = self.tableView;
    self.tableView.dataSource = dataSource;
    [self updateQuery];
}

- (void) updateQuery {
    dataSource.query = [[[DataStore sharedInstance] queryOpportunities] asLiveQuery];
}

@end
