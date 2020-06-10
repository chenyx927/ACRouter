//
//  UILabel+ACAdd.h
//  DMKJ
//
//  Created by zhanggy on 2018/2/2.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ACAdd)
/**
 *  标签创建
 *
 *  @param text       文案
 *  @param frame      区域
 *  @param font       字体
 *  @param color      颜色
 *
 *  @return 返回标签实例
 */
+ (UILabel*)labelWithTxt:(NSString *)text frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;

+ (UILabel*)labelWithConerRadius:(CGFloat)radius text:(NSString *)text frame:(CGRect)frame font:(UIFont*)font
                           color:(UIColor*)color bgColor:(UIColor *)bgColor;

/**
 *  创建label
 *
 *  @param text  文案
 *  @param font  字体
 *  @param color 字体颜色
 */
+ (UILabel*)labelWithTxt:(NSString *)text font:(UIFont*)font color:(UIColor*)color;

/**
 获取label每行内容
 */
- (NSArray *)getSeparatedLinesFromLabel;

/**
 *  设置行间距（目前只支持全部内容，部分带行间距的不支持）
 *
 *  @param lineSpacing 行间距
 */
- (void)setLineSpacing:(NSUInteger)lineSpacing;

#pragma mark - jump number
@property (nonatomic, readonly, getter= isAnimating) BOOL animating;

/**
 *  设置带格式的数字跳动动画可设置动画时间
 *
 *  @param number    number值
 *  @param duration  动画时间
 *  @param formatter 格式
 */
- (void)setNumberWithJumpAnimation:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter;

/**
 设置带格式的数字跳动动画可设置动画时间
 
 @param number number值
 @param duration 动画时间
 @param formatStr 格式字符串
 @param formatter 格式
 @param attrs attributes属性
 */
- (void)setNumberWithJumpAnimation:(NSNumber *)number
                          duration:(NSTimeInterval)duration
                            format:(NSString *)formatStr
                   numberFormatter:(NSNumberFormatter *)formatter
                        attributes:(id)attrs;
@end
