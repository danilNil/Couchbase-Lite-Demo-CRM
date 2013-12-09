//
//  Opportunity.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseModel.h"

@class Customer;
@interface Opportunity : BaseModel
@property (strong) Customer* customer;
@property (strong) NSDate* creationDate;
@property long long revenueSize;
@property float winProbability;
@property (copy) NSString* salesStage;
@property (readonly, strong) NSArray* contacts;
@property (copy) NSString* title;

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withTitle: (NSString*)title;
@end
