//
//  BNRItem.m
//  Homepwner
//
//  Created by Richard Fox on 1/15/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic orderingValue;
@dynamic assetType;

-(void) awakeFromFetch
{
    [super awakeFromFetch];
}
- (void) awakeFromInsert
{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
    [self setDateCreated:t];
}
@end
