//
//  ContactsViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "FilteringViewController.h"

@class Contact, Opportunity;

@interface ContactsViewController : FilteringViewController

@property (nonatomic) BOOL chooser;
@property (nonatomic, copy) void (^onSelectContact)(Contact * contact);
@property (nonatomic, strong) Opportunity *filteringOpportunity;

@end
