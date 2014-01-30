//
//  BNRItem.h
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject

@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

@end
