
#import "DataStore.h"
#import "CustomersStore.h"
#import "OpportunitiesStore.h"
#import "SalePersonsStore.h"
#import "ContactsStore.h"





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
#if kFakeDataBase
        [self createFakeDB];
#endif
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
}

- (void)createFakeDB{
    BOOL isCreated = [[NSUserDefaults standardUserDefaults] boolForKey:kCreatedFakeKey];
    if(!isCreated){
        [self.salePersonsStore createFakeSalesPersons];
        [self.customersStore createFakeCustomers];
        [self.opportunitiesStore createFakeOpportunities];
        [self.contactsStore createFakeContacts];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCreatedFakeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
