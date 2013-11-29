//
//  Customer.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Customer.h"

@implementation Customer
@dynamic companyName, industry, phone, email, websiteUrl, address;

+ (NSString*) docType{
    return kCustomerDocType;
}

+ (NSString*) docIDForUsername: (NSString*)username {
    return [super docIDForUniqueField:username forDocType:[self docType]];
}

+ (NSString*) usernameFromDocID: (NSString*)docID{
    return [super uniqueFieldFromDocID:docID forDocType:[self docType]];
}

+ (Customer*) createInDatabase: (CBLDatabase*)database
                 withCustomerName: (NSString*)name
{
    Customer* customer = [super createInDatabase:database withUniqueField:name andDocType:[self docType]];
   [customer setValue:name ofProperty: @"companyName"];
    NSError* error;
    if (![customer save: &error])
        return nil;
    return customer;
}

@end
