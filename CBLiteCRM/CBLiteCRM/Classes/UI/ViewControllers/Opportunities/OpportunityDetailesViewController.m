//
//  OpportunityDetailesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
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
#import "CBLModelDeleteHelper.h"

@interface OpportunityDetailesViewController ()
<DictPickerViewDelegate, UITextFieldDelegate>
{
    UIDatePicker *creationDatePicker;
    DictPickerView *stagePicker;
    Customer *customer;
    UITextField *currentFirstResponder;
    DictPickerView *winProbabilityPicker;
    CBLModelDeleteHelper* deleteHelper;
}
@end

@implementation OpportunityDetailesViewController
@synthesize deleteButton, textFields;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self setupPickers];
    [self loadInfoForOpportunity:self.currentOpport];
    [self setupMode];
    deleteHelper = [CBLModelDeleteHelper new];
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
}

- (void)setupPickers
{
    [self setupStagePicker];
    [self setupWinProbabilityPicker];
    [self setStageFieldInputView];
    self.revenueField.inputAccessoryView = [self toolBar];
    self.winField.inputAccessoryView = [self toolBar];
    
}

- (void)setupMode
{
    BOOL editMode;
    if(self.currentOpport)
        editMode = NO;
    else
        editMode = YES;
    [self setEditMode:editMode];
}

- (void)loadInfoForOpportunity:(Opportunity*)opp {
    self.buttonsView.hidden = !opp;
    if (opp) {
        customer = self.currentOpport.customer;
        self.nameField.text = opp.title;
        if (opp.salesStage) {
            self.stageField.text = opp.salesStage;
            ((DictPickerView*)self.stageField.inputView).selectedItemName = opp.salesStage;
        } else {
            self.stageField.text =@"New";
        }
        if (opp.creationDate) {
            self.dateField.text = [self stringFromDate:opp.creationDate];
            creationDatePicker.date = opp.creationDate;
        }
        if([opp getValueOfProperty:@"revenueSize"]) {
            if(opp.revenueSize)
                self.revenueField.text = [NSString stringWithFormat:@"%lli",opp.revenueSize];
        }
        if([opp getValueOfProperty:@"winProbability"]) {
            if(opp.winProbability) {
                self.winField.text = [NSString stringWithFormat:@"%.0f\%%", opp.winProbability * 100];
                winProbabilityPicker.selectedItemName = [NSString stringWithFormat:@"%.0f\%%", opp.winProbability * 100];
            }
        }
        [self setCustomer:opp.customer];
    }else{
        self.stageField.text =@"New";
    }
}

#pragma mark - pickers

- (void)setStageFieldInputView
{
    creationDatePicker = [UIDatePicker new];
    creationDatePicker.datePickerMode = UIDatePickerModeDate;
    creationDatePicker.date = [NSDate date];
    [creationDatePicker addTarget:self action:@selector(dateFieldChange) forControlEvents:UIControlEventValueChanged];
    [self.dateField setInputView:creationDatePicker];
    [self.dateField setInputAccessoryView:[self toolBar]];
}

- (void)dateFieldChange
{
    self.dateField.text = [NSString stringWithFormat:@"%@",
                           [[DateHelper preparedOpportDateFormatter] stringFromDate:creationDatePicker.date]];
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

- (void)setupWinProbabilityPicker
{
    winProbabilityPicker = [DictPickerView new];
    NSMutableArray *values = [NSMutableArray new];
    for (NSUInteger i = 0; i <= 100; i++) {
        [values addObject:[NSString stringWithFormat:@"%u\%%", i]];
    }
    winProbabilityPicker.itemNames = values;
    winProbabilityPicker.pickerDelegate = self;
    [winProbabilityPicker setSelectedItemName:stagePicker.itemNames.firstObject];
    self.winField.inputView = winProbabilityPicker;
    [self.winField setInputAccessoryView:[self toolBar]];
}

- (void)itemPicker:(id)picker didSelectItemWithName:(NSString *)name
{
    if(picker == stagePicker)
        self.stageField.text = name;
    else if (picker == winProbabilityPicker)
        self.winField.text = name;
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

- (void)done
{
    if ([self.stageField isFirstResponder]) {
        self.stageField.text = stagePicker.selectedItemName;
    } else if ([self.dateField isFirstResponder]) {
        self.dateField.text = [self stringFromDate:creationDatePicker.date];
    } else if ([self.winField isFirstResponder]) {
        self.winField.text = winProbabilityPicker.selectedItemName;
    }
    [currentFirstResponder resignFirstResponder];
}


#pragma mark - Actions

- (IBAction)back:(id)sender {
    self.currentOpport = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle]){
        if ([self saveItem])
            [self dismissViewControllerAnimated:YES completion:NULL];
    }else if([self.navigationItem.rightBarButtonItem.title isEqualToString:kEditTitle])
        [self setEditMode:YES];
}

