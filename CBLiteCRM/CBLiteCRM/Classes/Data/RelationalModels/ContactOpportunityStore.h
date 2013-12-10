//
//  ContactOpportunityStore.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseStore.h"

@class Opportunity, Contact;

@interface ContactOpportunityStore : BaseStore

- (CBLQuery*)queryContactsForOpportunity:(Opportunity*)opp;
- (CBLQuery*)queryOpportunitiesForContact:(Contact*)ct;

@end
