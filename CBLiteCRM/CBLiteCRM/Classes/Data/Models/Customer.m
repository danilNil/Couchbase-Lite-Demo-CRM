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

@end
