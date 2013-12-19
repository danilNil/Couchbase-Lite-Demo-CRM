//
//  SalePersonsStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalePersonsStore.h"

#import "SalesPerson.h"

@interface SalePersonsStore()
{
    CBLView* _salesPersonsView;
}

@end

@implementation SalePersonsStore

- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        NSString* savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: kCBLPrefKeyUserID];
        if(savedUserName)
            self.userID = savedUserName;

        [self.database.modelFactory registerClass: [SalesPerson class] forDocumentType: kSalesPersonDocType];
        _salesPersonsView = [self.database viewNamed: @"salesPersonsByName"];
        [_salesPersonsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
                if (doc[@"email"])
                    emit(doc[@"email"], doc[@"email"]);
            }
        }) version: @"1"];
    }
    return self;
}

//TODO: need to refactor. for more clearly logic of login adn logout. we need to init this class with database after we already logged in so username and current user should be already created and provided fron outside

- (SalesPerson*) user {
    if(_user)
        return _user;
    if (![self userID])
        return nil;
    _user = [[SalesPerson alloc] initInDatabase: self.database
                                                 withUserName:[self userID] andMail:[self userID]];
    if (!_user) {
        _user = [self profileWithUsername: [self userID]];
    }
    return _user;
}


- (SalesPerson*) profileWithUsername: (NSString*)username {
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [SalesPerson modelForDocument: doc];
}



- (void) setUserID:(NSString *)userID {
    if (![userID isEqualToString: [self userID]]) {
        NSLog(@"Setting username to '%@'", userID);
        [[NSUserDefaults standardUserDefaults] setObject: userID forKey: kCBLPrefKeyUserID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SalesPerson* myProfile = [self profileWithUsername: [self userID]];
        if (!myProfile) {
            myProfile = [[SalesPerson  alloc] initInDatabase: self.database
                                            withUserName:[self userID] andMail:[self userID]];
            NSLog(@"Created user profile %@", myProfile);
        }
    }
}

- (NSString*)userID{
    NSString* un =[[NSUserDefaults standardUserDefaults] objectForKey: kCBLPrefKeyUserID];
    NSLog(@"current username: %@", un);
    return un;
}


- (CBLQuery*) allUsersQuery {
    return [_salesPersonsView createQuery];
}

- (CBLQuery*) filteredQuery {
    return [_salesPersonsView createQuery];
}

- (NSArray*) allOtherUsers {
    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in [self.allUsersQuery rows:nil].allObjects) {
        SalesPerson* user = [SalesPerson modelForDocument: row.document];
        if (![user.username isEqualToString: [self userID]])
            [users addObject: user];
    }
    return users;
}


@end
