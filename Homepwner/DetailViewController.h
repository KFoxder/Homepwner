//
//  DetailViewController.h
//  Homepwner
//
//  Created by Richard Fox on 1/10/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *imageRemoveButton;
    
    UIPopoverController *imagePickerPopover;
    
    __weak IBOutlet UIButton *assetTypeButton;
}
@property (nonatomic, strong) BNRItem *item;
@property (nonatomic,copy) void (^dismissBlock)(void);
- (IBAction)takePicture:(id)sender;
- (IBAction)deleteImage:(id)sender;
- (IBAction)showAssetTypePicker:(id)sender;

- (id) initForNewItem:(BOOL) isNew;
@end
