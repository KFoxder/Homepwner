//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Richard Fox on 1/10/14.
//  Copyright (c) 2014 Richard Fox. All rights reserved.
//

#import "BNRImageStore.h"
#import <UIKit/UIKit.h>

@implementation BNRImageStore

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *) sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:NULL] init];
        
    }
    return sharedStore;
}

- (id) init
{
    self = [super init];
    if(self){
        dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void) setImage:(UIImage *)image forKey:(NSString *)s
{
    [dictionary setObject:image forKey:s];
    
    NSString *imagePath = [self imagePathForKey:s];
    
    //JPEG
    //NSData *d = UIImageJPEGRepresentation(image, 0.5);
    
    //PNG
    NSData *d = UIImagePNGRepresentation(image);
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *) imageForKey:(NSString *)s
{
    UIImage *result = [dictionary objectForKey:s];
    if(!result){
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        if(result){
            [dictionary setObject:result forKey:s];
        }else{
            NSLog(@"Error: Could not find file %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void) deleteImageForKey:(NSString *)s
{
    if(!s){
        return;
    }
    [dictionary removeObjectForKey:s];
    
    NSString *imagePath = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
    
}
- (NSString *) imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}
- (void) clearCache: (NSNotification *) note
{
    [dictionary removeAllObjects];
}
@end
