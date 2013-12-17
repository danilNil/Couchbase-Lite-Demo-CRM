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
#import "ContactsByOpportunityViewController.h"

//Data
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"
#import "Customer.h"

@interface ContactDetailsViewController ()
<
UITextFieldDelegate
>
{
    UIImage* selectedImage;
    UITapGestureRecognizer* photoTapRecognizer;
    ImagePickerAngel * imagePickerAngel;
    Customer *customer;
    UIAlertView *currentAlertView;
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
    self.mailField.enabled = !ct;
    self.deleteButton.hidden = !ct ? YES : NO;

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
    [imagePickerAngel presentImagePicker];
}

- (ImagePickerAngelBlock) createOnPickedImageBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(UIImage * image) { weakSelf.photoView.image = image; selectedImage = image;};
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
    if ([self saveContact])
        [self dismissViewControllerAnimated:YES completion:NULL];
    else
        [currentAlertView show];
}

- (IBAction)deleteItem:(id)sender
{
    NSError *error;
    if (![self.currentContact deleteDocument:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)saveContact
{
    if(self.mailField.text && ![self.mailField.text isEqualToString:@""]){
        Contact* newContact = self.currentContact;
        if(!newContact)
            newContact = [[DataStore sharedInstance].contactsStore createContactWithMailOrReturnExist:self.mailField.text];
        [self updateInfoForContact:newContact];
        return YES;
    } else {
        currentAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill contact email field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        return NO;
    }
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
    else
        self.currentContact = ct;
}

-(void)setCurrentContact:(Contact *)currentContact {
    _currentContact = currentContact;
    self.buttonsView.hidden = !currentContact;
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
