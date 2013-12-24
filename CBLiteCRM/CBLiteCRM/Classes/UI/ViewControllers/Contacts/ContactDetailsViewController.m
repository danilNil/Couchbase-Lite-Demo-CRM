//
//  ContactDetailsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

//UI
#import "ContactDetailsViewController.h"
#import "ImagePickerAngel.h"
#import "CustomersViewController.h"
#import "OpportunitesByContactViewController.h"
#import "ContactsByOpportunityViewController.h"
#import "UIImage+Tools.h"

//Data
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"
#import "Customer.h"
#import "CBLModel+DeleteHelper.h"

#define kContactDetailsViewControllerImageSize 300

typedef void (^ValidationBlock)(BOOL isValid, NSString *msg);

@interface ContactDetailsViewController ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    UIImage* selectedImage;
    UITapGestureRecognizer* photoTapRecognizer;
    ImagePickerAngel * imagePickerAngel;
    Customer *customer;
    id currentFirstResponder;
}

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    if(!photoTapRecognizer)
    {
        photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnPhoto)];
        [self.photoView addGestureRecognizer:photoTapRecognizer];
        self.photoView.userInteractionEnabled = YES;
    }
    [self loadInfoForContact:self.currentContact];
    self.currentContact = _currentContact;
}

- (void)loadInfoForContact:(Contact*)ct{
    self.buttonsView.hidden = !ct;
    if(ct)
    {
        customer = ct.customer;
        self.nameField.text = ct.name;
        self.companyField.text = customer.companyName;
        self.positionField.text = ct.position;
        self.phoneField.text = ct.phoneNumber;
        self.mailField.text = ct.email;
        self.addressField.text = ct.address;
        self.photoView.image = [self photoImageForContact:ct];
        selectedImage = [self photoImageForContact:ct];
    }
}

- (UIImage*)photoImageForContact:(Contact*)contact
{
    UIImage * photo = [contact photo];
    
    if(!photo)
        photo = [UIImage imageNamed:@"PhotoPlaceholder"];
    
    return photo;
}

- (void)didTapOnPhoto
{
    [currentFirstResponder resignFirstResponder];
    [self pickNewImage];
}

- (void) pickNewImage
{
    if(!imagePickerAngel) {
        imagePickerAngel = [ImagePickerAngel new];
        imagePickerAngel.parentViewController = self;
    }
    imagePickerAngel.onPickedImage = [self createOnPickedImageBlock];
    imagePickerAngel.onDeleteImage = [self createOnDeleteImageBlock];
    [imagePickerAngel presentImagePicker];
}

- (ImagePickerAngelBlock) createOnPickedImageBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(UIImage * image) { [weakSelf setPhotoImage:image]; };
}

- (ImagePickerAngelDeleteBlock) createOnDeleteImageBlock {
    __weak typeof(self) weakSelf = self;
    return ^(void){
        weakSelf.photoView.image = [UIImage imageNamed:@"PhotoPlaceholder"];
        selectedImage = nil;
    };
}

- (void)setPhotoImage:(UIImage*)image
{
    UIImage * scaledImage = [image scaledSquiredImageToSize:kContactDetailsViewControllerImageSize];
    
    self.photoView.image = selectedImage = scaledImage;
}

- (IBAction)back:(id)sender {
    self.currentContact = nil;
    if ([[((UINavigationController*)self.presentingViewController).viewControllers lastObject] isKindOfClass:[ContactsViewController class]])
        [self dismissViewControllerAnimated:YES completion:NULL];
    else if ([[((UINavigationController*)self.presentingViewController).viewControllers lastObject] isKindOfClass:[OpportunitiesViewController class]])
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)opportunities:(id)sender
{
    [self performSegueWithIdentifier:@"presentOpportunitiesForContact" sender:self];
}

- (IBAction)saveItem:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self isAllRequiredFieldsValid:^(BOOL isValid, NSString *msg) {
        if(isValid){
            [weakSelf saveContact];
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        }
    }];
}

- (void)saveContact {
    Contact* newContact = self.currentContact;
    if(!newContact)
        newContact = [[DataStore sharedInstance].contactsStore createContactWithMailOrReturnExist:self.mailField.text];
    [self updateInfoForContact:newContact];
}

- (IBAction)deleteItem:(id)sender
{
    self.currentContact.deleteAlertBlock = [self createOnDeleteBlock];
    [self.currentContact showDeletionAlert];
}

- (DeleteBlock) createOnDeleteBlock {
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
        }
    };
}

- (void)isAllRequiredFieldsValid:(ValidationBlock)result {
    if (![self.mailField.text isEqualToString:@""] && customer && ![self.nameField.text isEqualToString:@""])
        result(YES, @"");
    else {
        NSMutableString *msg = [NSMutableString new];
        if (!customer)
            [msg appendString:@"Please select a company\n"];
        if ([self.mailField.text isEqualToString:@""])
            [msg appendString:@"Please fill Email field\n"];
        if ([self.nameField.text isEqualToString:@""])
            [msg appendString:@"Please fill Name field"];
        result(NO, msg);
    }
}

- (void)updateInfoForContact:(Contact*)ct{
    ct.name = self.nameField.text;
    ct.customer = [self selectedCustomer];
    ct.position = self.positionField.text;
    ct.phoneNumber = self.phoneField.text;
    ct.address = self.addressField.text;
    ct.opportunities = [self selectedOpportunities];
    ct.email = self.mailField.text;
    if(selectedImage)
        [ct setAttachmentNamed:@"photo" withContentType:@"image/png" content:UIImagePNGRepresentation(selectedImage)];
    else
        [ct removeAttachmentNamed:@"photo"];
    NSError* error;
    if(![ct save:&error])
        NSLog(@"error in save contact: %@", error);
    else
        self.currentContact = ct;
}

-(void)setCurrentContact:(Contact *)currentContact {
    _currentContact = currentContact;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentFirstResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    currentFirstResponder = nil;
    return YES;
}

@end
