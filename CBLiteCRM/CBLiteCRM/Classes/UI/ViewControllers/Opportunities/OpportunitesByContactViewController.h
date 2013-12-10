//
//  OportunitesByContactViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesViewController.h"

@class Contact;

@interface OpportunitesByContactViewController : OpportunitiesViewController

@property (nonatomic, strong) Contact* filteringContact;

@end
