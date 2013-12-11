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
    CBLView* _filteredContactsOpportunityView;
    CBLView* _filteredOpportunitiesContactView;
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
        _filteredContactsOpportunityView = [self.database viewNamed: @"filteredContactsOpportunities"];
        [_filteredContactsOpportunityView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"contact"])
                    emit(doc[@"contact"], doc[@"contact"]);
            }
        }) version: @"2"];

        _filteredOpportunitiesContactView = [self.database viewNamed: @"filteredOpportunitiesContact"];
        [_filteredOpportunitiesContactView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"opportunity"])
                    emit(doc[@"opportunity"], doc[@"opportunity"]);
            }
        }) version: @"2"];

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
    CBLQuery* query = [view createQuery];
    NSString* oppID = opp.document.documentID;
    query.keys = @[oppID];
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
    CBLQuery* query = [view createQuery];
    NSString* ctID = ct.document.documentID;
    query.keys = @[ctID];
    return query;
}

-(CBLQuery *)filteredContactsQuery
{
    return [_filteredContactsOpportunityView createQuery];
}

-(CBLQuery *)filteredOpportunitiesQuery
{
    return [_filteredOpportunitiesContactView createQuery];
}

@end
