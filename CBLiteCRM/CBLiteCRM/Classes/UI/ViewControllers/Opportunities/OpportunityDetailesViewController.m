//
//  OpportunityDetailesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunityDetailesViewController.h"
#import "ContactsViewController.h"
#import "ContactsByOpportunityViewController.h"
#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"
#import "DictPickerView.h"

//Data
#import "Opportunity.h"
#import "Contact.h"
#import "OpportunitiesStore.h"
#import "Customer.h"
#import "DataStore.h"
#import "DateHelper.h"
#import "ContactOpportunityStore.h"
#import "ContactOpportunity.h"

@interface OpportunityDetailesViewController ()
<DictPickerViewDelegate, UITextFieldDelegate>
{
    UIDatePicker *creationDatePicker;
    DictPickerView *stagePicker;
    Customer *customer;
    UITextField *currentFirstResponder;
}
@end

@implementation OpportunityDetailesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupStagePicker];
    [self setStageFieldInputView];

    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self loadInfoForOpportunity:self.currentOpport];
    self.revenueField.inputAccessoryView = [self toolBar];
    self.winField.inputAccessoryView = [self toolBar];
}

- (void)setStageFieldInputView
{
    creationDatePicker = [UIDatePicker new];
    creationDatePicker.datePickerMode = UIDatePickerModeDate;
    creationDatePicker.date = [NSDate date];
    [creationDatePicker addTarget:self action:@selector(dateFieldChange) forControlEvents:UIControlEventValueChanged];
    [self.dateField setInputView:creationDatePicker];
    [self.dateField setInputAccessoryView:[self toolBar]];
}

- (NSString*)stringFromDate:(NSDate*)date
{
    NSString *dateString = [[DateHelper preparedOpportDateFormatter] stringFromDate:date];
    return dateString;
}

- (IBAction)back:(id)sender {
    self.currentOpport = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)validateAllFields
{
    if ([self.nameField.text isEqualToString:@""])
    {
        [UIAlertView showErrorMessage:@"Please fill opportunity name field"];
        return NO;
    }
    else if (![self checkThatStageFieldValueCorrect])
    {
        [UIAlertView showErrorMessage:@"Please fill stage field with correct value"];
        return NO;
    }
    else if (![self checkThatTextFieldTextIsNumeric:self.revenueField])
    {
        [UIAlertView showErrorMessage:@"Please fill revenue field with numeric value"];
        return NO;
    }
    else if (![self checkThatTextFieldTextIsNumeric:self.winField])
    {
        [UIAlertView showErrorMessage:@"Please fill win probability field with float value"];
        return NO;
    }
    else if (!customer)
    {
        [UIAlertView showErrorMessage:@"Please select customer"];
        return NO;
    }
    return YES;
}

- (BOOL)checkThatStageFieldValueCorrect
{
    if ([self.stageField.text isEqualToString:@""])
        return YES;
    for (NSString *stageValue in stagePicker.itemNames)
        if ([stageValue isEqualToString:self.stageField.text])
            return YES;
    return NO;
}

- (BOOL)checkThatTextFieldTextIsNumeric:(UITextField*)tf
{
    if ([tf.text isEqualToString:@""])
        return YES;
    NSScanner *scanner = [NSScanner scannerWithString:tf.text];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    if (!isNumeric) {
        isNumeric = [scanner scanFloat:NULL] && [scanner isAtEnd];
    }
    return isNumeric;
}

