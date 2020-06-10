//
//  UIDevice+ACAdd.h
//  DMKJ
//
//  Created by zhanggy on 2018/2/28.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ACAdd)

/**
 *  iOS 版本号
 */
@property (nonatomic, readonly) float iOSVer;
/**
 *  当前设备描述字符串
 */
@property (nonatomic, readonly) NSString *currentDeviceModelDescription;
/**
 *  设备型号 如 "iPhone6,1" "iPad4,6"
 */
@property (nonatomic, readonly) NSString *machineModel;
/**
 *  设备型号 如 "iPhone 5s" "iPad mini 2"
 */
@property (nonatomic, readonly) NSString *machineModelName;
/**
 *  屏幕实际分辨率 如 "750-1334"
 */
@property (nonatomic, readonly) NSString *screenResolution;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)statusBarHeight;
+ (CGFloat)naviBarHeight;
+ (CGFloat)naviBarAddStatusBarHeight;
+ (CGFloat)tabBarHeight;
+ (CGFloat)xBottomBarHeight;
+ (CGFloat)uiHorizontalScale;
+ (CGFloat)lineHeight;

+ (BOOL)isIPhone4;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6P;
+ (BOOL)isIPhoneX;

+ (NSString *)macAddress;
+ (NSString *)IDFA;
+ (NSString *)IDFV;
+ (NSString *)countryCode;
+ (NSString *)languageCode;
+ (NSString *)systemBootTime;
+ (NSString *)systemFileTime;
+ (NSString *)carrierInfo;
+ (NSString *)hardwareInfo;

@end
