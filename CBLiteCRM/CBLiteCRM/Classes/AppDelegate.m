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
@property (nonatomic) DataStore* dataStore;
@property (nonatomic) BOOL asAdmin;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupTestflight];
    [self setupAppearance];
    [self setupDatabase];
    [self setupCBLSync];
    
    return YES;
}

- (void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:kBaseBlueColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor lightGrayColor]];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
}

#pragma mark - Sync

- (void)setupDatabase
{
    self.dataStore = [DataStore sharedInstance];
}

- (void) setupCBLSync {
    self.cblSync = [[CBLSyncManager alloc] initSyncForDatabase:self.dataStore.database withURL:[NSURL URLWithString:kSyncUrl]];
    
    // Tell the Sync Manager to use Facebook for login.
    self.cblSync.authenticator = [[CBLFacebookAuthenticator alloc] initWithAppID:kFBAppId];
}

- (void)loginAndSync: (void (^)())complete asAdmin:(BOOL)asAdmin
{
    // TODO: removed that variable after CBLSyncManager refactoring
    self.asAdmin = asAdmin;

    if (_cblSync.userID) {
        [self updateUserWithRole:self.asAdmin];
        complete();
    } else {
        [_cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData, NSError **outError) {
            [self updateUserWithRole:self.asAdmin];
            complete();
        }];
        [_cblSync start];
    }
}

- (void)updateUserWithRole:(BOOL)adminRole
{
    NSError* error;
    SalesPerson *myProfile = [DataStore sharedInstance].salePersonsStore.user;
    myProfile.isAdmin = adminRole;
    [myProfile save:&error];
    if(error){
        NSLog(@"error on updateUserWithRole: %@", error);
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
