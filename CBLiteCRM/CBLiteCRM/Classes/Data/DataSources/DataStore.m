
#import "DataStore.h"
#import "SalesPerson.h"
#import "Contact.h"
#import "Customer.h"
#import "Opportunity.h"

@interface DataStore(){
    CBLView* _salesPersonsView;
    CBLView* _contactsView;
    CBLView* _customersView;
}

@end

static DataStore* sInstance;

@implementation DataStore


- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super init];
    if (self) {
        NSAssert(!sInstance, @"Cannot create more than one DataStore");
        sInstance = self;
        _database = database;
        NSString* savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"UserName"];
        if(savedUserName)
            self.username = savedUserName;

        [_database.modelFactory registerClass: [SalesPerson class] forDocumentType: kSalesPersonDocType];
        [_database.modelFactory registerClass: [Contact class] forDocumentType: kContactDocType];
        [_database.modelFactory registerClass:[Customer class] forDocumentType: kCustomerDocType];

        _salesPersonsView = [_database viewNamed: @"salesPersonsByName"];
        [_salesPersonsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
                NSString* name = [SalesPerson usernameFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];
        
        _contactsView = [_database viewNamed: @"contactsByName"];
        [_contactsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactDocType]) {
                NSString* name = [Contact usernameFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];

        _customersView = [_database viewNamed:@"customersByName"];
        [_customersView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kCustomerDocType]) {
                NSString* name = [Customer usernameFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];

#if kFakeDataBase
        [self createFakeUsers];
        [self createFakeCustomers];
        [self createFakeOpportunities];
#endif

    }
    return self;
}


+ (DataStore*) sharedInstance {
    return sInstance;
}



#pragma mark - USERS:


#if kFakeDataBase
- (void) createFakeUsers {
    NSArray *array = @[kExampleUserName, @"DaveMarkus@mail.com", @"MichaelMarkulli@mail.com", @"EugeneVolnov@mail.com"];
    for (NSString *email in array) {
        SalesPerson* profile = [self profileWithUsername: email];
        if (!profile) {
            profile = [SalesPerson createInDatabase: _database
                                withUsername: email];
        }
    }
}

- (void) createFakeCustomers {
    NSArray *array = @[@"Acme", @"Orange", @"Montansa", @"GreyButter"];
    for (NSString *name in array) {
        Customer* customer = [self customerWithName: name];
        if (!customer) {
            customer = [Customer createInDatabase: _database
                                       withCustomerName: name];
        }
    }
}

#endif


- (void) setUsername:(NSString *)username {
    if (![username isEqualToString: self.username]) {
        NSLog(@"Setting username to '%@'", username);
        _username = username;
        [[NSUserDefaults standardUserDefaults] setObject: username forKey: @"UserName"];

        SalesPerson* myProfile = [self profileWithUsername: self.username];
        if (!myProfile) {
            myProfile = [SalesPerson createInDatabase: _database
                                         withUsername: self.username];
            NSLog(@"Created user profile %@", myProfile);
        }
    }
}


- (SalesPerson*) user {
    if (!self.username)
        return nil;
    SalesPerson* user = [self profileWithUsername: self.username];
    if (!user) {
        user = [SalesPerson createInDatabase: _database
                                withUsername: self.username];
    }
    return user;
}


- (SalesPerson*) profileWithUsername: (NSString*)username {
    NSString* docID = [SalesPerson docIDForUsername: username];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [SalesPerson modelForDocument: doc];
}

- (CBLQuery*) allUsersQuery {
    return [_salesPersonsView query];
}

- (NSArray*) allOtherUsers {
    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in self.allUsersQuery.rows.allObjects) {
        SalesPerson* user = [SalesPerson modelForDocument: row.document];
        if (![user.username isEqualToString: self.username])
            [users addObject: user];
    }
    return users;
}

#pragma mark - CUSTOMER:

- (Customer*) customerWithName: (NSString*)name {
    NSString* docID = [Customer docIDForUsername: name];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Customer modelForDocument: doc];
}

- (CBLQuery*) allCustomersQuery {
    return [_customersView query];
}

#pragma mark - CONTACTS:

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail{
    Contact* ct = [self contactWithMail:mail];
    if(!ct)
        ct = [Contact createInDatabase:self.database withUsername:mail];
    return ct;
}

- (Contact*) contactWithMail: (NSString*)mail{
    NSString* docID = [Contact docIDForUsername: mail];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Contact modelForDocument: doc];
}


- (CBLQuery*) queryContacts {
    CBLQuery* query = [_contactsView query];
    query.descending = YES;
    return query;
}

#pragma mark - OPPURTUNITIES:
#if kFakeDataBase
- (void) createFakeOpportunities {
    NSArray *array = @[@"OPP1", @"OPP2", @"OPP3", @"OPP4"];
    for (NSString *title in array) {
        Opportunity* profile = [self opportunityWithTitle:title];
        if (!profile) {
            profile = [Opportunity createInDatabase: _database
                                       withTitle: title];
        }
    }
}
#endif

- (Opportunity*) opportunityWithTitle: (NSString*)title {
    NSString* docID = [Opportunity docIDForTitle: title];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument: doc];
}



@end
