//
//  NSString+ACAdd.m
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import "NSString+ACAdd.h"
#import "RegExCategories.h"
#import <CommonCrypto/CommonCrypto.h>
#include <unicode/utf8.h>

static NSCharacterSet* EmojiSelectors = nil;

@implementation NSString (ACAdd)

+ (void)load {
    EmojiSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
}

- (NSString *)lowercase
{
    return self.lowercaseString;
}

- (NSString *)uppercase
{
    return self.uppercaseString;
}

- (NSString *)md5
{
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    static const char HexEncodeChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    char *resultData = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);
    
    for (uint index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
        resultData[index * 2] = HexEncodeChars[(result[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeChars[(result[index] % 0x10)];
    }
    resultData[CC_MD5_DIGEST_LENGTH * 2] = 0;
    
    NSString *resultString = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    free(resultData);
    
    return resultString;
}

- (NSString *)javaMD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [NSString stringWithString:result].lowercase;
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [resultString appendFormat:@"%02x", digest[i]];
    }
    
    return resultString;
}

- (NSString *)base64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)base64Encode:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)base64Decode:(NSString *)string
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)base64Encode
{
    return [NSString base64Encode:self];
}

- (NSString *)base64Decode
{
    return [NSString base64Decode:self];
}

+ (NSString *)uuid
{
    NSString *result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    
    uuid    = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

+ (NSString *)timestamp
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    return [timeString copy];
}

+ (NSString *)randomString:(NSUInteger)length
{
    NSString *seed = @"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [NSMutableString string];
    
    for (NSInteger i = 0; i < length; i++) {
        [result appendString:[seed substringWithRange:NSMakeRange(arc4random() % seed.length, 1)]];
    }
    
    return result;
}

+ (NSString *)randomStringWithSeed:(NSString *)seed length:(NSUInteger)length
{
    NSMutableString *result = [NSMutableString string];
    
    for (NSInteger i = 0; i < length; i++) {
        [result appendString:[seed substringWithRange:NSMakeRange(arc4random() % seed.length, 1)]];
    }
    
    return result;
}

- (BOOL)equalsIgnoreCase:(NSString *)string
{
    return [self.lowercaseString isEqualToString:string.lowercaseString];
}

- (NSString *)insert:(NSInteger)index string:(NSString *)string
{
    if(index < 0) {
        index = self.length - labs(index) + 1;
    }
    else if (index >= self.length) {
        index = self.length;
    }
    
    return [NSString stringWithFormat:@"%@%@%@",[self substringToIndex:index],string,[self substringFromIndex:index]];
}

- (NSString *)stringReplace:(NSString *)origin with:(NSString *)replacement
{
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

- (unichar)charAt:(NSInteger)index
{
    return [self characterAtIndex:index];
}

- (NSInteger)indexOfChar:(unichar)ch
{
    return [self indexOfChar:ch fromIndex:0];
}

- (NSInteger)indexOfChar:(unichar)ch fromIndex:(NSInteger)index
{
    if (index<0) {
        return -1;
    }
    NSInteger len = self.length;
    
    for (NSInteger i = index; i < len; ++i) {
        if (ch == [self charAt:i]) {
            return i;
        }
    }
    
    return -1;
}

- (NSInteger)indexOfString:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    if (range.location == NSNotFound) {
        return -1;
    }
    
    return range.location;
}

- (NSInteger)indexOfString:(NSString *)string fromIndex:(NSInteger)index
{
    if (index<0) {
        return -1;
    }
    NSRange fromRange = NSMakeRange(index, self.length - index);
    NSRange range = [self rangeOfString:string options:NSLiteralSearch range:fromRange];
    if (range.location == NSNotFound) {
        return -1;
    }
    
    return range.location;
}

- (NSInteger)lastIndexOfChar:(unichar)ch
{
    return [self lastIndexOfChar:ch fromIndex:0];
}

- (NSInteger)lastIndexOfChar:(unichar)ch fromIndex:(NSInteger)index
{
    if (index<0) {
        return -1;
    }
    NSInteger len = self.length;
    
    for (NSInteger i = len-1; i >= index; --i) {
        if (ch == [self charAt:i]) {
            return i;
        }
    }
    
    return -1;
}

