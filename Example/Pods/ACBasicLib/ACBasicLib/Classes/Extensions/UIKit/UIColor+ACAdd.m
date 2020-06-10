//
// Created by 徐鹏 on 15/11/24.
// Copyright (c) 2015 徐鹏. All rights reserved.
//

#import "UIColor+ACAdd.h"

@implementation UIColor (ACAdd)

+ (nonnull instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    CGFloat red            = 0;
    CGFloat green          = 0;
    CGFloat blue           = 0;
    CGFloat mAlpha         = alpha;
    NSUInteger minusLength = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString hasPrefix:@"#"]) {
        scanner.scanLocation = 1;
        minusLength          = 1;
    }

    if ([hexString hasPrefix:@"0x"]) {
        scanner.scanLocation = 2;
        minusLength          = 2;
    }

    UInt64 hexValue = 0;
    [scanner scanHexLongLong:&hexValue];
    switch (hexString.length - minusLength) {
        case 3: {
            red   = (CGFloat)((hexValue & 0xF00) >> 8) / 15.0;
            green = (CGFloat)((hexValue & 0x0F0) >> 4) / 15.0;
            blue  = (CGFloat)(hexValue & 0x00F) / 15.0;

            break;
        }
        case 4: {
            red    = (CGFloat)((hexValue & 0xF000) >> 12) / 15.0;
            green  = (CGFloat)((hexValue & 0x0F00) >> 8) / 15.0;
            blue   = (CGFloat)((hexValue & 0x00F0) >> 4) / 15.0;
            mAlpha = (CGFloat)(hexValue & 0x00F) / 15.0;

            break;
        }
        case 6: {
            red    = (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0;
            green  = (CGFloat)((hexValue & 0x00FF00) >> 8) / 255.0;
            blue   = (CGFloat)(hexValue & 0x0000FF) / 255.0;

            break;
        }
        case 8: {
            red    = (CGFloat)((hexValue & 0xFF000000) >> 24) / 255.0;
            green  = (CGFloat)((hexValue & 0x00FF0000) >> 16) / 255.0;
            blue   = (CGFloat)((hexValue & 0x0000FF00) >> 8) / 255.0;
            mAlpha = (CGFloat)(hexValue & 0x000000FF) / 255.0;

            break;
        }
        default:
            break;
    }

    return [self colorWithRed:red green:green blue:blue alpha:mAlpha];
}

+ (nonnull instancetype)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (nonnull instancetype)colorWithHexValue:(int)hexInt alpha:(CGFloat)alpha
{
    NSString *hexString = [NSString stringWithFormat:@"%0X", hexInt];
    if (hexInt <= 0xfff) {
        hexString = [NSString stringWithFormat:@"%03X", hexInt];
    }
    else if (hexInt <= 0xffff) {
        hexString = [NSString stringWithFormat:@"%04X", hexInt];
    }
    else if (hexInt <= 0xffffff) {
        hexString = [NSString stringWithFormat:@"%06X", hexInt];
    }

    return [self colorWithHexString:hexString alpha:alpha];
}

+ (nonnull instancetype)colorWithHexValue:(int)hexInt
{
    return [self colorWithHexValue:hexInt alpha:1.0];
}

+ (nonnull instancetype)colorWithR255:(int)r255 G255:(int)g255 B255:(int)b255
{
    return [self colorWithRed:(CGFloat)r255/255.0 green:(CGFloat)g255/255.0 blue:(CGFloat)b255/255.0 alpha:1.0];
}

+ (nonnull instancetype)colorWithRandom
{
    static BOOL seeded = NO;
    if(!seeded) {
        seeded = YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (UInt32)toHex
{
    return (UInt32)(lround((double)(self.red * 255.0))) << 16 | (UInt32)(lround((double)(self.green * 255.0))) << 8 | (UInt32)(lround((double)(self.blue * 255.0)));
}

- (NSString *)toHexString
{
    return [NSString stringWithFormat:@"#%06x", (unsigned int)[self toHex]];
}

- (CGFloat)red
{
    CGFloat red   = 0;
    CGFloat green = 0;
    CGFloat blue  = 0;
    CGFloat alpha = 0;

    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return red;
    }

    return 0;
}

- (CGFloat)green
{
    CGFloat red   = 0;
    CGFloat green = 0;
    CGFloat blue  = 0;
    CGFloat alpha = 0;

    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return green;
    }

    return 0;
}

- (CGFloat)blue
{
    CGFloat red   = 0;
    CGFloat green = 0;
    CGFloat blue  = 0;
    CGFloat alpha = 0;

    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return blue;
    }

    return 0;
}

- (CGFloat)alpha
{
    CGFloat red   = 0;
    CGFloat green = 0;
    CGFloat blue  = 0;
    CGFloat alpha = 0;

    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return alpha;
    }

    return 0;
}

@end
