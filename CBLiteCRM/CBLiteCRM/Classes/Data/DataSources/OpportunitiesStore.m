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
    }
    return self;
}

- (Opportunity*) opportunityWithTitle: (NSString*)title {
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Opportunity modelForDocument: doc];
}

-(CBLQuery *)filteredQuery {
    return [_opportView createQuery];
}

- (CBLQuery*) queryOpportunities {
    return [_opportView createQuery];
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
    CBLView * view  = [self createOpportunitiesForCustomerView];
    CBLQuery* query = [view createQuery];
    NSString* myCustID = customer.document.documentID;
    query.startKey = @[myCustID, @{}];
    query.endKey   = @[myCustID];
    return query;
}

#pragma mark - Views

- (CBLView *)createOpportunitiesForCustomerView
{
    CBLView* view = [self.database viewNamed: @"OpportunitiesForCustomer"];
    if(!view.mapBlock) {
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
    return view;
}

@end
