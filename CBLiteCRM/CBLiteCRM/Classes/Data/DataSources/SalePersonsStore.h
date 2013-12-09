//
//  SalePersonsStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseStore.h"
@class SalesPerson;
@interface SalePersonsStore : BaseStore
/** The local logged-in user */
@property (nonatomic, readonly) SalesPerson* user;

/** The local logged-in user's username. */
@property (nonatomic, strong) NSString* username;

/** Gets a UserProfile for a user given their username. */
- (SalesPerson*) profileWithUsername: (NSString*)username;
@property (readonly) CBLQuery* allUsersQuery;

@property (readonly) NSArray* allOtherUsers;    /**< UserProfile objects of other users */

- (void) createFakeSalesPersons;
@end