- (NSInteger)lastIndexOfString:(NSString *)string
{
    NSRange range = [self rangeOfString:string options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return -1;
    }
    
    return range.location;
}

- (NSInteger)lastIndexOfString:(NSString *)string fromIndex:(NSInteger)index
{
    if (index<0) {
        return -1;
    }
    NSRange fromRange = NSMakeRange(index, self.length - index);
    NSRange range = [self rangeOfString:string options:NSBackwardsSearch range:fromRange];
    if (range.location == NSNotFound) {
        return -1;
    }
    
    return range.location;
}

- (BOOL)contains:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return (range.location != NSNotFound);
}

- (BOOL)startWith:(NSString *)prefix
{
    return [self hasPrefix:prefix];
}

- (BOOL)endWith:(NSString *)suffix
{
    return [self hasSuffix:suffix];
}

- (NSString *)left:(NSInteger)toIndex
{
    return [self substringToIndex:toIndex];
}

- (NSString *)right:(NSInteger)fromIndex
{
    return [self substringFromIndex:fromIndex];
}

- (NSString *)substring:(NSUInteger)fromIndex to:(NSUInteger)toIndex
{
    if (toIndex <= fromIndex) {
        return @"";
    }
    
    NSRange range = NSMakeRange(fromIndex, toIndex - fromIndex);
    return [self substringWithRange:range];
}

- (NSArray<NSString *> *)split:(NSString *)separator
{
    return [self componentsSeparatedByString:separator];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (CGSize)sizeForFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font
{
    return [self sizeForFont:font].width;
}

- (CGFloat)heightForFont:(UIFont *)font
{
    return [self sizeForFont:font].height;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

+ (BOOL)isUnsignedFloat:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isUnsignedFloat];
}

- (BOOL)isUnsignedFloat
{
    Rx* rx = [Rx rx:@"^\\d+(\\.\\d+)?$"];
    return [rx isMatch:self];
}

+ (BOOL)isFloat:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isFloat];
}

- (BOOL)isFloat
{
    Rx* rx = [Rx rx:@"^(-?\\d+)(\\.\\d+)?$"];
    return [rx isMatch:self];
}

+ (BOOL)isUnsignedInteger:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isUnsignedInteger];
}

- (BOOL)isUnsignedInteger
{
    Rx* rx = [Rx rx:@"^\\d+$"];
    return [rx isMatch:self];
}

+ (BOOL)isInteger:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isInteger];
}

- (BOOL)isInteger
{
    Rx* rx = [Rx rx:@"^-?\\d+$"];
    return [rx isMatch:self];
}

+ (BOOL)isLetter:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isLetter];
}

- (BOOL)isLetter
{
    Rx* rx = [Rx rx:@"^[A-Za-z]+$"];
    return [rx isMatch:self];
}

+ (BOOL)isLetterAndDigital:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isLetterAndDigital];
}

- (BOOL)isLetterAndDigital
{
    Rx* rx = [Rx rx:@"^[A-Za-z0-9]+$"];
    return [rx isMatch:self];
}

+ (BOOL)isEmpty:(NSString *)str
{
    if (nil == str) {
        return YES;
    }
    
    return [str isEmpty];
}

+ (BOOL)isNotEmpty:(NSString *)str {
    return ![self isEmpty:str];
}

- (BOOL)isEmpty
{
    if (self) {
        if ([self isKindOfClass:[NSNull class]]) {
            return YES;
        }
        
        if ([self isEqual:[NSNull null]]) {
            return YES;
        }
        
        NSString *trimString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return ([trimString length]==0);
    }
    
    return YES;
}

+ (BOOL)isUrl:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isUrl];
}

- (BOOL)isUrl
{
    // @"(https?|ftp|file)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]"
    NSRegularExpression *regular = [[NSRegularExpression alloc]
                                    initWithPattern:@"((http|ftp|https|file)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
                                    options:NSRegularExpressionCaseInsensitive
                                    error:nil];
    
    NSUInteger numberOfMatches = [regular numberOfMatchesInString:self
                                                          options:NSMatchingAnchored
                                                            range:NSMakeRange(0, self.length)];
    
    return (numberOfMatches > 0);
}

