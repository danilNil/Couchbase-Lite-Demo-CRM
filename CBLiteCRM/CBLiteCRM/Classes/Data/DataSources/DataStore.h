@class SalesPerson, Contact, Customer, Opportunity;
@class SalePersonsStore,CustomersStore, OpportunitiesStore, ContactsStore;

@interface DataStore : NSObject

- (id) initWithDatabase: (CBLDatabase*)database;

+ (DataStore*) sharedInstance;

@property (readonly) CBLDatabase* database;
@property (readonly, strong) SalePersonsStore* salePersonsStore;
@property (readonly, strong) CustomersStore* customersStore;
@property (readonly, strong) OpportunitiesStore* opportunitiesStore;
@property (readonly, strong) ContactsStore* contactsStore;

@end
