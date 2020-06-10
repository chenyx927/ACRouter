//
//  UIView+ACAdd.h
//  izhuanC2C
//
//  Created by 李明伟 on 15/7/8.
//  Copyright (c) 2015年 jingcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShakeDirection) {
    //左右
    ShakeDirectionHorizontal,
    //上下
    ShakeDirectionVertical
};

NS_ASSUME_NONNULL_BEGIN
@interface UIView (ACAdd)

/**
 最左边x坐标
 **/
@property (nonatomic) CGFloat left;
/**
 最上边y坐标
 **/
@property (nonatomic) CGFloat top;
/**
 最右边x坐标
 **/
@property (nonatomic) CGFloat right;
/**
 最下边y坐标
 **/
@property (nonatomic) CGFloat bottom;
/**
 宽度
 **/
@property (nonatomic) CGFloat width;
/**
 高度
 **/
@property (nonatomic) CGFloat height;
/**
 中心x坐标
 **/
@property (nonatomic) CGFloat centerX;
/**
 中心y坐标
 **/
@property (nonatomic) CGFloat centerY;
/**
 起始位置点
 **/
@property (nonatomic) CGPoint origin;
/**
 长宽尺寸
 **/
@property (nonatomic) CGSize  size;

//@property (nonatomic, assign) NSTimeInterval lastClickedEventTime;

/**
 可临时扩大点击区域
 **/
@property (nonatomic) UIEdgeInsets touchExtendInset;

/**
 设置阴影

 @param color   阴影颜色
 @param opacity 阴影透明度
 @param radius  阴影半径
 @param offset  阴影位置偏移量
 */
- (void)layerShadow:(UIColor *)color opacity:(float)opacity radius:(CGFloat)radius offset:(CGSize)offset;

/**
 设置实线边框
 
 @param borderColor 边框颜色
 @param top left righthu bottom 各边边框的粗细
 **/
- (void)solidBorder:(UIColor *)borderColor top:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom;

/**
 获取控制器
 
 @return view的控制器
 **/
- (nullable UIViewController *)viewController;

/**
 移除所有的子视图
 **/
- (void)removeAllSubviews;

/**
 设置点击事件
 */
- (void)clicked:(nonnull void(^)(void))clicked;

/**
 设置双击事件
 */
- (void)doubleClick:(nonnull void(^)(void))doubleClick;

/**
 设置长按事件
 
 @param longPressed  事件处理内容
 */
- (void)longPressed:(nonnull void(^)(UITapGestureRecognizer *gesture))longPressed;

/**
 截屏工具
 **/
- (UIImage *)screenshot;

#pragma mark - 震动
- (void)shake;

- (CGPoint)convertPoint:(CGPoint)point to:(UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point from:(UIView *)view;

#pragma mark - Material Design Animation
- (void)mdInflateAnimatedFromPoint:(CGPoint)point backgroundColor:(UIColor *)backgroundColor duration:(NSTimeInterval)duration completion:(void (^)(void))block;

@end
NS_ASSUME_NONNULL_END
