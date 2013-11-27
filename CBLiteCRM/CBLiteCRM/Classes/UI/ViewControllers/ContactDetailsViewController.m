//
//  ContactDetailsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactDetailsViewController.h"

//Data
#import "DataStore.h"
#import "Contact.h"
#import "Customer.h"

@interface ContactDetailsViewController (){
    UIImage* selectedImage;
}

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    NSLog(@"content size: %@", NSStringFromCGSize(self.baseScrollView.contentSize));
    [self loadInfo];
}

- (void)loadInfo{
    if(self.currentContact){
        self.nameField.text = self.currentContact.name;
        self.positionField.text = self.currentContact.position;
        self.phoneField.text = self.currentContact.phoneNumber;
        self.mailField.text = self.currentContact.email;
        self.addressField.text = self.currentContact.address;
    }
}

- (IBAction)back:(id)sender {
    self.currentContact = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    if(self.mailField.text && ![self.mailField.text isEqualToString:@""]){
        Contact* newContact = self.currentContact;
        if(!newContact){
            newContact = [[DataStore sharedInstance] createContactWithMailOrReturnExist:self.mailField.text];
        }
        [self updateInfoForContact:newContact];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteItem:(id)sender {
}

- (void)updateInfoForContact:(Contact*)ct{
    ct.name = self.nameField.text;
    ct.customer = [self selectedCustomer];
    ct.position = self.positionField.text;
    ct.phoneNumber = self.phoneField.text;
    ct.address = self.addressField.text;
    ct.opportunities = [self selectedOpportunities];
    if(selectedImage)
        [ct addAttachment:[self attachmentFromPhoto:selectedImage] named:@"photo"];
    NSError* error;
    [ct save:&error];
    if(error)
        NSLog(@"error in save contact: %@", error);
}

- (NSArray*)selectedOpportunities{
    return @[];
}

- (Customer*)selectedCustomer{
    return nil;
}

- (CBLAttachment*)attachmentFromPhoto:(UIImage*)image{
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
