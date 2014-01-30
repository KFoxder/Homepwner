//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Richard Fox on 1/9/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

- (id) init
{
    self = [super init];
    if (self){
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            [NSException raise:@"Open Failed" format:@"Reason : %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *) allItems
{
    return allItems;
}
- (BNRItem *) createItem
{
    double order;
    if([allItems count]==0){
        order = 1.0;
    }else{
        order = [[allItems lastObject] orderingValue] +1.0;
    }
    BNRItem * p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    return p;
}

-(NSManagedObject *) createAssetType
{
    NSManagedObject * asset = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
    [asset setValue:@"RandomType" forKey:@"label"];
    [allAssetTypes addObject:asset];
    return asset;
}

+ (BNRItemStore *) sharedStore
{
    
    //Does not change sharedStore since it cannot be instnaitated twice
    static BNRItemStore * sharedStore = nil;
    if(sharedStore ==nil){
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}
+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
- (void) removeItem: (BNRItem *) item
{
    NSString * key = [item imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [context deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}
- (void) moveFrom:(int)from To:(int)to
{
    if(from==to){
        return;
    }
    BNRItem * itemFrom = [[self allItems] objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:itemFrom atIndex:to];
    
    double lowerBound = 0.0;
    
    if(to>0){
        lowerBound = [[allItems objectAtIndex:to -1] orderingValue];
    }else{
        lowerBound = [[allItems objectAtIndex:1] orderingValue] -2.0;
    }
    
    double upperBound = 0.0;
    
    if( to < [allItems count] -1){
        upperBound = [[allItems objectAtIndex:to+1] orderingValue];
    }else{
        upperBound = [[allItems objectAtIndex:to-1] orderingValue] +2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound)/2.0;
[itemFrom setOrderingValue:newOrderValue];

}
- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}
- (BOOL) saveChanges
{
    NSError *err = nil;
    BOOL succesful = [context save:&err];
    if(!succesful){
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return succesful;
    
}
- (void) loadAllItems
{
    if(!allItems){
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription * e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch Failed" format:@"Reason : %@",[error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}
-(NSArray *) allAssetTypes
{
    if(!allAssetTypes){
        NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"BNRAssetType"];
        NSEntityDescription * e = [[model entitiesByName] objectForKey:@"BNRAssetType"];
        
        [request setEntity:e];
        
        NSError *error;
        NSArray* result = [context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch Failed" format:@"Reason: %@",[error localizedDescription]];
            
        }
        allAssetTypes = [result mutableCopy];
        
        
    }
    
    if([allAssetTypes count]==0){
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        [type setValue:@"Furniture" forKey:@"label"];
        [allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        [type setValue:@"Electronics" forKey:@"label"];
        [allAssetTypes addObject:type];
        
    }
    return allAssetTypes;
}
-(NSArray *) getItemsWithAssetType:(NSManagedObject *)assetType
{
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"BNRItem"];
    
    NSEntityDescription * e = [[model entitiesByName] objectForKey:@"BNRItem"];
    [request setEntity:e];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    NSLog(@"%d",[result count]);
    if(!result){
        [NSException raise:@"Fetch Failed" format:@"Reason : %@",[error localizedDescription]];
    }
    NSMutableArray * resultMutable = [[NSMutableArray alloc] init];;
    
    for(BNRItem * item in result){
        if(item.assetType == assetType){
            [resultMutable addObject:item];
        }
    }
    result = [NSArray arrayWithArray:resultMutable];
    
    return result;
    
}
@end
