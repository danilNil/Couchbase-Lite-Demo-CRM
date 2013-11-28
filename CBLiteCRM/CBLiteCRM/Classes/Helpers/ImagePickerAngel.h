//
//  ImagePickerAngel.h
//  ProfileCode
//
//  Created by Andrew on 18.09.13.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerAngelBlock) (UIImage * image);

@interface ImagePickerAngel : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController * parentViewController;
@property (nonatomic, copy) void (^onPickedImage) (UIImage * image);

- (void) presentImagePicker;

@end
