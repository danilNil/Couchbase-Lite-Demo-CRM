//
//  SalesPerson.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPerson.h"

@implementation SalesPerson
@dynamic username, phoneNumber, email, approved;

+ (NSString*) docIDForUsername: (NSString*)username {
    return [NSString stringWithFormat:@"%@:%@",kUserDocType,username];
}

+ (NSString*) usernameFromDocID: (NSString*)docID{
    return [docID substringFromIndex: kUserDocType.length+1];
}

+ (SalesPerson*) createInDatabase: (CBLDatabase*)database
              withUsername: (NSString*)username
{
    NSString* docID = [self docIDForUsername: username];
    CBLDocument* doc = [database documentWithID: docID];
    SalesPerson* profile = [SalesPerson modelForDocument: doc];
    
    [profile setValue: kUserDocType ofProperty: @"type"];
    
    NSRange at = [username rangeOfString: @"@"];
    if (at.length > 0) {
        [profile setValue: username ofProperty: @"email"];
    }
    
    NSError* error;
    if (![profile save: &error])
        return nil;
    return profile;
}

@end
