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
#import "SalePersonsStore.h"
#import "Constants.h"
#import "TestFlight.h"

#define kSyncUrl @"http://sync.couchbasecloud.com:4984/cbl_crm_sg8"
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
    [[UINavigationBar appearance] setBarTintColor:kBaseBlueColor];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];

    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor lightGrayColor]];
    
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
            [self updateUserWithRole:self.asAdmin];
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
            [self updateUserWithRole:self.asAdmin];
            complete();
        }];
        [_cblSync start];
    }
}

- (void)updateUserWithRole:(BOOL)adminRole{
    NSError* err;
    SalesPerson *myProfile = [DataStore sharedInstance].salePersonsStore.user;
    myProfile.isAdmin = self.asAdmin;
    [myProfile save:&err];
    if(err){
        NSLog(@"error on updateUserWithRole: %@", err);
    }
    NSLog(@"my profile doc properties: %@", myProfile.document.properties);
}

//TODO: should be refactored with CBLSyncManager
- (void)logout{
    [DataStore sharedInstance].salePersonsStore.user = nil;
    [_cblSync logout];
}

#pragma -

- (void) setupTestflight
{
    [TestFlight takeOff:@"f13dc547-6cef-4b07-9864-6fd1cffa1b3f"];
}

@end
