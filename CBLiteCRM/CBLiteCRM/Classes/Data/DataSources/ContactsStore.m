//
//  ContactsStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactsStore.h"
#import "Contact.h"
#import "Opportunity.h"
@interface ContactsStore()
{
    CBLView* _contactsView;
    CBLView* _filteredContactsView;
}
@end

@implementation ContactsStore

- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass: [Contact class] forDocumentType: kContactDocType];
        _contactsView = [self.database viewNamed: @"contactsByName"];
        [_contactsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactDocType]) {
                if (doc[@"email"])
                    emit(doc[@"email"], doc[@"email"]);
            }
        }) version: @"1"];
        
        _filteredContactsView = [self.database viewNamed: @"filteredContacts"];
        [_filteredContactsView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactDocType]) {
                NSString* email = doc[@"email"];
                if (email)
                    emit(email, doc);
            }
        }) version: @"2"];

    }
    return self;
}


- (void) createFakeContacts {
    for (NSDictionary *dict in [self getFakeContactsDictionary]) {
        Contact* contact = [self contactWithMail: [dict objectForKey:kEmail]];
        if (!contact) {
            contact = [[Contact alloc] initInDatabase:self.database
                                            withEmail: [dict objectForKey:kEmail]];
            contact.phoneNumber = [dict objectForKey:kPhone];
            contact.name = [dict objectForKey:kName];
            contact.position = [dict objectForKey:kPosition];
            NSError *error;
            if (![contact save:&error])
                NSLog(@"%@", error);
        }
    }
}

- (NSArray*)getFakeContactsDictionary {
    return @[[NSDictionary dictionaryWithObjectsAndKeys:
              kExampleUserName, kEmail,
              @"+8 321 2490", kPhone,
              @"Archibald", kName,
              @"Sales consultant", kPosition,
              @"Thomson Reuters", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Tovarish@mail.com", kEmail,
              @"+3 634 2983", kPhone,
              @"Dave", kName,
              @"Presales consultant", kPosition,
              @"Brittish Telecommunications", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Sestra@mail.com", kEmail,
              @"+4 623 1234", kPhone,
              @"Michael", kName,
              @"SOA", kPosition,
              @"Monitise", kCompanyName, nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Brat@mail.com", kEmail,
              @"+2 132 9162", kPhone,
              @"Eugene", kName,
              @"Lead developer", kPosition,
              @"Hewlett-Packard", kCompanyName, nil]];
}

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail{
    Contact* ct = [self contactWithMail:mail];
    if(!ct)
        ct = [[Contact alloc] initInDatabase:self.database withEmail:mail];
    return ct;
}

- (Contact*) contactWithMail: (NSString*)mail{
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Contact modelForDocument: doc];
}


- (CBLQuery*) queryContacts {
    CBLQuery* query = [_contactsView createQuery];
    query.descending = YES;
    return query;
}

- (CBLQuery *)filteredQuery
{
    return [_filteredContactsView createQuery];
}

- (CBLQuery*) queryContactsByOpport:(Opportunity*)opp {
    
    CBLView* view = [self.database viewNamed: @"contactsByOpport"];
    [view setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kContactDocType]) {
            NSString* opportList = doc[@"opportunities"];
            emit(@[opportList], doc[@"email"]);
        }
    }) reduceBlock: nil version: @"1"];
    
    CBLQuery* query = [view createQuery];
    NSLog(@"!need to implement fetching for many-to-many relationship");
    //    NSString* myListId = opp.document.documentID;
    //    query.startKey = @[myListId, @{}];
    //    query.endKey = @[myListId];
    return query;
}

@end
