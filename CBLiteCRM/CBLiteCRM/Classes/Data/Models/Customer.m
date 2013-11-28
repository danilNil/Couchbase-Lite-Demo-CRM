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

+ (NSString*) docIDForUsername: (NSString*)username {
    return [NSString stringWithFormat:@"%@:%@",kCustomerDocType,username];
}

+ (NSString*) usernameFromDocID: (NSString*)docID{
    return [docID substringFromIndex: kCustomerDocType.length+1];
}

+ (Customer*) createInDatabase: (CBLDatabase*)database
                 withCustomerName: (NSString*)customerName
{
    NSString* docID = [self docIDForUsername: customerName];
    CBLDocument* doc = [database documentWithID: docID];
    Customer* customer = [Customer modelForDocument: doc];

    [customer setValue: kCustomerDocType ofProperty: @"type"];

    NSRange at = [customerName rangeOfString: @"@"];
    if (at.length > 0) {
        [customer setValue: customerName ofProperty: @"companyName"];
    }

    NSError* error;
    if (![customer save: &error])
        return nil;
    return customer;
}

@end
