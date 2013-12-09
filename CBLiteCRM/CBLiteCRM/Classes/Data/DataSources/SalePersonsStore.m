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
    CBLView* _filteredPersonsView;
}

@end

@implementation SalePersonsStore
- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        NSString* savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"UserName"];
        if(savedUserName)
            self.username = savedUserName;

        [self.database.modelFactory registerClass: [SalesPerson class] forDocumentType: kSalesPersonDocType];
        _salesPersonsView = [self.database viewNamed: @"salesPersonsByName"];
        [_salesPersonsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
                if (doc[@"email"])
                    emit(doc[@"email"], doc[@"email"]);
            }
        }) version: @"1"];

        _filteredPersonsView = [self.database viewNamed: @"filteredSalesPerson"];

        [_filteredPersonsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString:kSalesPersonDocType]) {
                NSString* email = doc[@"email"];
                if (email)
                    emit(email, doc);
            }
        }) version: @"4"];
#if kFakeDataBase
        [self createFakeSalesPersons];
#endif


    }
    return self;
}


#if kFakeDataBase
- (void) createFakeSalesPersons {
    for (NSDictionary *dict in [self getFakeSalesPersonsDictionary]) {
        SalesPerson* profile = [self profileWithUsername: [dict objectForKey:kEmail]];
        if (!profile) {
            profile = [[SalesPerson alloc] initInDatabase:self.database
                                          withEmail: [dict objectForKey:kEmail]];
            profile.phoneNumber = [dict objectForKey:kPhone];
            profile.username = [dict objectForKey:kName];
            NSError *error;
            if (![profile save:&error])
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        }
    }
}

- (NSArray*)getFakeSalesPersonsDictionary {
    return @[[NSDictionary dictionaryWithObjectsAndKeys:
              kExampleUserName, kEmail,
              @"+8 321 2490", kPhone,
              @"Archibald", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"DaveMarkus@mail.com", kEmail,
              @"+3 634 2983", kPhone,
              @"Dave", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"MichaelMarkulli@mail.com", kEmail,
              @"+4 623 1234", kPhone,
              @"Michael", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"EugeneVolnov@mail.com", kEmail,
              @"+2 132 9162", kPhone,
              @"Eugene", kName, nil]];
}

#endif

- (SalesPerson*) user {
    if (!self.username)
        return nil;
    SalesPerson* user = [self profileWithUsername: self.username];
    if (!user) {
        user = [[SalesPerson alloc] initInDatabase: self.database
                                   withEmail: self.username];
    }
    return user;
}


- (SalesPerson*) profileWithUsername: (NSString*)username {
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [SalesPerson modelForDocument: doc];
}



- (void) setUsername:(NSString *)username {
    if (![username isEqualToString: self.username]) {
        NSLog(@"Setting username to '%@'", username);
        _username = username;
        [[NSUserDefaults standardUserDefaults] setObject: username forKey: @"UserName"];
        
        SalesPerson* myProfile = [self profileWithUsername: self.username];
        if (!myProfile) {
            myProfile = [[SalesPerson  alloc] initInDatabase: self.database
                                            withEmail: self.username];
            NSLog(@"Created user profile %@", myProfile);
        }
    }
}



- (CBLQuery*) allUsersQuery {
    return [_salesPersonsView createQuery];
}

- (CBLQuery*) filteredQuery {
    return [_filteredPersonsView createQuery];
}

- (NSArray*) allOtherUsers {
    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in [self.allUsersQuery rows:nil].allObjects) {
        SalesPerson* user = [SalesPerson modelForDocument: row.document];
        if (![user.username isEqualToString: self.username])
            [users addObject: user];
    }
    return users;
}


@end
