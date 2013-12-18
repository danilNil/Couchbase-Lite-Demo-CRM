//
//  ImagePickerAngel.m
//  ProfileCode
//
//  Created by Andrew on 18.09.13.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import "ImagePickerAngel.h"
#import "ActionSheet.h"

@implementation ImagePickerAngel

- (void) presentImagePicker
{
    if ([self isParentViewControllerNotAvailable]) return;
    
    if ([self canUseCameraToPickImage])
        [self presentImagePickerActionSheet];
    else
        [self presentImagePickerForPhotoLibrary];
}

- (void) presentImagePickerActionSheet
{
    ActionSheet * actionSheet = [[ActionSheet new] withCancelButtonDefault];
    
    [self actionSheet:actionSheet addButton:NSLocalizedString(@"Take A Photo", @"Take A Photo")             withPickerType:UIImagePickerControllerSourceTypeCamera];
    [self actionSheet:actionSheet addButton:NSLocalizedString(@"Choose An Existing Photo",@"Choose An Existing Photo") withPickerType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [actionSheet showInView:self.parentViewController.view];
}

- (void)actionSheet:(ActionSheet *)actionSheet addButton:(NSString *)title withPickerType:(UIImagePickerControllerSourceType)pickerType
{
    [actionSheet addOtherButton:title block:^{
        [self presentImagePickerWithSourceType:pickerType];
    }];
}

- (void) presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    [self.parentViewController presentViewController:[self createImagePickerOfSourceType:sourceType]
                                            animated:YES
                                          completion:NULL];
}

- (UIImagePickerController *)createImagePickerOfSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController * uiImagePickerController = [[UIImagePickerController alloc] init];
    uiImagePickerController.delegate                  = self;
    uiImagePickerController.allowsEditing             = YES;
    uiImagePickerController.sourceType                = sourceType;
    
    return uiImagePickerController;
}

- (void) callOnPickedImageBlockWithImage:(UIImage*)image
{
    if (self.onPickedImage)
        self.onPickedImage(image);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];

    UIImage * pickedImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];

    [self callOnPickedImageBlockWithImage:pickedImage];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // After Image Picker is shown status bar is set to black for some reason
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Utils

- (BOOL) isParentViewControllerNotAvailable
{
    return self.parentViewController == nil;
}

- (BOOL) canUseCameraToPickImage
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void) presentImagePickerForPhotoLibrary
{
    [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

@end
