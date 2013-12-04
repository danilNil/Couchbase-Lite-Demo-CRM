//
//  AppDelegate.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "AppDelegate.h"
#import "DataStore.h"

@interface AppDelegate()
    @property (readonly) DataStore* dataStore;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // create a shared instance of CBLManager
    CBLManager *manager = [CBLManager sharedInstance];
    
    // create a database
    NSError *error;
    self.database = [manager databaseNamed: @"crm-database" error: &error];
    _dataStore = [[DataStore alloc] initWithDatabase: _database];
    if (error) {
        NSLog(@"data base creation error: %@", error);
    }
    return YES;
}
@end
