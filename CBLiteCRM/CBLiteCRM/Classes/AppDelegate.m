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
#import "Constants.h"
#import "DeviceSoftware.h"
#import "TestFlight.h"

#define kSyncUrl @"http://sync.couchbasecloud.com:4984/cbl_crm_sg6"
#define kFBAppId @"220375198143968"

@interface AppDelegate()
@property (readonly) DataStore* dataStore;
@property (nonatomic) BOOL asAdmin;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupTestflight];
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

- (void)setupAppearance {
    if (isIOS7()) {
        [[UINavigationBar appearance] setBarTintColor:kBaseBlueColor];
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        [[UITextField appearance] setTintColor:[UIColor grayColor]];
        [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
        [[UIToolbar appearance] setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [[UINavigationBar appearance] setTintColor:kBaseBlueColor];
    }
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
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
            SalesPerson *myProfile = [[SalesPerson alloc] initInDatabase:self.database withUserData:userData andMail:userID];
            myProfile.isAdmin = self.asAdmin;
            [myProfile save:outError];
            NSLog(@"my profile doc properties: %@", myProfile.document.properties);
        }];
    }
}

- (void)loginAndSync: (void (^)())complete asAdmin:(BOOL)asAdmin{
    if (_cblSync.userID) {
        complete();
    } else {
//        TODO: removed that variable after CBLSyncManager refactoring
        self.asAdmin = asAdmin;
        [_cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData, NSError **outError) {
            complete();
        }];
        [_cblSync start];
    }
}

- (void)logout{
    [_cblSync logout];
}

#pragma -

- (void) setupTestflight
{
    [TestFlight takeOff:@"f13dc547-6cef-4b07-9864-6fd1cffa1b3f"];
}

@end
