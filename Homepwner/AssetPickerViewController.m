//
//  AssetPickerViewController.m
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "AssetPickerViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"


@interface AssetPickerViewController ()

@end

@implementation AssetPickerViewController
@synthesize textField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneCreating:(id)sender {
    NSString *inputText = [textField text];
    if(![inputText isEqual:@""] && inputText!=nil){
        NSManagedObject * newAssetType = [[BNRItemStore sharedStore] createAssetType];
        [newAssetType setValue:[textField text] forKey:@"label"];
    }
    [[self navigationController] popViewControllerAnimated:YES];

    
}
@end
