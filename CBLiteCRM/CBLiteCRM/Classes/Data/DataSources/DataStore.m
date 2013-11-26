
#import "DataStore.h"
#import "User.h"

@interface DataStore(){
    CBLView* _usersView;
}

@end

static DataStore* sInstance;

@implementation DataStore


- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super init];
    if (self) {
        NSAssert(!sInstance, @"Cannot create more than one DataStore");
        sInstance = self;
        _database = database;
        NSString* savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"UserName"];
        if(savedUserName)
            self.username = savedUserName;

        [_database.modelFactory registerClass: [User class] forDocumentType: kUserDocType];

        _usersView = [_database viewNamed: @"usersByName"];
        [_usersView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kUserDocType]) {
                NSString* name = [User usernameFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];

#if kFakeDataBase
        [self createFakeUsers];
#endif

    }
    return self;
}


+ (DataStore*) sharedInstance {
    return sInstance;
}



#pragma mark - USERS:


#if kFakeDataBase
- (void) createFakeUsers {
    User* profile = [self profileWithUsername: kExampleUserName];
    if (!profile) {
        profile = [User createInDatabase: _database
                                   withUsername: kExampleUserName];
    }
}
#endif


- (void) setUsername:(NSString *)username {
    if (![username isEqualToString: self.username]) {
        NSLog(@"Setting username to '%@'", username);
        _username = username;
        [[NSUserDefaults standardUserDefaults] setObject: username forKey: @"UserName"];

        User* myProfile = [self profileWithUsername: self.username];
        if (!myProfile) {
            myProfile = [User createInDatabase: _database
                                         withUsername: self.username];
            NSLog(@"Created user profile %@", myProfile);
        }
    }
}


- (User*) user {
    if (!self.username)
        return nil;
    User* user = [self profileWithUsername: self.username];
    if (!user) {
        user = [User createInDatabase: _database
                                withUsername: self.username];
    }
    return user;
}


- (User*) profileWithUsername: (NSString*)username {
    NSString* docID = [User docIDForUsername: username];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [User modelForDocument: doc];
}

- (CBLQuery*) allUsersQuery {
    return [_usersView query];
}

- (NSArray*) allOtherUsers {
    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in self.allUsersQuery.rows.allObjects) {
        User* user = [User modelForDocument: row.document];
        if (![user.username isEqualToString: self.username])
            [users addObject: user];
    }
    return users;
}

@end
