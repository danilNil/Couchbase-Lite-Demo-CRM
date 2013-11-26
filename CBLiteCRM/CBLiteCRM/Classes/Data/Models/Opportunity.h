//
//  Opportunity.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@class Customer;
@interface Opportunity : CBLModel
@property (strong) Customer* customer;
@property (strong) NSDate* creationDate;
@property long long revenueSize;
@property float winProbability;
@property int salesStage;
@property (readonly, strong) NSArray* contacts;
@end
