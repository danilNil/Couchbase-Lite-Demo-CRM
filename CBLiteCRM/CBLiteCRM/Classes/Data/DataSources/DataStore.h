@class SalesPerson, Contact, Customer, Opportunity;

@interface DataStore : NSObject

- (id) initWithDatabase: (CBLDatabase*)database;

+ (DataStore*) sharedInstance;

@property (readonly) CBLDatabase* database;

// USERS:

/** The local logged-in user */
@property (nonatomic, readonly) SalesPerson* user;

/** The local logged-in user's username. */
@property (nonatomic, strong) NSString* username;

/** Gets a UserProfile for a user given their username. */
- (SalesPerson*) profileWithUsername: (NSString*)username;
@property (readonly) CBLQuery* allUsersQuery;
@property (readonly) NSArray* allOtherUsers;    /**< UserProfile objects of other users */
@property (readonly) CBLQuery* allCustomersQuery;

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail;
- (Contact*) contactWithMail: (NSString*)mail;
- (CBLQuery*) queryContacts;
- (CBLQuery*) queryContactsByOpport:(Opportunity*)opp;
- (CBLQuery*) queryOpportunities;

- (Customer*) createCustomerWithNameOrReturnExist: (NSString*)name;

- (SalesPerson*)createSalesPersonWithMailOrReturnExist: (NSString*)mail;
@end
