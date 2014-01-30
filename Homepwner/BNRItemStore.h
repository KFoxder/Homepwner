//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Richard Fox on 1/9/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BNRItemStore *) sharedStore;

- (NSArray *) allItems;
- (BNRItem *) createItem;
-(NSManagedObject *) createAssetType;
- (void) removeItem:(BNRItem *) item;
- (void) moveFrom:(int) from To: (int) to;
- (NSString *) itemArchivePath;
- (BOOL) saveChanges;
- (void) loadAllItems;
- (NSArray *) allAssetTypes;
- (NSArray *) getItemsWithAssetType: (NSManagedObject *) assetType;
@end
