//
//  UILabel+ACAdd.m
//  DMKJ
//
//  Created by zhanggy on 2018/2/2.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import "UILabel+ACAdd.h"
#import <CoreText/CoreText.h>

#import <objc/runtime.h>

#define RangeIntegerKey @"RangeKey"
#define MultipleKey @"MultipleKey"
#define BeginNumberKey @"BeginNumberKey"
#define EndNumberKey @"EndNumberKey"
#define ResultNumberKey @"ResultNumberKey"

#define AttributeKey @"AttributeKey"
#define FormatKey @"FormatStringKey"

#define Frequency 1.0/30.0f

#define DictArrtributeKey @"attribute"
#define DictRangeKey @"range"

static char JumpNumberKey;
static char JumpNumberFormatterKey;
static char JumpNumberTimerKey;

@interface UILabel ()

@property (nonatomic, strong) NSNumber *JumpNumber;
@property (nonatomic, strong) NSNumberFormatter *JumpNumberFormatter;
@property (nonatomic) NSTimer *timer;

@end

@implementation UILabel (ACAdd)
+ (UILabel*)labelWithTxt:(NSString *)text frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color {
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    if (color) {
        label.textColor = color;
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    return label;
}

+ (UILabel*)labelWithTxt:(NSString *)text font:(UIFont*)font color:(UIColor*)color {
    UILabel* label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (NSArray *)getSeparatedLinesFromLabel {
    NSString *text = [self text];
    UIFont   *font = [self font];
    CGRect    rect = [self frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    if (myFont) {
        CFRelease(myFont);
    }
    
    if (frameSetter) {
        CFRelease(frameSetter);
    }
    
    if (path) {
        CGPathRelease(path);
    }
    
    if (frame) {
        CFRelease(frame);
    }
    return linesArray;
}

+ (UILabel*)labelWithConerRadius:(CGFloat)radius text:(NSString *)text
                           frame:(CGRect)frame font:(UIFont*)font
                           color:(UIColor*)color bgColor:(UIColor *)bgColor {
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (color) {
        label.textColor = color;
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    if (bgColor) {
        label.backgroundColor = bgColor;
    } else {
        label.backgroundColor = [UIColor clearColor];
    }
    
    label.layer.cornerRadius = radius;
    label.layer.masksToBounds = YES;
    
    return label;
}

- (void)setLineSpacing:(NSUInteger)lineSpacing {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
}

#pragma mark - jump number
- (BOOL)isAnimating {
    return  [self.timer isValid];
}

- (void)setNumberWithJumpAnimation:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter {
    if(!formatter)
        formatter = [self defaultFormatter];
    [self setNumberWithJumpAnimation:number duration:duration format:nil numberFormatter:formatter attributes:nil];
}

- (void)setNumberWithJumpAnimation:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr
                   numberFormatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    NSAssert([number isKindOfClass:[NSNumber class]], @"需要 NSNumber 类型");
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userInfo setObject:number forKey:ResultNumberKey];
    
    int beginNumber = 0;
    [userInfo setObject:@(beginNumber) forKey:BeginNumberKey];
    self.JumpNumber = @(0);
    int endNumber = 0;
    
    int multiple = [self multipleForNumber:number];
    endNumber = multiple > 0 ? [number floatValue] * multiple : [number intValue];
    [userInfo setObject:@(multiple) forKey:MultipleKey];
    [userInfo setObject:@(endNumber) forKey:EndNumberKey];
    [userInfo setObject:@((endNumber * Frequency)/duration) forKey:RangeIntegerKey];
    
    if(attrs)
        [userInfo setObject:attrs forKey:AttributeKey];
    
    self.JumpNumberFormatter = nil;
    if(formatter)
        self.JumpNumberFormatter = formatter;
    
    if(formatStr)
        [userInfo setObject:formatStr forKey:FormatKey];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:Frequency target:self selector:@selector(flickerAnimation:) userInfo:userInfo repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, &JumpNumberTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimer *)timer{
    return objc_getAssociatedObject(self, &JumpNumberTimerKey);
}
- (void)setJumpNumber:(NSNumber *)JumpNumber{
    objc_setAssociatedObject(self, &JumpNumberKey, JumpNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)JumpNumber{
    return objc_getAssociatedObject(self, &JumpNumberKey);
}

- (void)setJumpNumberFormatter:(NSNumberFormatter *)JumpNumberFormatter{
    objc_setAssociatedObject(self, &JumpNumberFormatterKey, JumpNumberFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumberFormatter *)JumpNumberFormatter{
    return objc_getAssociatedObject(self, &JumpNumberFormatterKey);
}

- (void)flickerAnimation:(NSTimer *)timer{
    float rangeInteger = [timer.userInfo[RangeIntegerKey] floatValue];
    self.JumpNumber = @([self.JumpNumber floatValue] + rangeInteger);
    
    int multiple = [timer.userInfo[MultipleKey] intValue];
    if(multiple > 0){
        [self floatNumberHandler:timer andMultiple:multiple];
        return;
    }
    
    NSString *formatStr = timer.userInfo[FormatKey]?:(self.JumpNumberFormatter?@"%@":@"%.0f");
    self.text = [self finalString:@([self.JumpNumber integerValue]) stringFormat:formatStr andFormatter:self.JumpNumberFormatter];
    
    if(timer.userInfo[AttributeKey]){
        [self attributedHandler:timer.userInfo[AttributeKey]];
    }
    
    if([self.JumpNumber intValue] >= [timer.userInfo[EndNumberKey] intValue]){
        self.text = [self finalString:timer.userInfo[ResultNumberKey] stringFormat:formatStr andFormatter:self.JumpNumberFormatter];
        if(timer.userInfo[AttributeKey]){
            [self attributedHandler:timer.userInfo[AttributeKey]];
        }
        [timer invalidate];
    }
}

- (void)floatNumberHandler:(NSTimer *)timer andMultiple:(int)multiple{
    NSString *formatStr = timer.userInfo[FormatKey]?:(self.JumpNumberFormatter?@"%@":[NSString stringWithFormat:@"%%.%df",(int)log10(multiple)]);
    self.text = [self finalString:@([self.JumpNumber floatValue]/multiple) stringFormat:formatStr andFormatter:self.JumpNumberFormatter];
    if(timer.userInfo[AttributeKey]){
        [self attributedHandler:timer.userInfo[AttributeKey]];
    }
    if([self.JumpNumber intValue] >= [timer.userInfo[EndNumberKey] intValue]){
        self.text = [self finalString:timer.userInfo[ResultNumberKey] stringFormat:formatStr andFormatter:self.JumpNumberFormatter];
        if(timer.userInfo[AttributeKey]){
            [self attributedHandler:timer.userInfo[AttributeKey]];
        }
        [timer invalidate];
    }
}

- (void)attributedHandler:(id)attributes{
    if([attributes isKindOfClass:[NSDictionary class]]){
        NSRange range = [attributes[DictRangeKey] rangeValue];
        [self addAttributes:attributes[DictArrtributeKey] range:range];
    }else if([attributes isKindOfClass:[NSArray class]]){
        for (NSDictionary *attribute in attributes) {
            NSRange range = [attribute[DictRangeKey] rangeValue];
            [self addAttributes:attribute[DictArrtributeKey] range:range];
        }
    }
}

- (void)addAttributes:(NSDictionary *)attri range:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if(range.location+range.length <= str.length){
        [str addAttributes:attri range:range];
    }
    self.attributedText = str;
}

- (int)multipleForNumber:(NSNumber *)number{
    CGFloat floatValue = [number floatValue];
    NSString *str = [NSString stringWithFormat:@"%.2f",floatValue];
    if([str rangeOfString:@"."].location != NSNotFound){
        NSUInteger length = [[str substringFromIndex:[str rangeOfString:@"."].location +1] length];
        return  length >= 6 ? pow(10, 6): pow(10, (int)length) ;
    }
    return 0;
}

- (NSString *)stringFromNumber:(NSNumber *)number numberFormatter:(NSNumberFormatter *)formattor{
    if(!formattor){
        formattor = [[NSNumberFormatter alloc] init];
        formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
        formattor.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formattor stringFromNumber:number];
}

- (NSString *)finalString:(NSNumber *)number stringFormat:(NSString *)formatStr andFormatter:(NSNumberFormatter *)formatter{
    NSString *finalString = nil;
    if(formatter){
        finalString = [NSString stringWithFormat:formatStr,[self stringFromNumber:number numberFormatter:formatter]];
    }else{
        NSAssert([formatStr rangeOfString:@"%@"].location == NSNotFound, @"string format type is not matched,please check your format type");
        finalString = [NSString stringWithFormat:formatStr,[number floatValue]];
    }
    return finalString;
}

- (NSNumberFormatter *)defaultFormatter{
    NSNumberFormatter *formattor = [[NSNumberFormatter alloc] init];
    formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
    formattor.numberStyle = NSNumberFormatterDecimalStyle;
    return formattor;
}

@end
