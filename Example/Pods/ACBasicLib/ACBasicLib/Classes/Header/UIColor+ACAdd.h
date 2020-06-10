//
// Created by 徐鹏 on 15/11/24.
// Copyright (c) 2015 徐鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ACAdd)

@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;
@property (nonatomic, assign, readonly) CGFloat alpha;

+ (nonnull instancetype)colorWithHexString:(nonnull NSString *)hexString;
+ (nonnull instancetype)colorWithHexString:(nonnull NSString *)hexString alpha:(CGFloat)alpha;
+ (nonnull instancetype)colorWithHexValue:(int)hexInt;
+ (nonnull instancetype)colorWithHexValue:(int)hexInt alpha:(CGFloat)alpha;

+ (nonnull instancetype)colorWithR255:(int)r255 G255:(int)g255 B255:(int)b255;

+ (nonnull instancetype)colorWithRandom;

- (UInt32)toHex;
- (nonnull NSString *)toHexString;

@end
