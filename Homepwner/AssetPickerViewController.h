//
//  AssetPickerViewController.h
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetPickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)doneCreating:(id)sender;

@end
