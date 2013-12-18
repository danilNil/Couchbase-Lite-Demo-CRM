//
//  Customer.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"
#import "ContactsStore.h"
#import "OpportunitiesStore.h"
#import "Contact.h"
#import "Opportunity.h"

@implementation Customer
@dynamic companyName, industry, phone, email, websiteUrl, address;

+ (NSString*) docType{
    return kCustomerDocType;
}


- (instancetype) initInDatabase: (CBLDatabase*)database
               withCustomerName: (NSString*)name
{
    NSParameterAssert(name);
    self = [super initInDatabase:database];
    if(self){
        [self setValue:name ofProperty: @"companyName"];
    }

    NSError* error;
    if (![self save: &error])
        return nil;
    return self;
}

- (BOOL)deleteDocument: (NSError**)outError
{
    ContactsStore *ctStore = [DataStore sharedInstance].contactsStore;
    CBLQuery *cQ = [ctStore queryContactsByCustomer:self];
    NSError *er;
    for (CBLQueryRow *r in [cQ rows:&er]) {
        Contact *c = [Contact modelForDocument:r.document];
        c.customer = nil;
        [c save:&er];
    }

    OpportunitiesStore *oppStore = [DataStore sharedInstance].opportunitiesStore;
    CBLQuery *oppQ = [oppStore queryOpportunitiesForCustomer:self];
    for (CBLQueryRow *r in [oppQ rows:&er]) {
        Opportunity *opp = [Opportunity modelForDocument:r.document];
        opp.customer = nil;
        [opp save:&er];
    }

    return [super deleteDocument:outError];
}


@end
