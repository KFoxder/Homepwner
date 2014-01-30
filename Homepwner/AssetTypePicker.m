//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "AssetPickerViewController.h"

@implementation AssetTypePicker
@synthesize item,numSections,assetSelected,itemsFiltered;


-(id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if(self){
        UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewAssetType:)];
        UINavigationItem *navBar = [self navigationItem];
        [navBar setRightBarButtonItem:rightButton];
        [navBar setTitle:@"Asset Types"];
        numSections = 1;
        
    }
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return numSections;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [[[BNRItemStore sharedStore] allAssetTypes] count];
    }else{
        NSManagedObject * assetSel = assetSelected;
        
        NSArray * results = [[BNRItemStore sharedStore] getItemsWithAssetType:assetSel];
        itemsFiltered = results;
        NSLog(@"Number of items : %d",[results count]);
        return [results count];
      
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if(indexPath.section==0){
        NSArray * allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject * assetType = [allAssets objectAtIndex:[indexPath row]];
        
        NSString *assetLabel = [assetType valueForKey:@"label"];
        [[cell textLabel] setText:assetLabel];
        
        if(assetType == [item assetType]){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return cell;
    }else{
        NSArray * items = itemsFiltered;
        BNRItem * item = [items objectAtIndex:[indexPath row]];
        [cell.textLabel setText:[item itemName]];
        return cell;
        
        
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        NSArray * allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject * assetType = [allAssets objectAtIndex:[indexPath row]];
        
        [item setAssetType:assetType];
        
        numSections = 2;
        assetSelected = assetType;
        
        [[self tableView] reloadData];
    }
    
    //[[self navigationController] popViewControllerAnimated:YES];
}

-(void) addNewAssetType:(id) sender
{
    AssetPickerViewController *assetPickerController = [[AssetPickerViewController alloc] init];
    
    [[self navigationController] pushViewController:assetPickerController animated:YES];
    
   
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

@end
