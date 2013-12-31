//
//  TextFieldsViewController.h
//
//  Created by Danil on 8/7/13.
//

#import "EditableViewController.h"

@interface TextFieldsViewController : EditableViewController
@property(nonatomic, weak) IBOutlet UIScrollView* baseScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
