//
//  NSArray+ACAdd.m
//  achr
//
//  Created by Ken.Liu on 16/6/30.
//  Copyright © 2016年 Hangzhou Ai Cai Network Technology Co., Ltd. All rights reserved.
//

#import "NSArray+ACAdd.h"

@implementation NSArray (ACAdd)

- (NSString *)toJson {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            return error.localizedDescription;
        }
        else {
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return json;
        }
    }
    
    return @"[]";
}

+ (instancetype)fromJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    if(err) {
        array = [NSArray array];
    }
    
    return array;
}

- (NSMutableArray *)randomItems:(NSUInteger)count
{
    NSMutableArray *source = [self mutableCopy];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger iRandom = (arc4random() % (source.count - i));
        [result addObject:source[iRandom]];
        source[iRandom] = source[source.count - i - 1];
    }
    
    return result;
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end