- (IBAction)customerDetails:(id)sender{
    if(customer)
        [self performSegueWithIdentifier:@"presentMyCustomer" sender:self];
}

- (IBAction)deleteItem:(id)sender
{
    deleteHelper.item = self.currentOpport;
    deleteHelper.deleteAlertBlock = [self createOnDeleteBlock];
    [deleteHelper showDeletionAlert];
}

- (IBAction)showContacts:(id)sender
{
    [self performSegueWithIdentifier:@"presentContactsForOpportunity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CustomersViewController class]]){
        CustomersViewController* vc = (CustomersViewController*)segue.destinationViewController;
        vc.chooser = YES;
        [vc setOnSelectCustomer:^(Customer * newCustomer) {
            [self setCustomer:newCustomer];
            if (self.currentOpport) {
                self.currentOpport.customer = newCustomer;
                NSError *error;
                [self.currentOpport save:&error];
            }
        }];
    }else if([segue.identifier isEqualToString:@"presentMyCustomer"]){
        CustomerDetailsViewController* vc = (CustomerDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentCustomer = customer;
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsByOpportunityViewController* vc = (ContactsByOpportunityViewController*)segue.destinationViewController;
        vc.filteredOpp = self.currentOpport;
    }
}

#pragma mark - info validation

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
    else if (![self checkThatWinFieldValueCorrect])
    {
        [UIAlertView showErrorMessage:@"Please fill win probability field with correct value"];
        return NO;
    }
    else if (!customer)
    {
        [UIAlertView showErrorMessage:@"Please select a customer"];
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

- (BOOL)checkThatWinFieldValueCorrect
{
    if ([self.winField.text isEqualToString:@""])
        return YES;
    for (NSString *winValue in winProbabilityPicker.itemNames)
        if ([winValue isEqualToString:self.winField.text])
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

#pragma mark - save delete item helper methods

- (void)updateInfoForOpportunity:(Opportunity*)opp
{
    opp.title = self.nameField.text;
    opp.salesStage = self.stageField.text;
    opp.revenueSize = [self.revenueField.text longLongValue];
    opp.winProbability = [self.winField.text floatValue] / 100;
    opp.creationDate = creationDatePicker.date;
    opp.customer = customer;
}

- (BOOL)saveItem {
    BOOL saved = NO;
    if([self validateAllFields]){
        if(!self.currentOpport) {
            self.currentOpport = [[DataStore sharedInstance].opportunitiesStore createOpportunityWithTitle:self.nameField.text];
        }
        [self updateInfoForOpportunity:self.currentOpport];
        NSError* error;
        if([self.currentOpport save:&error]) {
            saved = YES;
        }else{
            NSLog(@"error in save opportunity: %@", error);
        }
    }
    return saved;
}

-(DeleteBlock)createOnDeleteBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete)
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
    };
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


#pragma mark - helper methods

- (NSString*)stringFromDate:(NSDate*)date
{
    NSString *dateString = [[DateHelper preparedOpportDateFormatter] stringFromDate:date];
    return dateString;
}


- (NSString*) customerTitle
{
    if (customer)
        return [NSString stringWithFormat:@"Customer: %@", customer.companyName];
    return @"Select Customer";
}

- (void)setCustomer:(Customer*)newCustomer
{
    customer = newCustomer;
    
    [self.customerButton setTitle:[self customerTitle]
                         forState:UIControlStateNormal];
    
    [self.customerDetailsButton setEnabled:(customer.companyName != nil)];
}

@end
