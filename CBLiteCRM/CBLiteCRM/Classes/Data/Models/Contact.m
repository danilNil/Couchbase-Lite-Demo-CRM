//
//  Contact.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Contact.h"

@implementation Contact
@dynamic customer, name, position, phoneNumber, email, address, opportunities, photo;


+ (NSString*) docIDForUsername: (NSString*)username {
    return [NSString stringWithFormat:@"%@:%@",kContactDocType,username];
}

+ (NSString*) usernameFromDocID: (NSString*)docID{
    return [docID substringFromIndex: kContactDocType.length+1];
}

+ (Contact*) createInDatabase: (CBLDatabase*)database
                     withUsername: (NSString*)username
{
    NSString* docID = [self docIDForUsername: username];
    CBLDocument* doc = [database documentWithID: docID];
    Contact* profile = [Contact modelForDocument: doc];
    
    [profile setValue: kContactDocType ofProperty: @"type"];
    
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
