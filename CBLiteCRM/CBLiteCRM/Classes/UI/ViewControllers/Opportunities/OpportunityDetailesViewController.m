//
//  OpportunityDetailesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunityDetailesViewController.h"
#import "ContactsViewController.h"
#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"

//Data
#import "Opportunity.h"
#import "Customer.h"

@interface OpportunityDetailesViewController ()

@end

@implementation OpportunityDetailesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self updateInfo];
}

- (void)updateInfo{
    self.nameField.text = self.currentOpport.title;
    self.stageField.text = self.currentOpport.salesStage;
    self.dateField.text = [self stringFromDate:self.currentOpport.creationDate];
    if([self.currentOpport getValueOfProperty:@"revenueSize"])
        self.revenueField.text = [NSString stringWithFormat:@"%lli",self.currentOpport.revenueSize];
    if([self.currentOpport getValueOfProperty:@"winProbability"])
        self.winField.text =[NSString stringWithFormat:@"%f",self.currentOpport.winProbability];
    self.customerField.text = self.currentOpport.customer.companyName;
}

- (NSString*)stringFromDate:(NSDate*)date{
    return nil;
}

- (IBAction)back:(id)sender {
    self.currentOpport = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    NSError* err;
    [self.currentOpport save:&err];
    if(err)
        NSLog(@"save opp err: %@", err);
}

- (IBAction)deleteItem:(id)sender {
}

- (IBAction)customerDetails:(id)sender{
    if(self.currentOpport.customer)
        [self performSegueWithIdentifier:@"presentMyCustomer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[ContactsViewController class]]){
            ContactsViewController* vc = (ContactsViewController*)navc.topViewController;
            vc.filteredOpp = self.currentOpport;
        }
    }else if([segue.destinationViewController isKindOfClass:[CustomersViewController class]]){
        CustomersViewController* vc = (CustomersViewController*)segue.destinationViewController;
        vc.chooser = YES;
        [vc setOnSelectCustomer:^(Customer *cust) {
            self.currentOpport.customer = cust;
            self.customerField.text = cust.companyName;
        }];
    }else if([segue.destinationViewController isKindOfClass:[CustomerDetailsViewController class]]){
        CustomerDetailsViewController* vc = segue.destinationViewController;
        vc.currentCustomer = self.currentOpport.customer;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