+ (BOOL)isEmail:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isEmail];
}

- (BOOL)isEmail
{
    NSString *emailRegex   = @"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)urlEncode
{
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (CFStringRef) self,
                                                                                  NULL,
                                                                                  (__bridge CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
}

- (NSString *)urlDecode
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                  (__bridge CFStringRef) result,
                                                                                                  CFSTR(""),
                                                                                                  kCFStringEncodingUTF8);
}

- (NSURL *)toURL
{
    NSURL *result = [NSURL URLWithString:self];
    if (!result) {
        result = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (!result) {
        result = [NSURL URLWithString:@""];
    }
    return result;
}

- (nullable NSString *)stringUrlWithParams:(nullable NSString *)params, ... {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    
    va_list argList;
    NSString *param;
    va_start(argList, params);
    
    if ([self rangeOfString:@"?"].location == NSNotFound)
    {
        param = [@"?" stringByAppendingFormat:@"%@&", params];
    } else {
        param = [@"&" stringByAppendingFormat:@"%@&", params];
    }
    
    while (1) {
        id value = va_arg(argList, id);
        if ([value isKindOfClass:[NSString class]]) {
            param = [param stringByAppendingFormat:@"%@&", value];
        }
        if (value == nil) {
            break;
        }
    }
    
    va_end(argList);
    
    return [self stringByAppendingString:[param substringToIndex:param.length - 1]];
}

- (NSURL *)toImageUrlWithSize:(CGSize)size {
    NSURL *url = [self toURL];
    NSString *scheme = url.scheme.lowercaseString;
    if (([scheme isEqualToString:@"https"] || [scheme isEqualToString:@"http"])
        && ([url.host.lowercaseString isEqualToString:@"img.aiyoumi.com"])
        && !CGSizeEqualToSize(size, CGSizeZero))
    {
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        for (NSURLQueryItem *itm in [components queryItems]) {
            if ([itm.name isEqualToString:@"x-oss-process"]) {
                return url;
            }
        }
        //不考虑3x效果，肉眼很难识别3x与2x，故统一使用2x图片
        NSString *s = [NSString stringWithFormat:@"%@%@x-oss-process=image/resize,m_lfit,h_%d,w_%d/format,webp",
                       self,
                       ((url.query == nil) ? @"?" : @"&"),
                       (int)ceil(size.height*2),
                       (int)ceil(size.width*2)];
        
        return [s toURL];
    }
    return url;
}

- (NSDictionary *)cookieMap{
    NSMutableDictionary *cookieMap = [NSMutableDictionary dictionary];
    
    NSArray *cookieKeyValueStrings = [self componentsSeparatedByString:@";"];
    for (NSString *cookieKeyValueString in cookieKeyValueStrings) {
        //找出第一个"="号的位置
        NSRange separatorRange = [cookieKeyValueString rangeOfString:@"="];
        
        if (separatorRange.location != NSNotFound &&
            separatorRange.location > 0 &&
            separatorRange.location < ([cookieKeyValueString length] - 1)) {
            //以上条件确保"="前后都有内容，不至于key或者value为空
            
            NSRange keyRange = NSMakeRange(0, separatorRange.location);
            NSString *key = [cookieKeyValueString substringWithRange:keyRange];
            NSString *value = [cookieKeyValueString substringFromIndex:separatorRange.location + separatorRange.length];
            
            key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cookieMap[key] = value;
            
        }
    }
    return cookieMap;
}

- (NSDictionary *)cookieProperties{
    NSDictionary *cookieMap = [self cookieMap];
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    for (NSString *key in [cookieMap allKeys]) {
        
        NSString *value = cookieMap[key];
        NSString *uppercaseKey = [key uppercaseString];//主要是排除命名不规范的问题
        
        if ([uppercaseKey isEqualToString:@"DOMAIN"]) {
            if (![value hasPrefix:@"."] && ![value hasPrefix:@"www"]) {
                value = [NSString stringWithFormat:@".%@",value];
            }
            cookieProperties[NSHTTPCookieDomain] = value;
        }else if ([uppercaseKey isEqualToString:@"VERSION"]) {
            cookieProperties[NSHTTPCookieVersion] = value;
        }else if ([uppercaseKey isEqualToString:@"MAX-AGE"]||[uppercaseKey isEqualToString:@"MAXAGE"]) {
            cookieProperties[NSHTTPCookieMaximumAge] = value;
        }else if ([uppercaseKey isEqualToString:@"PATH"]) {
            cookieProperties[NSHTTPCookiePath] = value;
        }else if([uppercaseKey isEqualToString:@"ORIGINURL"]){
            cookieProperties[NSHTTPCookieOriginURL] = value;
        }else if([uppercaseKey isEqualToString:@"PORT"]){
            cookieProperties[NSHTTPCookiePort] = value;
        }else if([uppercaseKey isEqualToString:@"SECURE"]||[uppercaseKey isEqualToString:@"ISSECURE"]){
            cookieProperties[NSHTTPCookieSecure] = value;
        }else if([uppercaseKey isEqualToString:@"COMMENT"]){
            cookieProperties[NSHTTPCookieComment] = value;
        }else if([uppercaseKey isEqualToString:@"COMMENTURL"]){
            cookieProperties[NSHTTPCookieCommentURL] = value;
        }else if([uppercaseKey isEqualToString:@"EXPIRES"]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            dateFormatter.dateFormat = @"EEE, dd-MMM-yyyy HH:mm:ss zzz";
            cookieProperties[NSHTTPCookieExpires] = [dateFormatter dateFromString:value];
        }else if([uppercaseKey isEqualToString:@"DISCART"]){
            cookieProperties[NSHTTPCookieDiscard] = value;
        }else if([uppercaseKey isEqualToString:@"NAME"]){
            cookieProperties[NSHTTPCookieName] = value;
        }else if([uppercaseKey isEqualToString:@"VALUE"]){
            cookieProperties[NSHTTPCookieValue] = value;
        }else{
            cookieProperties[NSHTTPCookieName] = key;
            cookieProperties[NSHTTPCookieValue] = value;
        }
    }
    
    //由于cookieWithProperties:方法properties中不能没有NSHTTPCookiePath，所以这边需要确认下，如果没有则默认为@"/"
    if (!cookieProperties[NSHTTPCookiePath]) {
        cookieProperties[NSHTTPCookiePath] = @"/";
    }
    return cookieProperties;
}

- (nonnull NSHTTPCookie *)toCookie
{
    NSDictionary *cookieProperties = [self cookieProperties];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return cookie;
}

- (NSAttributedString *)toAttributedStringWithFont:(UIFont *)defaultFont textAlignment:(NSTextAlignment)textAlignment
{
    if ([NSString isEmpty:self]) {
        return nil;
    }
    if (!defaultFont) {
        defaultFont = [UIFont systemFontOfSize:14];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, attrStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:textAlignment];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}

- (double)toDouble
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    double Double = 0;
    if ([scanner scanDouble:&Double]) {
        return Double;
    }
    
    return 0;
}

