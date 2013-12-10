//
//  ContactOpportunityStore.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactOpportunityStore.h"
#import "ContactOpportunity.h"
#import "Opportunity.h"
#import "Contact.h"

@interface ContactOpportunityStore ()
{
    CBLView* _contactOpportunityView;
}

@end

@implementation ContactOpportunityStore
-(id)initWithDatabase:(CBLDatabase *)database
{
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass: [ContactOpportunity class] forDocumentType: kContactOpportunityDocType];
        _contactOpportunityView = [self.database viewNamed: @"ContactOpportunity"];
        [_contactOpportunityView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"email"])
                    emit(doc[@"email"], doc[@"email"]);
            }
        }) version: @"1"];
    }
    return self;
}

-(CBLQuery *)queryContactsForOpportunity:(Opportunity *)opp
{
    CBLView* view = [self.database viewNamed: @"ContactsForOpportunity"];
    if (!view.mapBlock) {
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                NSString* opportunityId = doc[@"opportunity"];
                if (opportunityId) {
                    emit(opportunityId, doc);
                }
            }
        }) reduceBlock: nil version: @"1"]; // bump version any time you change the MAPBLOCK body!
    }
    NSError *err;
    CBLQuery* query = [view createQuery];
    NSLog(@"%u", [[query rows:&err] count]);
    NSString* oppID = opp.document.documentID;
    query.keys = @[oppID];
    NSLog(@"filtered %u", [[query rows:&err] count]);
    return query;
}

-(CBLQuery *)queryOpportunitiesForContact:(Contact *)ct
{
    CBLView* view = [self.database viewNamed: @"OpportunitiesForContact"];
    if (!view.mapBlock) {
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                NSString* contactId = doc[@"contact"];
                if (contactId) {
                    emit(contactId, doc);
                }
            }
        }) reduceBlock: nil version: @"1"]; // bump version any time you change the MAPBLOCK body!
    }
    NSError *err;
    CBLQuery* query = [view createQuery];
    NSLog(@"%u", [[query rows:&err] count]);
    NSString* ctID = ct.document.documentID;
    query.keys = @[ctID];
    NSLog(@"filtered %u", [[query rows:&err] count]);
    return query;

}

@end
