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
#import "DictPickerView.h"

//Data
#import "Opportunity.h"
#import "Customer.h"
#import "DataStore.h"

@interface OpportunityDetailesViewController ()
<
DictPickerViewDelegate
>
{
    DictPickerView *stagePicker;
}
@end

@implementation OpportunityDetailesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupStagePickerWithStage:@"New"];
    [self.stageField setInputAccessoryView:[self toolBar]];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self loadInfoForOpportunity:self.currentOpport];
}

- (NSString*)stringFromDate:(NSDate*)date{
    return nil;
}

- (IBAction)back:(id)sender {
    self.currentOpport = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender
{
    if(![self.nameField.text isEqualToString:@""]){
        Opportunity* newOpportunity = self.currentOpport;
        if(!newOpportunity)
            newOpportunity = [[DataStore sharedInstance] createOpportunityWithTitleOrReturnExist:self.nameField.text];
        [self updateInfoForOpportunity:newOpportunity];
        NSError* error;
        if(![newOpportunity save:&error])
            NSLog(@"error in save opportunity: %@", error);
        else
            [self dismissViewControllerAnimated:YES completion:NULL];
    } else
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill opportunity name field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
}

- (void)loadInfoForOpportunity:(Opportunity*)opp {
    self.nameField.enabled = !opp;
    self.nameField.text = opp.title;
    self.stageField.text = opp.salesStage;
    self.dateField.text = [self stringFromDate:opp.creationDate];
    if([opp getValueOfProperty:@"revenueSize"])
        self.revenueField.text = [NSString stringWithFormat:@"%lli",opp.revenueSize];
    if([opp getValueOfProperty:@"winProbability"])
        self.winField.text =[NSString stringWithFormat:@"%f",opp.winProbability];
    self.customerField.text = opp.customer.companyName;
}

- (void)updateInfoForOpportunity:(Opportunity*)opp
{
    opp.title = self.nameField.text;
    opp.salesStage = self.stageField.text;
}

- (IBAction)customerDetails:(id)sender{
    if(self.currentOpport.customer)
        [self performSegueWithIdentifier:@"presentMyCustomer" sender:self];
}

- (IBAction)showContacts:(id)sender {}

- (IBAction)deleteItem:(id)sender
{
    NSError *error;
    if (![self.currentOpport deleteDocument:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)changeCustomer:(id)sender {}

- (void)setupStagePickerWithStage:(NSString*)stage {
    stagePicker = [DictPickerView new];
    stagePicker.itemNames = @[@"New", @"In Progress", @"Finished"];
    stagePicker.pickerDelegate = self;
    [stagePicker setSelectedItemName:stage];
    self.stageField.inputView = stagePicker;
}

- (void)itemPicker:(id)picker didSelectItemWithName:(NSString *)name{
    if(picker == stagePicker) {
        self.stageField.text = name;
    }
}

- (UIToolbar*) toolBar
{
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                          target: self
                                                                          action: nil];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"done", nil)
                                                             style: UIBarButtonItemStyleBordered
                                                            target: self.stageField
                                                            action: @selector(resignFirstResponder)];
    [toolbar setItems: @[flex, done]];
    return toolbar;
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
