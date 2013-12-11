//
//  OpportunityContactStore.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseStore.h"

@class Contact;

@interface OpportunityContactStore : BaseStore

-(CBLQuery *)queryOpportunitiesForContact:(Contact *)ct;

@end
