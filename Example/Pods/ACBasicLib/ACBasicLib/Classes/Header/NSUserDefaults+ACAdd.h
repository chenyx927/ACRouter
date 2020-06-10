//
//  NSUserDefaults+ACAdd.h
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ACAdd)

/**
 存入自定义对象
 @param object 需要存入的自定义对象
 @param key 自定义对象对应的key
 **/
+ (void)writeWithObject:(id)object forKey:(NSString *)key;

/**
 获取自定义对象
 @param key 自定义对象对应的key
 @return 返回自定义对象
 **/
+ (id)readObjectWithKey:(NSString *)key;

/**
 删除自定义对象
 @param key 自定义对象对应的key
 **/
+ (void)removeObjectForKey:(NSString *)key;

@end