- (IBAction)saveItem:(id)sender
{
    if ([self saveItem])
        [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)saveItem {
    if([self validateAllFields]){
        Opportunity* newOpportunity = self.currentOpport;
        if(!newOpportunity) {
            newOpportunity = [[DataStore sharedInstance].opportunitiesStore createOpportunityWithTitleOrReturnExist:self.nameField.text];
            self.currentOpport = newOpportunity;
        }
        [self updateInfoForOpportunity:newOpportunity];
        NSError* error;
        if(![newOpportunity save:&error]) {
            NSLog(@"error in save opportunity: %@", error);
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)loadInfoForOpportunity:(Opportunity*)opp {
    self.nameField.enabled = !opp;
    self.deleteButton.enabled = opp ? YES: NO;
    self.showContactsButton.enabled = opp ? YES : NO;
    if (opp) {
        customer = self.currentOpport.customer;
        self.nameField.text = opp.title;
        if (opp.salesStage) {
            self.stageField.text = opp.salesStage;
            ((DictPickerView*)self.stageField.inputView).selectedItemName = opp.salesStage;
        }else{
            self.stageField.text =@"New";
        }
        if (opp.creationDate) {
            self.dateField.text = [self stringFromDate:opp.creationDate];
            creationDatePicker.date = opp.creationDate;
        }
        if([opp getValueOfProperty:@"revenueSize"]){
            if(opp.revenueSize)
                self.revenueField.text = [NSString stringWithFormat:@"%lli",opp.revenueSize];
        }
        if([opp getValueOfProperty:@"winProbability"]){
            if(opp.winProbability)
                self.winField.text =[NSString stringWithFormat:@"%.02f",opp.winProbability];
        }
        [self setCustomer:opp.customer];
    }else{
        self.stageField.text =@"New";
    }
}

- (void)updateInfoForOpportunity:(Opportunity*)opp
{
    opp.title = self.nameField.text;
    opp.salesStage = self.stageField.text;
    opp.revenueSize = [self.revenueField.text longLongValue];
    opp.winProbability = [self.winField.text floatValue];
    opp.creationDate = creationDatePicker.date;
    opp.customer = customer;
}

- (IBAction)customerDetails:(id)sender{
    if(customer)
        [self performSegueWithIdentifier:@"presentMyCustomer" sender:self];
}

- (void)dateFieldChange
{
    self.dateField.text = [NSString stringWithFormat:@"%@",
                      [[DateHelper preparedOpportDateFormatter] stringFromDate:creationDatePicker.date]];
}

- (IBAction)deleteItem:(id)sender
{
    NSError *error;
    if (![self.currentOpport deleteDocument:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)changeCustomer:(id)sender {}

- (IBAction)showContacts:(id)sender
{
    [self performSegueWithIdentifier:@"presentContactsForOpportunity" sender:self];
}

- (void)setupStagePicker
{
    stagePicker = [DictPickerView new];
    stagePicker.itemNames = @[@"New", @"In Progress", @"Finished"];
    stagePicker.pickerDelegate = self;
    [stagePicker setSelectedItemName:stagePicker.itemNames.firstObject];
    self.stageField.inputView = stagePicker;
    [self.stageField setInputAccessoryView:[self toolBar]];
}

- (void)itemPicker:(id)picker didSelectItemWithName:(NSString *)name
{
    if(picker == stagePicker)
        self.stageField.text = name;
}

- (UIToolbar*) toolBar
{
    UIToolbar *toolbar = [UIToolbar new];

    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                          target: self
                                                                          action: nil];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done", nil)
                                                             style: UIBarButtonItemStyleBordered
                                                            target: self
                                                            action: @selector(done)];
    [toolbar setItems: @[flex, done]];
    [toolbar sizeToFit];
    
    return toolbar;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CustomersViewController class]]){
        CustomersViewController* vc = (CustomersViewController*)segue.destinationViewController;
        vc.chooser = YES;
        [vc setOnSelectCustomer:^(Customer * newCustomer) {
            [self setCustomer:newCustomer];
        }];
    }else if([segue.identifier isEqualToString:@"presentMyCustomer"]){
        CustomerDetailsViewController* vc = (CustomerDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentCustomer = customer;
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsByOpportunityViewController* vc = (ContactsByOpportunityViewController*)segue.destinationViewController;
        vc.filteredOpp = self.currentOpport;
    }
}

- (void)setCustomer:(Customer*)newCustomer
{
    customer = newCustomer;
    
    [self.customerButton setTitle:[self customerTitle]
                         forState:UIControlStateNormal];
    
    [self.customerDetailsButton setEnabled:(customer.companyName != nil)];
}

- (NSString*) customerTitle
{
    if (customer)
        return [NSString stringWithFormat:@"Customer: %@", customer.companyName];
    
    return @"Select Customer";
}

- (void)done
{
    if ([self.stageField isFirstResponder]) {
        self.stageField.text = stagePicker.selectedItemName;
    } else if ([self.dateField isFirstResponder]) {
        self.dateField.text = [self stringFromDate:creationDatePicker.date];
    }
    [currentFirstResponder resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentFirstResponder = textField;
}

@end
