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

- (BOOL)deleteDoc
{
    NSError* err;
    CBLQuery *query = [[DataStore sharedInstance].customersStore getAllCustomersQuery];
    NSLog(@"%u", [[query rows:&err] count]);
    query.keys = @[self.document.documentID];
    NSLog(@"%u", [[query rows:&err] count]);
    for (CBLQueryRow* r in [query rows:&err]) {
        [r.document deleteDocument:&err];
        NSLog(@"%@", r);
    }

//    CBLQuery *query2 = [[DataStore sharedInstance].customersStore getAllRelatedToCustomerQuery];
//    NSLog(@"%u", [[query2 rows:&err] count]);
//    query2.keys = @[self.document.documentID];
//    NSLog(@"%u", [[query2 rows:&err] count]);
//    for (CBLQueryRow* r in [query2 rows:&err]) {
//        [r.document  deleteDocument:&err];
//        NSLog(@"%@", r);
//    }

    return YES;
}

@end