- (float)toFloat
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float Float = 0;
    if ([scanner scanFloat:&Float]) {
        return Float;
    }
    
    return 0;
}

- (BOOL)idAreaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    return ([dic objectForKey:code] != nil);
}

- (BOOL)isIdCard
{
    //判断位数
    if ([self length]!= 18 && [self length] != 15) {
        return NO;
    }
    
    //change x to X
    NSString *tmpID  = self.uppercaseString;
    NSString *cardID = tmpID;
    
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:tmpID];
    if ([tmpID length] == 15) {
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        cardID = mString;
    }
    
    //判断地区码
    NSString * sProvince = [cardID substringToIndex:2];
    if (![self idAreaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[cardID substring:6 to:10] intValue];
    //月份
    int strMonth = [[cardID substring:10 to:12] intValue];
    //日
    int strDay = [[cardID substring:12 to:14] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]  ;
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    
    const char *charID  = [cardID UTF8String];
    
    //检验长度
    if( 18 != strlen(charID)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(charID[i]) && !(('X' == charID[i] || 'x' == charID[i]) && 17 == i) )
        {
            return NO;
        }
    }
    
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (charID[i]-48) * R[i];
    }
    
    if (sChecker[lSumQT%11] != charID[17] )
    {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isIdCard:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isIdCard];
}

