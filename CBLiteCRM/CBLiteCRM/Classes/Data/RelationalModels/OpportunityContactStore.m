//
//  OpportunityContactStore.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunityContactStore.h"
#import "ContactOpportunity.h"
#import "Opportunity.h"
#import "Contact.h"

@interface OpportunityContactStore ()
{
    CBLView* _contactOpportunityView;
    CBLView* _filteredOpportunitiesContactView;
}

@end

@implementation OpportunityContactStore

-(id)initWithDatabase:(CBLDatabase *)database
{
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass: [ContactOpportunity class] forDocumentType: kContactOpportunityDocType];
        _contactOpportunityView = [self.database viewNamed: @"OpportunitiesContact"];
        [_contactOpportunityView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"opportunity"])
                    emit(doc[@"opportunity"], doc);
            }
        }) version: @"1"];

        _filteredOpportunitiesContactView = [self.database viewNamed: @"filteredOpportunitiesContact"];
        [_filteredOpportunitiesContactView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"opportunity"])
                    emit(doc[@"opportunity"], doc);
            }
        }) version: @"2"];

    }
    return self;
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

-(CBLQuery *)filteredQuery
{
    return [_filteredOpportunitiesContactView createQuery];
}

@end
