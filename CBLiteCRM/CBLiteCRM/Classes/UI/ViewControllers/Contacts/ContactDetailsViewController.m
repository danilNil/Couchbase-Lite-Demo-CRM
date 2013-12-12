//
//  ContactDetailsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "ContactDetailsViewController.h"
#import "ImagePickerAngel.h"
#import "CustomersViewController.h"
#import "OpportunitesByContactViewController.h"
#import "DeviceSoftware.h"
//Data
#import "DataStore.h"
#import "ContactsStore.h"
#import "ContactOpportunityStore.h"
#import "Contact.h"
#import "Customer.h"
#import "ContactOpportunity.h"

@interface ContactDetailsViewController (){
    UIImage* selectedImage;
    UITapGestureRecognizer* photoTapRecognizer;
    ImagePickerAngel * imagePickerAngel;
    Customer *customer;
}

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isIOS7())
        self.automaticallyAdjustsScrollViewInsets = NO;
    else
        self.baseScrollView.frame = self.view.bounds;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    if(!photoTapRecognizer){
        photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnPhoto)];
        [self.photoView addGestureRecognizer:photoTapRecognizer];
        self.photoView.userInteractionEnabled = YES;
    }
    [self loadInfoForContact:self.currentContact];
}

- (void)loadInfoForContact:(Contact*)ct{
    self.mailField.enabled = !ct;
    self.deleteButton.enabled = ct ? YES : NO;
    if(ct){
        customer = ct.customer;
        self.nameField.text = ct.name;
        self.companyField.text = customer.companyName;
        self.positionField.text = ct.position;
        self.phoneField.text = ct.phoneNumber;
        self.mailField.text = ct.email;
        self.addressField.text = ct.address;
        [self updatePhotoWithContact:ct];
    }
}
- (void)updatePhotoWithContact:(Contact*)ct{
    UIImage* img = [self imageFromAttachment:[ct attachmentNamed:@"photo"]];
    if(img)
        self.photoView.image = img;
}

- (void)didTapOnPhoto{
    if([self.currentContact attachmentNames].count==0)
        [self pickNewImage];
}

- (void) pickNewImage
{
    if(!imagePickerAngel) {
        imagePickerAngel = [ImagePickerAngel new];
        imagePickerAngel.parentViewController = self;
    }
    imagePickerAngel.onPickedImage = [self createOnPickedImageBlock];
    [imagePickerAngel presentImagePicker];
}

- (ImagePickerAngelBlock) createOnPickedImageBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(UIImage * image) { weakSelf.photoView.image = image; selectedImage = image;};
}

- (IBAction)back:(id)sender {
    self.currentContact = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)opportunities:(id)sender
{
    if (self.currentContact) {
        [self performSegueWithIdentifier:@"presentOpportunitiesForContact" sender:self];
    }
}

- (IBAction)saveItem:(id)sender {
    if(self.mailField.text && ![self.mailField.text isEqualToString:@""]){
        Contact* newContact = self.currentContact;
        if(!newContact)
            newContact = [[DataStore sharedInstance].contactsStore createContactWithMailOrReturnExist:self.mailField.text];
        [self updateInfoForContact:newContact];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill contact email field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
}

- (IBAction)deleteItem:(id)sender
{
    NSError *error;
    if (![self.currentContact deleteDocument:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateInfoForContact:(Contact*)ct{
    ct.name = self.nameField.text;
    ct.customer = [self selectedCustomer];
    ct.position = self.positionField.text;
    ct.phoneNumber = self.phoneField.text;
    ct.address = self.addressField.text;
    ct.opportunities = [self selectedOpportunities];
    if(selectedImage)
        [ct setAttachmentNamed:@"photo" withContentType:@"image/png" content:UIImagePNGRepresentation(selectedImage)];
    NSError* error;
    if(![ct save:&error])
        NSLog(@"error in save contact: %@", error);
}

- (NSArray*)selectedOpportunities{
    return @[];
}

- (Customer*)selectedCustomer{
    return customer;
}

- (UIImage*)imageFromAttachment:(CBLAttachment*)attach{
    return [UIImage imageWithData:attach.content];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CustomersViewController class]]) {
        CustomersViewController* vc = (CustomersViewController*)segue.destinationViewController;
        [vc setOnSelectCustomer:^(Customer *cust) {
            customer = cust;
            self.companyField.text = cust.companyName;
        }];
        vc.chooser = YES;
    } else if ([segue.destinationViewController isKindOfClass:[OpportunitesByContactViewController class]]) {
        OpportunitesByContactViewController *vc = (OpportunitesByContactViewController*)segue.destinationViewController;
        vc.navigationItem.rightBarButtonItem.enabled = NO;
        vc.filteringContact = self.currentContact;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
