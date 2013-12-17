//
//  MenuViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "LogoutProtocol.h"

@interface MenuViewController : UIViewController<LogoutProtocol>

@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *customersButton;
@property (weak, nonatomic) IBOutlet UIButton *oppButton;

- (IBAction)logout:(id)sender;
@end
