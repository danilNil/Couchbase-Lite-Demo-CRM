//
//  User.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface User : CBLModel

@property (readonly) NSString* username;
@property (readonly, copy) NSString* email;

/** Creates a new UserProfile, presumably for the local logged-in user. */
+ (User*) createInDatabase: (CBLDatabase*)database
                     withUsername: (NSString*)username;

@end
