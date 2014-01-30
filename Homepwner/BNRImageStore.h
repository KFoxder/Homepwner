//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Richard Fox on 1/10/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (BNRImageStore *) sharedStore;

- (void) setImage:(UIImage *) image forKey:(NSString *)s;
- (UIImage *) imageForKey:(NSString *) s;
- (void) deleteImageForKey:(NSString *) s;
- (NSString *) imagePathForKey: (NSString *) key;

@end
