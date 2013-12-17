//
//  MenuViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "LogoutProtocol.h"

@interface MenuViewController : UIViewController<LogoutProtocol>

- (IBAction)logout:(id)sender;
@end
