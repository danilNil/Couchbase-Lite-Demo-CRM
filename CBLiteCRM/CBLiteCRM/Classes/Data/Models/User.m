//
//  User.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "User.h"
static NSString* const kUserDocType = @"user";
@implementation User

+ (NSString*) docIDForUsername: (NSString*)username {
    return [NSString stringWithFormat:@"%@:%@",kUserDocType,username];
}

- (NSString*) email {
    NSString* email = [self getValueOfProperty: @"email"];
    if (!email) {
        // If no explicit email, assume the username is a valid email if it contains an "@":
        NSString* username = self.username;
        if ([username rangeOfString: @"@"].length > 0)
            email = username;
    }
    return email;
}

+ (User*) createInDatabase: (CBLDatabase*)database
                     withUsername: (NSString*)username
{
    NSString* docID = [self docIDForUsername: username];
    CBLDocument* doc = [database documentWithID: docID];
    User* profile = [User modelForDocument: doc];
    
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
