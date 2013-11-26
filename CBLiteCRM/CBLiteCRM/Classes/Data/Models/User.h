//
//  User.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@interface User : CBLModel

@property (readonly) NSString* username;
@property (readonly, copy) NSString* email;

/** Creates a new UserProfile, presumably for the local logged-in user. */
+ (User*) createInDatabase: (CBLDatabase*)database
                     withUsername: (NSString*)username;
+ (NSString*) usernameFromDocID: (NSString*)docID;
+ (NSString*) docIDForUsername: (NSString*)username;
@end
