
#import "DataStore.h"
#import "SalesPerson.h"
#import "Contact.h"
#import "Customer.h"
#import "Opportunity.h"

#if kFakeDataBase

NSString *kName = @"name";
NSString *kEmail = @"email";
NSString *kPhone = @"phone";
NSString *kPosition = @"position";
NSString *kCompanyName = @"companyName";

#endif

@interface DataStore(){
    CBLView* _salesPersonsView;
    CBLView* _contactsView;
    CBLView* _customersView;
    CBLView* _opportView;
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
        [_database.modelFactory registerClass:[Opportunity class] forDocumentType: kOpportDocType];

        _salesPersonsView = [_database viewNamed: @"salesPersonsByName"];
        [_salesPersonsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kSalesPersonDocType]) {
                NSString* name = [SalesPerson emailFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];
        
        _contactsView = [_database viewNamed: @"contactsByName"];
        [_contactsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactDocType]) {
                NSString* name = [Contact emailFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];
        
        _opportView = [_database viewNamed: @"oppByName"];
        [_opportView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kOpportDocType]) {
                NSString* name = [Opportunity titleFromDocID: doc[@"_id"]];
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
        [self createFakeSalesPersons];
        [self createFakeContacts];
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
- (void) createFakeSalesPersons {
    for (NSDictionary *dict in [self getFakeSalesPersonsDictionary]) {
        SalesPerson* profile = [self profileWithUsername: [dict objectForKey:kEmail]];
        if (!profile) {
            profile = [SalesPerson createInDatabase: _database
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

- (void) createFakeContacts {
    for (NSDictionary *dict in [self getFakeContactsDictionary]) {
        Contact* contact = [self contactWithMail: [dict objectForKey:kEmail]];
        if (!contact) {
            contact = [Contact createInDatabase: _database
                                          withEmail: [dict objectForKey:kEmail]];
            contact.phoneNumber = [dict objectForKey:kPhone];
            contact.name = [dict objectForKey:kName];
            contact.position = [dict objectForKey:kPosition];
            NSError *error;
            if (![contact save:&error])
                NSLog(@"%@", error);
        }
    }
}

- (NSArray*)getFakeContactsDictionary {
    return @[[NSDictionary dictionaryWithObjectsAndKeys:
              kExampleUserName, kEmail,
              @"+8 321 2490", kPhone,
              @"Archibald", kName,
              @"Sales consultant", kPosition,
              @"Thomson Reuters", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Tovarish@mail.com", kEmail,
              @"+3 634 2983", kPhone,
              @"Dave", kName,
              @"Presales consultant", kPosition,
              @"Brittish Telecommunications", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Sestra@mail.com", kEmail,
              @"+4 623 1234", kPhone,
              @"Michael", kName,
              @"SOA", kPosition,
              @"Monitise", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Brat@mail.com", kEmail,
              @"+2 132 9162", kPhone,
              @"Eugene", kName,
              @"Lead developer", kPosition,
              @"Hewlett-Packard", kCompanyName, nil]];
}

- (void) createFakeCustomers {
    for (NSDictionary *dict in [self getFakeCustomersDictionary]) {
        Customer* customer = [self customerWithName: [dict objectForKey:kName]];
        if (!customer) {
            customer = [Customer createInDatabase: _database
                                       withCustomerName: [dict objectForKey:kName]];
            customer.email = [dict objectForKey:kEmail];
            customer.phone = [dict objectForKey:kPhone];
            NSError* error;
            if (![customer save:&error])
                NSLog(@"%@", error);
        }
    }
}

- (NSArray*)getFakeCustomersDictionary {
    return @[[NSDictionary dictionaryWithObjectsAndKeys:
              @"Acme@mail.com", kEmail,
              @"+3 456 8490", kPhone,
              @"Gerald", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Orange@mail.com", kEmail,
              @"+3 654 0983", kPhone,
              @"Pauloktus", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Montansa@mail.com", kEmail,
              @"+4 613 1234", kPhone,
              @"Franky", kName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"GreyButter@mail.com", kEmail,
              @"+1 111 9122", kPhone,
              @"Vito", kName, nil]];
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
                                         withEmail: self.username];
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
                                withEmail: self.username];
    }
    return user;
}


- (SalesPerson*) profileWithUsername: (NSString*)username {
    NSString* docID = [SalesPerson docIDForEmail: username];
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

- (Customer*) createCustomerWithNameOrReturnExist: (NSString*)name{
    Customer* cm = [self customerWithName: name];
    if(!cm)
        cm = [Customer createInDatabase:self.database withCustomerName:name];
    return cm;
}

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

- (CBLQuery*) queryCustomersByOpport:(Opportunity*)opp {
    CBLView* view = [self.database viewNamed: @"customersByOpport"];
    [view setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kCustomerDocType]) {
            NSString* name = [Customer usernameFromDocID: doc[@"_id"]];
            emit(name.lowercaseString, name);
        }
    }) reduceBlock: nil version: @"1"];
    
    CBLQuery* query = [view query];
    NSLog(@"!need to implement fetching for one-to-many relationship");
    //    NSString* myListId = opp.document.documentID;
    //    query.startKey = @[myListId, @{}];
    //    query.endKey = @[myListId];
    return query;
}

#pragma mark - CONTACTS:

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail{
    Contact* ct = [self contactWithMail:mail];
    if(!ct)
        ct = [Contact createInDatabase:self.database withEmail:mail];
    return ct;
}

- (Contact*) contactWithMail: (NSString*)mail{
    NSString* docID = [Contact docIDForEmail: mail];
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

- (CBLQuery*) queryContactsByOpport:(Opportunity*)opp {
    
    CBLView* view = [self.database viewNamed: @"contactsByOpport"];
    [view setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kContactDocType]) {
            NSString* name = [Contact emailFromDocID: doc[@"_id"]];
            NSString* opportList = doc[@"opportunities"];
            emit(@[opportList], name);
        }
    }) reduceBlock: nil version: @"1"];
    
    CBLQuery* query = [view query];
    NSLog(@"!need to implement fetching for many-to-many relationship");
//    NSString* myListId = opp.document.documentID;
//    query.startKey = @[myListId, @{}];
//    query.endKey = @[myListId];
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


- (CBLQuery*) queryOpportunities {
    CBLQuery* query = [_opportView query];
    query.descending = YES;
    return query;
}

-(Opportunity *)createOpportunityWithTitleOrReturnExist:(NSString *)title
{
    Opportunity* opp = [self opportunityWithTitle:title];
    if(!opp)
        opp = [Opportunity createInDatabase:self.database withTitle:title];
    return opp;
}

- (Opportunity*) opporunityWithTitle: (NSString*)title{
    NSString* docID = [Opportunity docIDForTitle:title];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument:doc];
}

@end
