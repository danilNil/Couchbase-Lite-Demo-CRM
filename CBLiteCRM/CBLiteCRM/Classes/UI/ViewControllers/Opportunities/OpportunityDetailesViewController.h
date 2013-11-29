//
//  OpportunityDetailesViewController.h
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@class Opportunity;
@interface OpportunityDetailesViewController : UIViewController
@property(nonatomic, strong) Opportunity* currentOpport;
- (IBAction)back:(id)sender;
- (IBAction)saveItem:(id)sender;
@end
