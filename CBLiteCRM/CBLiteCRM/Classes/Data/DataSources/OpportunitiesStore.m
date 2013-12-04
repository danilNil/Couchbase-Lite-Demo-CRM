//
//  OpportunityStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesStore.h"
#import "Opportunity.h"

@interface OpportunitiesStore(){
    CBLView* _opportView;
}
@end

@implementation OpportunitiesStore
- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass:[Opportunity class] forDocumentType: kOpportDocType];
        _opportView = [self.database viewNamed: @"oppByName"];
        [_opportView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kOpportDocType]) {
                NSString* name = [Opportunity titleFromDocID: doc[@"_id"]];
                if (name)
                    emit(name.lowercaseString, name);
            }
        }) version: @"1"];
#if kFakeDataBase

        [self createFakeOpportunities];
#endif

    }
    return self;
}


- (void) createFakeOpportunities {
    NSArray *array = @[@"OPP1", @"OPP2", @"OPP3", @"OPP4"];
    for (NSString *title in array) {
        Opportunity* profile = [self opportunityWithTitle:title];
        if (!profile) {
            profile = [Opportunity createInDatabase: self.database
                                          withTitle: title];
        }
    }
}

- (Opportunity*) opportunityWithTitle: (NSString*)title {
    NSString* docID = [Opportunity docIDForTitle: title];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument: doc];
}


- (CBLQuery*) queryOpportunities {
    CBLQuery* query = [_opportView createQuery];
    query.descending = YES;
    return query;
}

-(Opportunity *)createOpportunityWithTitleOrReturnExist:(NSString *)title
{
    Opportunity* opp = [self opportunityWithTitle:title];
    if(!opp)
        opp = [Opportunity createInDatabase:self.database withTitle:title];
    return opp;
}

- (Opportunity*) opporunityWithTitle: (NSString*)title{
    NSString* docID = [Opportunity docIDForTitle:title];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument:doc];
}
@end
