//
//  NSDictionary+ACAdd.h
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (ACAdd)

/**
 安全解析字典中key对应的值
 @param aKey 键值对的键
 @return key对应的值
 **/
- (nullable id)safeObjectForKey:(id)aKey;

/**
 *  从JSON字符串创建字典
 *
 *  @param jsonString JSON字符串
 *
 *  @return NSDictionary
 */
+ (instancetype)fromJson:(NSString *)jsonString;

/**
 *  字典转换成Json字符串
 *
 *  @return Json字符串
 */
- (nonnull NSString *)toJson;
- (nonnull NSString *)toCrampedJson;

- (BOOL)contains:(nonnull id)key;

- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def;
- (char)charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)unsignedCharValueForKey:(nonnull NSString *)key default:(unsigned char)def;
- (short)shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;
- (int)intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;
- (long)longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;
- (long long)longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;
- (float)floatValueForKey:(NSString *)key default:(float)def;
- (double)doubleValueForKey:(NSString *)key default:(double)def;
- (NSInteger)integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;
- (NSNumber *)numberValueForKey:(NSString *)key default:(NSNumber *)def;
- (NSString *)stringValueForKey:(NSString *)key default:(NSString *)def;

@end

NS_ASSUME_NONNULL_END
