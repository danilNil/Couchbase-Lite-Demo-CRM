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
    CBLView* _filteredCustomersView;
    CBLView* _allCustomersView;
    CBLView* _allRelatedToCustomerView;
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
                if (doc[@"companyName"])
                    emit(doc[@"companyName"], doc[@"companyName"]);
            }
        }) version: @"1"];
        
        _filteredCustomersView = [self.database viewNamed: @"filteredCustomers"];
        
        [_filteredCustomersView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString:kCustomerDocType]) {
                NSString* companyName = doc[@"companyName"];
                if (companyName)
                    emit(companyName, doc);
            }
        }) version: @"1"];

        _allCustomersView = [self.database viewNamed:@"allCustomers"];
        [_allCustomersView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kCustomerDocType])
                emit(doc[@"_id"], doc[@"_id"]);
        }) version: @"3"];

        _allRelatedToCustomerView = [self.database viewNamed:@"allRelatedToCustomer"];
        [_allRelatedToCustomerView setMapBlock: MAPBLOCK({
            if (doc[@"customer"])
                emit(doc[@"customer"],doc[@"customer"]);
        }) version: @"1"];

    }
    return self;
}

- (CBLQuery*)getAllCustomersQuery
{
    return [_allCustomersView createQuery];
}

-(CBLQuery *)getAllRelatedToCustomerQuery
{
    return [_allRelatedToCustomerView createQuery];
}

- (void) createFakeCustomers {
    for (NSDictionary *dict in [self getFakeCustomersDictionary]) {
        Customer* customer = [self customerWithName: [dict objectForKey:kName]];
        if (!customer) {
            customer = [[Customer alloc] initInDatabase:self.database
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
        cm = [[Customer alloc] initInDatabase:self.database withCustomerName:name];
    return cm;
}

- (Customer*) customerWithName: (NSString*)name {
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Customer modelForDocument: doc];
}

- (CBLQuery*) allCustomersQuery {
    return [_customersView createQuery];
}

- (CBLQuery *)filteredQuery
{
    return [_filteredCustomersView createQuery];
}

@end
