//
//  NSUserDefaults+ACAdd.m
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import "NSUserDefaults+ACAdd.h"

@implementation NSUserDefaults (ACAdd)

+ (void)writeWithObject:(id)object forKey:(NSString *)key {
    [self removeObjectForKey:key];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    NSUserDefaults *userDefault = [self standardUserDefaults];
    [userDefault setObject:data forKey:key];
    [userDefault synchronize];
}

+ (id)readObjectWithKey:(NSString *)key {
    NSUserDefaults *userDefault = [self standardUserDefaults];
    id obj = [userDefault objectForKey:key];
    if (obj) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    } else {
        return nil;
    }
}

+ (void)removeObjectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [self standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

@end
