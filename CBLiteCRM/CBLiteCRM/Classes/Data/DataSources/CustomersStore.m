//
//  CustomerStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "CustomersStore.h"
#import "Customer.h"
#import "Opportunity.h"

@interface CustomersStore(){
    CBLView* _customersView;
}
@end

@implementation CustomersStore

- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass:[Customer class] forDocumentType: kCustomerDocType];
        _customersView = [self.database viewNamed:@"customersByName"];
        [_customersView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kCustomerDocType]) {
                NSString* name = [Customer usernameFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];
#if kFakeDataBase
        [self createFakeCustomers];
#endif

    }
    return self;
}

- (void) createFakeCustomers {
    for (NSDictionary *dict in [self getFakeCustomersDictionary]) {
        Customer* customer = [self customerWithName: [dict objectForKey:kName]];
        if (!customer) {
            customer = [Customer createInDatabase: self.database
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
    return [_customersView createQuery];
}

- (CBLQuery*) queryCustomersByOpport:(Opportunity*)opp {
    CBLView* view = [self.database viewNamed: @"customersByOpport"];
    [view setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kCustomerDocType]) {
            NSString* name = [Customer usernameFromDocID: doc[@"_id"]];
            emit(name.lowercaseString, name);
        }
    }) reduceBlock: nil version: @"1"];
    
    CBLQuery* query = [view createQuery];
    NSLog(@"!need to implement fetching for one-to-many relationship");
    //    NSString* myListId = opp.document.documentID;
    //    query.startKey = @[myListId, @{}];
    //    query.endKey = @[myListId];
    return query;
}

@end
