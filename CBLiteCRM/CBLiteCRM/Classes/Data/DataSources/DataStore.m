
#import "DataStore.h"
#import "CustomersStore.h"
#import "OpportunitiesStore.h"
#import "SalePersonsStore.h"
#import "ContactsStore.h"
#import "ContactOpportunityStore.h"
#import "OpportunityForContactStore.h"

@interface DataStore()
@end

static DataStore* sInstance;

@implementation DataStore


- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super init];
    if (self) {
        NSAssert(!sInstance, @"Cannot create more than one DataStore");
        sInstance = self;
        _database = database;
        [self initStores];
    }
    return self;
}


+ (DataStore*) sharedInstance {
    return sInstance;
}

- (void)initStores{
    _salePersonsStore = [[SalePersonsStore alloc] initWithDatabase:self.database];
    _customersStore = [[CustomersStore alloc] initWithDatabase:self.database];
    _opportunitiesStore = [[OpportunitiesStore alloc] initWithDatabase:self.database];
    _contactsStore = [[ContactsStore alloc] initWithDatabase:self.database];
    _contactOpportunityStore = [[ContactOpportunityStore alloc] initWithDatabase:self.database];
    _opportunityContactStore = [[OpportunityForContactStore alloc] initWithDatabase:self.database];
}

@end
