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
<DictPickerViewDelegate>
{
    UIDatePicker *creationDatePicker;
    DictPickerView *stagePicker;
}
@end

@implementation OpportunityDetailesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupStagePicker];
    [self setStageFieldInputView];

    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self loadInfoForOpportunity:self.currentOpport];
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
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [df stringFromDate:date];
    return dateString;
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
    if (opp) {
        self.nameField.text = opp.title;
        if (opp.salesStage) {
            self.stageField.text = opp.salesStage;
            ((DictPickerView*)self.stageField.inputView).selectedItemName = opp.salesStage;
        }
        if (opp.creationDate) {
            self.dateField.text = [self stringFromDate:opp.creationDate];
            creationDatePicker.date = opp.creationDate;
        }
        if([opp getValueOfProperty:@"revenueSize"])
            self.revenueField.text = [NSString stringWithFormat:@"%lli",opp.revenueSize];
        if([opp getValueOfProperty:@"winProbability"])
            self.winField.text =[NSString stringWithFormat:@"%f",opp.winProbability];
        self.customerField.text = opp.customer.companyName;
    }
}

- (void)updateInfoForOpportunity:(Opportunity*)opp
{
    opp.title = self.nameField.text;
    opp.salesStage = self.stageField.text;
    opp.creationDate = creationDatePicker.date;
}

- (IBAction)customerDetails:(id)sender{
    if(self.currentOpport.customer)
        [self performSegueWithIdentifier:@"presentMyCustomer" sender:self];
}

- (IBAction)showContacts:(id)sender {}

- (void)dateFieldChange
{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.dateField.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:creationDatePicker.date]];
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
                                                            target: self
                                                            action: @selector(done)];
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

- (void)done
{
    if ([self.stageField isFirstResponder]) {
        self.stageField.text = stagePicker.selectedItemName;
        [self.stageField resignFirstResponder];
    } else if ([self.dateField isFirstResponder]) {
        self.dateField.text = [self stringFromDate:creationDatePicker.date];
        [self.dateField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
