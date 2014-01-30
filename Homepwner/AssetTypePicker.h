//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface AssetTypePicker : UITableViewController
{

}

@property (nonatomic,strong) BNRItem *item;
@property (nonatomic) NSInteger numSections;
@property (nonatomic,strong) NSManagedObject *assetSelected;
@property (nonatomic,strong) NSArray * itemsFiltered;
@end
