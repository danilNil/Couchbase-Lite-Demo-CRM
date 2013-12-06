//
//  ViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "WelcomeViewController.h"

//Data
#import "DataStore.h"
#import "SalePersonsStore.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personaLogin:(id)sender {
    [self loginWithUserName:kExampleUserName];
}

- (void)loginWithUserName:(NSString*) username{
    if([[DataStore sharedInstance].salePersonsStore profileWithUsername:username])
        [self performSegueWithIdentifier:@"pushMenuController" sender:self];
}

- (IBAction)facebookLogin:(id)sender {
    [self loginWithUserName:kExampleUserName];
}
@end
