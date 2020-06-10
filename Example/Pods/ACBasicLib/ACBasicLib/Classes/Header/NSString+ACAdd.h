//
//  NSString+ACAdd.h
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ACAdd)

@property (nonatomic, readonly) NSString *lowercase;
@property (nonatomic, readonly) NSString *uppercase;
@property (nonatomic, readonly) NSString *md5;
@property (nonatomic, readonly) NSString *javaMD5;
@property (nonatomic, readonly) NSString *sha1;
@property (nonatomic, readonly) NSString *base64;

#pragma mark - Format
// 格式化手机号:    18212341234 -> 182 1234 1234
+ (NSString *)formatReviewPhoneNumber:(NSString *)number;

/**
 去除尾部的空格/换行 去除所有的空格:
 "123 456 \n" -> "123456"
 */
- (NSString *)trimming;

#pragma mark - Encode and decode
// URL 编解码
- (NSString *)stringByURLEncode;
- (NSString *)stringByURLDecode;

#pragma mark - Check
- (BOOL)isInt;
- (BOOL)isTelePhoneNumber;
- (BOOL)validateNumber;

#pragma mark - Match
// 返回字符串中符合URL的数组
- (nonnull NSArray *)matchUrlRegexArray;
+ (BOOL)checkWithRegularStr:(NSString *)string regularStr:(NSString *)regular;

#pragma mark - Base64
+ (NSString *)base64Encode:(NSString *)string;
+ (NSString *)base64Decode:(NSString *)string;
- (NSString *)base64Encode;
- (NSString *)base64Decode;

#pragma mark - UUID 和 时间戳
+ (NSString *)uuid;
+ (NSString *)timestamp;

#pragma mark - 随机字符串
+ (NSString *)randomString:(NSUInteger)length;
+ (NSString *)randomStringWithSeed:(NSString *)seed length:(NSUInteger)length;

#pragma mark - 字符串比较
- (BOOL)equalsIgnoreCase:(NSString *)string;

#pragma mark - trim/insert/replace/split/repeat
- (NSString *)trim;
- (NSString *)insert:(NSInteger)index string:(NSString *)string;
- (NSString *)stringReplace:(NSString *)origin with:(NSString *)replacement;
- (NSArray<NSString *> *)split:(NSString *)separator;

#pragma mark - 查找字符或字符串
- (unichar)charAt:(NSInteger)index;

- (NSInteger)indexOfChar:(unichar)ch;
- (NSInteger)indexOfChar:(unichar)ch fromIndex:(NSInteger)index;
- (NSInteger)indexOfString:(NSString *)string;
- (NSInteger)indexOfString:(NSString *)string fromIndex:(NSInteger)index;
- (NSInteger)lastIndexOfChar:(unichar)ch;
- (NSInteger)lastIndexOfChar:(unichar)ch fromIndex:(NSInteger)index;
- (NSInteger)lastIndexOfString:(NSString *)string;
- (NSInteger)lastIndexOfString:(NSString *)string fromIndex:(NSInteger)index;

#pragma mark - 是否包含,是否以其开始,是否以其结束
- (BOOL)contains:(NSString *)string;
- (BOOL)startWith:(NSString *)prefix;
- (BOOL)endWith:(NSString *)suffix;

#pragma mark - 字符串截取
- (NSString *)substring:(NSUInteger)fromIndex to:(NSUInteger)toIndex;

- (NSString *)left:(NSInteger)toIndex;
- (NSString *)right:(NSInteger)fromIndex;

#pragma mark - 根据字体计算宽高
- (CGSize)sizeForFont:(UIFont *)font;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

#pragma mark - 是否为空包含nil/NSNull
+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isNotEmpty:(NSString *)str;
#pragma mark - 是否为整形数值(可包含负号-)
+ (BOOL)isInteger:(NSString *)str;
#pragma mark - 是否为无符号整形数值
+ (BOOL)isUnsignedInteger:(NSString *)str;
#pragma mark - 是否为浮点型数值(可包含小数点,可包含负号-)
+ (BOOL)isFloat:(NSString *)str;
#pragma mark - 是否为浮点型数值(可包含小数点)
+ (BOOL)isUnsignedFloat:(NSString *)str;
#pragma mark - 是否为全英文字母
+ (BOOL)isLetter:(NSString *)str;
#pragma mark - 是否为英文字母+数字
+ (BOOL)isLetterAndDigital:(NSString *)str;
#pragma mark - 是否为URL链接
+ (BOOL)isUrl:(NSString *)str;
#pragma mark - 是否为Email
+ (BOOL)isEmail:(NSString *)str;
#pragma mark - 是否为身份证号
+ (BOOL)isIdCard:(NSString *)str;
#pragma mark - 是否为银行卡号
+ (BOOL)isBankCard:(NSString *)str;

#pragma mark - URL编解码
- (NSString *)urlEncode;
- (NSString *)urlDecode;

#pragma mark - 转为 NSURL
- (nonnull NSURL *)toURL;
- (nullable NSString *)stringUrlWithParams:(nullable NSString *)params, ...;

#pragma mark - 根据size转换图片的URL
- (NSURL *)toImageUrlWithSize:(CGSize)size;

#pragma mark - 转为 NSHTTPCookie
- (nonnull NSHTTPCookie *)toCookie;
#pragma mark - 转为 NSAttributedString
- (nonnull NSAttributedString *)toAttributedStringWithFont:(nullable UIFont *)defaultFont textAlignment:(NSTextAlignment)textAlignment;

#pragma mark - 转为浮点型
- (double)toDouble;
- (float)toFloat;

#pragma mark - 表情符号
- (BOOL)isIncludingEmoji;
- (NSString *)stringByRemovingEmoji;

@end

NS_ASSUME_NONNULL_END
