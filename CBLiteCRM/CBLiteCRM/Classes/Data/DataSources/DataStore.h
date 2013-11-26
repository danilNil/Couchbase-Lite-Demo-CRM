@class User;

@interface DataStore : NSObject

- (id) initWithDatabase: (CBLDatabase*)database;

+ (DataStore*) sharedInstance;

@property (readonly) CBLDatabase* database;

// USERS:

/** The local logged-in user */
@property (nonatomic, readonly) User* user;

/** The local logged-in user's username. */
@property (nonatomic, copy) NSString* username;

/** Gets a UserProfile for a user given their username. */
- (User*) profileWithUsername: (NSString*)username;

@property (readonly) CBLQuery* allUsersQuery;
@property (readonly) NSArray* allOtherUsers;    /**< UserProfile objects of other users */

@end
