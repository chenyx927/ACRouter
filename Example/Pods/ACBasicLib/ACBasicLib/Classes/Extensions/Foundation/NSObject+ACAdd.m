//
//  NSObject+ACAdd.m
//  QualityDevelopment
//
//  Created by creasyma on 16/1/18.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import "NSObject+ACAdd.h"
#import <objc/runtime.h>

@implementation NSObject (ACAdd)

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (BOOL)isNotEmpty:(id)obj {
    if (!obj || [obj isKindOfClass:[NSNull class]] ||
        ([obj isKindOfClass:[NSString class]] && ([obj isEqualToString:@""] ||
                                                  [obj isEqualToString:@"(null)"] ||
                                                  [(NSString *)obj length] < 1))) {
        return NO;
    }
    return YES;
}

+ (BOOL)isEmpty:(id)obj {
    return ![self isNotEmpty:obj];
}
@end
