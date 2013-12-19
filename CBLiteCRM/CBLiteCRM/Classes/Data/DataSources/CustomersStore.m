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

@interface CustomersStore() {
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
                if (doc[@"companyName"])
                    emit(doc[@"companyName"], doc[@"companyName"]);
            }
        }) version: @"1"];
    }
    return self;
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
    return [_customersView createQuery];
}

@end
