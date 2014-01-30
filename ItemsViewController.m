//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Richard Fox on 1/9/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "SWTableViewCell.h"


#import "CPTTestAppBarChartController.h"

@implementation ItemsViewController

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style: UIBarButtonItemStyleBordered target:self action:@selector(addNewItem:)];
    

        UINavigationItem *navItem = [self navigationItem];
        [navItem setTitle:@"HomePwner"];
        [navItem setRightBarButtonItem:rightButton];
        [navItem setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self tableView] reloadData];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
   // UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
   // [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
    
}

- (void)addNewItem:(id)sender
{
    BNRItem * newItem = [[BNRItemStore sharedStore] createItem];
    DetailViewController *dvc = [[DetailViewController alloc] initForNewItem:YES];
    [dvc setItem:newItem];
    [dvc setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:dvc];
    [navCont setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navCont animated:YES completion: nil];
    
    
}

//TableViewDataSource 

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"More"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"Delete"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:self.tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        //cell.delegate = self;
    }
    
    cell.textLabel.text = @"Text Label";
    cell.detailTextLabel.text = @"Some detail text";
    /*
    HomepwnerItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    BNRItem * cellItem = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    NSString * cellTitle = [cellItem itemName];
    NSString * cellDesc = [cellItem serialNumber];
    NSString * cellValue = [NSString stringWithFormat:@"$%d",[cellItem valueInDollars]];
    NSString * cellImageKey = [cellItem imageKey];
    if(cellImageKey!=nil){
        UIImage * cellThumbnail = [[BNRImageStore sharedStore] imageForKey:cellImageKey];
        [cell.imageView setImage:cellThumbnail];
    }else{
        [cell.imageView setImage:nil];
    }
    
    [cell.nameLabel setText:cellTitle];
    [cell.descLabel setText:cellDesc];
    [cell.valueLabel setText:cellValue];
     */
    
    return cell;

    
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete){
        BNRItemStore * bs = [BNRItemStore sharedStore];
        NSArray * items = [bs allItems];
        BNRItem * itemToRemove = [items objectAtIndex:[indexPath row]];
        [bs removeItem:itemToRemove];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveFrom:[sourceIndexPath row] To:[destinationIndexPath row]];
}

//TableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     /*
    
    CPTTestAppBarChartController * vc = [[CPTTestAppBarChartController alloc] initWithNibName:@"BarChart" bundle:nil];
    [[self navigationController] pushViewController:vc animated:YES];
   
    BNRItem * itemSelected = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    DetailViewController *dvc = [[DetailViewController alloc] initForNewItem:NO];
    [dvc setItem:itemSelected];
    
    [[self navigationController] pushViewController:dvc animated:YES];
     */

    
}


@end
