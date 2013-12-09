//
//  OpportunityStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesStore.h"
#import "Opportunity.h"
#import "Customer.h"

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
                emit(doc[@"title"], doc[@"title"]);
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
            profile = [[Opportunity alloc] initInDatabase:self.database
                                                withTitle: title];
        }
    }
}

- (Opportunity*) opportunityWithTitle: (NSString*)title {
    CBLDocument* doc = [self.database createDocument];
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
        opp = [[Opportunity alloc] initInDatabase:self.database withTitle:title];
    return opp;
}

- (Opportunity*) opporunityWithTitle: (NSString*)title{
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument:doc];
}

-(CBLQuery *)queryOpportunitiesForCustomer:(Customer *)customer
{
    CBLView* view = [self.database viewNamed: @"OpportunitiesForCustomer"];
    if (!view.mapBlock) {
        NSString* const kOppDocType = [Opportunity docType];
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kOppDocType]) {
                NSString* customerId = doc[@"customer"];
                id date = doc[@"creationDate"];
                if (customerId) {
                    emit(@[customerId, date], doc);
                }
            }
        }) reduceBlock: nil version: @"2"]; // bump version any time you change the MAPBLOCK body!
    }
    CBLQuery* query = [view createQuery];
    NSString* myCustID = customer.document.documentID;
    query.startKey = @[myCustID];
    query.endKey = @[myCustID, @{}];
    return query;
}
@end
