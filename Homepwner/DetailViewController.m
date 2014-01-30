//
//  DetailViewController.m
//  Homepwner
//
//  Created by Richard Fox on 1/10/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePicker.h"

@implementation DetailViewController
@synthesize item, dismissBlock;

-(id) initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if(self){
        if(isNew){
            UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
        }
    }
    return self;
}
-(void) setItem:(BNRItem *)i
{
    if(i!=nil){
        item =i;
    }
    [[self navigationItem] setTitle:[item itemName]];
    
}
-(void) viewDidLoad
{
    [super viewDidLoad];
    //[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIColor * color = nil;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        color = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
        
    }else{
        color = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:color];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [serialField setText:[item serialNumber]];
    [nameField setText:[item itemName]];
    
    [valueField setText: [NSString stringWithFormat:@"%d",[item valueInDollars]] ];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
    [dateLabel setText:[format stringFromDate:date]];
    
    
    NSString * key = [item imageKey];
    if(key!=nil){
        UIImage * imageToDisplay = [[BNRImageStore sharedStore] imageForKey:key];
        [imageView setImage:imageToDisplay];
    }else{
        NSLog(@"NO IMAGE");
    }
    if([item imageKey]==nil){
        [imageRemoveButton setAlpha:0];
    }else{
        [imageRemoveButton setAlpha:1];
    }
    
    NSString * typeLabel = [[item assetType] valueForKey:@"label"];
    if(!typeLabel){
        typeLabel = @"None";
    }
    [assetTypeButton setTitle:[NSString stringWithFormat:@"Type %@",typeLabel] forState:UIControlStateNormal];
    
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [[self view] resignFirstResponder];
    
    [[self view] endEditing:YES];
    
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialField text]];
    [item setValueInDollars:[[valueField text] intValue]];
   
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [valueField resignFirstResponder];
    [nameField resignFirstResponder];
    [serialField resignFirstResponder];
}


- (IBAction)takePicture:(id)sender
{
    //Checks if you are alreayd trying to take a picture
    if([imagePickerPopover isPopoverVisible]){
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setEditing:YES animated:YES];
    }else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setEditing:YES animated:YES];
    }
    [imagePicker setDelegate:self];
    //[self presentViewController:imagePicker animated:YES completion:nil];
    if([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPad){
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)deleteImage:(id)sender {
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [item setImageKey:nil];
    [imageView setImage:nil];
    [imageRemoveButton setAlpha:0];
}

- (IBAction)showAssetTypePicker:(id)sender {
    [[self view] endEditing:YES];
    
    AssetTypePicker * atp = [[AssetTypePicker alloc] init];
    [atp setItem:item];
    
    [[self navigationController] pushViewController:atp animated:YES];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString * oldKey = [item imageKey];
    if(oldKey!=nil){
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    UIImage *image = nil;
    if(![info objectForKey:UIImagePickerControllerEditedImage]){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    [[BNRImageStore sharedStore] setImage:image forKey:key];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    if([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPad){
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }else{
            [self dismissViewControllerAnimated:YES completion:nil];
    }

    [imageView setImage:image];
    [imageRemoveButton setAlpha:1];
    
}

//POPOVER DELEGATE

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User Dismissed Popover");
    imagePickerPopover = nil;
}

- (void) save: (id) sender
{
     NSLog(@"User Saved");
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    
}
-(void) cancel: (id) sender
{
     NSLog(@"User Canceled");
    [[BNRItemStore sharedStore] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    
    
}
@end