- (BOOL)isEmoji
{
    if ([self rangeOfCharacterFromSet: EmojiSelectors].location != NSNotFound) {
        return YES;
    }
    
    const unichar high = [self characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27BF);
    }
}

- (BOOL)isIncludingEmoji
{
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

- (NSString *)stringByRemovingEmoji
{
    NSData *d = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if(!d) return nil;
    const char *buf = d.bytes;
    unsigned int len = (unsigned int)[d length];
    char *s = (char *)malloc(len);
    unsigned int ii = 0, oi = 0; // in index, out index
    UChar32 uc;
    while (ii < len) {
        U8_NEXT_UNSAFE(buf, ii, uc);
        if(0x2100 <= uc && uc <= 0x26ff) continue;
        if(0x1d000 <= uc && uc <= 0x1f77f) continue;
        U8_APPEND_UNSAFE(s, oi, uc);
    }
    return [[NSString alloc] initWithBytesNoCopy:s length:oi encoding:NSUTF8StringEncoding freeWhenDone:YES];
}

- (NSString *)getDigitsOnly:(NSString *)str
{
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < str.length; i++) {
        c = [str characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    return digitsOnly;
}

//检查银行卡是否合法(Luhn算法)
- (BOOL)isBankCard
{
    NSString *digitsOnly = [self getDigitsOnly:self];
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = NO;
    
    for (int i = (int)digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        
        sum += addend;
        timesTwo = !timesTwo;
    }
    
    int modulus = sum % 10;
    return modulus == 0;
}

+ (BOOL)isBankCard:(NSString *)str
{
    if (nil == str) {
        return NO;
    }
    
    return [str isBankCard];
}

#pragma mark - Format
+ (NSString *)formatReviewPhoneNumber:(NSString *)number {
    if (number.length<=3) {
        return number;
    }
    NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc] initWithPattern:@"^0?(13[0-9]|15[0123456789]|18[0123456789]|17[0123456789]|14[57])"
                                                                                     options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:number options:NSMatchingAnchored
                                                                          range:NSMakeRange(0, number.length)];
    
    if (numberofMatchURL == 0) {
        return number;
    }
    
    if ((number.length>3) && (number.length<=7)) {
        NSMutableString *string = [NSMutableString stringWithString:number];
        [string insertString:@" " atIndex:3];
        return string;
    } else if (number.length > 7) {
        NSMutableString *string = [NSMutableString stringWithString:number];
        [string insertString:@" " atIndex:3];
        [string insertString:@" " atIndex:8];
        return string;
    }
    return  number;
}

- (NSString *)trimming {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - Encode and decode

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}



#pragma mark - Check
- (BOOL)isInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isTelePhoneNumber {
    NSString *regex = @"^0?(13[0-9]|14[0-9]|15[0-9]|16[0-9]|17[0-9]|18[0-9]|19[0-9])[0-9]{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    
    if (!isMatch)
        return NO;
    return YES;
}

- (BOOL)validateNumber {
    NSString *number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}

+ (BOOL)isEmpty:(NSString *)str removeWhitespaceAndNewline:(BOOL)remove {
    if (nil == str) {
        return YES;
    }
    
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (remove) {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return ([trimedString length] == 0);
        
    } else {
        return ([str length] == 0);
    }
}

#pragma mark - Match
+ (BOOL)checkWithRegularStr:(NSString *)string regularStr:(NSString *)regular {
    NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc] initWithPattern:regular
                                                                                     options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:string options:NSMatchingAnchored
                                                                          range:NSMakeRange(0, string.length)];
    return (numberofMatchURL > 0);
}

- (nonnull NSArray *)matchUrlRegexArray {
    NSError *error;
    NSString *regulaStr = @"((http{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *array = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return array;
}

@end
