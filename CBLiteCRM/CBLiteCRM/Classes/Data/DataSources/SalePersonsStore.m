//
//  SalePersonsStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "SalePersonsStore.h"

#import "SalesPerson.h"

@interface SalePersonsStore()
{
    CBLView* salesPersonsView;
    CBLView* approvedSalesPersonsView;
}

@end

@implementation SalePersonsStore

- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        NSString* savedUserName = [self loadUserId];
        if(savedUserName)
            self.userID = savedUserName;
    }
    return self;
}

-(void)registerCBLClass
{
    [self.database.modelFactory registerClass: [SalesPerson class] forDocumentType: kSalesPersonDocType];
}

-(void)createView
{
    salesPersonsView = [self.database viewNamed: @"salesPersonsByName"];
    [salesPersonsView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
            if (doc[@"email"])
                emit(doc[@"email"], doc[@"email"]);
        }
    }) version: @"1"];

    approvedSalesPersonsView = [self.database viewNamed:@"approvedSalesPersons"];
    [approvedSalesPersonsView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
            if (doc[@"approved"])
                emit(doc[@"approved"], doc[@"approved"]);
        }
    }) version: @"2"];
}

//TODO: need to refactor. for more clearly logic of login adn logout. we need to init this class with database after we already logged in so username and current user should be already created and provided fron outside

- (SalesPerson*) user {
    if(_user)
        return _user;
    if (![self userID])
        return nil;
    
    _user = [self createSalesPerson];
    
    if (!_user) {// seems this code is never called
        _user = [self profileWithUsername: [self userID]];
    }
    return _user;
}

- (SalesPerson*) createSalesPerson
{
    return  [[SalesPerson alloc] initInDatabase: self.database
                                     withUserId:[self userID]
                                        andName:[self userHumanName]];
}

- (SalesPerson*) profileWithUsername: (NSString*)username {// seems this code is never called
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [SalesPerson modelForDocument: doc];
}



- (void)storeUserId:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject: userID forKey: kCBLPrefKeyUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setUserID:(NSString *)userID {
    if (![userID isEqualToString: [self userID]]) {
        NSLog(@"Setting username to '%@'", userID);
        [self storeUserId:userID];
        SalesPerson* myProfile = [self profileWithUsername: [self userID]];
        if(!myProfile) {
            myProfile = [self createSalesPerson];
            
            NSLog(@"Created user profile %@", myProfile);
        }
    }
}

- (NSString *)loadUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey: kCBLPrefKeyUserID];
}

- (NSString*)userID{
    NSString *un = [self loadUserId];
    NSLog(@"current username: %@", un);
    return un;
}


- (CBLQuery*) allUsersQuery {
    return [salesPersonsView createQuery];
}

- (CBLQuery*) approvedUsersQuery
{
    CBLQuery* q = [approvedSalesPersonsView createQuery];
    q.keys = @[@YES];
    return q;
}

- (CBLQuery*) nonAdminNonApprovedUsersQuery:(NSString*)userEmail
{
    CBLQuery* q = [salesPersonsView createQuery];
    q.keys = @[userEmail];
    return q;
}

- (CBLQuery*) filteredQuery {
    return [salesPersonsView createQuery];
}

- (NSArray*) allOtherUsers {
    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in [self.allUsersQuery run:nil].allObjects) {
        SalesPerson* user = [SalesPerson modelForDocument: row.document];
        if (![user.user_id isEqualToString: [self userID]])
            [users addObject: user];
    }
    return users;
}


- (NSString *) userHumanName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCBLPrefKeyHumanName];
}

- (NSString *) userEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCBLPrefKeyEmail];
}

@end
