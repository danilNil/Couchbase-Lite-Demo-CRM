//
//  AppDelegate.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "AppDelegate.h"
#import "DataStore.h"
#import "CBLSyncManager.h"

#import "SalesPerson.h"

#define kSyncUrl @"http://sync.couchbasecloud.com:4984/fb_sg1"
#define kFBAppId @"220375198143968"
#define kBAseBlueColor

@interface AppDelegate()
    @property (readonly) DataStore* dataStore;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];
    // create a shared instance of CBLManager
    CBLManager *manager = [CBLManager sharedInstance];
    
    // create a database
    NSError *error;
    self.database = [manager databaseNamed: @"fb_sg" error: &error];
    if (error) {
        NSLog(@"error getting database %@",error);
        exit(-1);
    }
    _dataStore = [[DataStore alloc] initWithDatabase: _database];
    
    [self setupCBLSync];
    if (error) {
        NSLog(@"data base creation error: %@", error);
    }
    return YES;
}

- (void)setupAppearance{
    [[UINavigationBar appearance] setBarTintColor:kBaseBlueColor];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

#pragma mark - Sync

- (void) setupCBLSync {
    _cblSync = [[CBLSyncManager alloc] initSyncForDatabase:_database withURL:[NSURL URLWithString:kSyncUrl]];
    
    // Tell the Sync Manager to use Facebook for login.
    _cblSync.authenticator = [[CBLFacebookAuthenticator alloc] initWithAppID:kFBAppId];
    
    if (_cblSync.userID) {
        //        we are logged in, go ahead and sync
        [_cblSync start];
    } else {
        // Application callback to create the user profile.
        // this will be triggered after we call [_cblSync start]
        [_cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData,  NSError **outError) {
            // This is a first run, setup the profile but don't save it yet.

            SalesPerson *myProfile = [[SalesPerson alloc] initInDatabase:self.database withEmail:userData[@"name"] andUserID:userID];
//            NSLog(@"my profile doc properties: %@", myProfile.document.properties);
            // Sync doesn't start until after this block completes, so
            // all this data will be tagged.
//            if (!outError) {
                [myProfile save:outError];
                NSLog(@"my profile doc properties: %@", myProfile.document.properties);
//            }
        }];
    }
}

- (void)loginAndSync: (void (^)())complete {
    if (_cblSync.userID) {
        complete();
    } else {
        [_cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData, NSError **outError) {
            complete();
        }];
        [_cblSync start];
    }
}
@end
