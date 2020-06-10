//
//  UIApplication+ACAdd.h
//  DMKJ
//
//  Created by zhanggy on 2018/2/28.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ACAdd)

@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuildVersion;
@property (nonatomic, readonly) NSString *appBundleDisplayName;

@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGFloat navigationBarHeight;

/**
 相机权限检测
 **/
+ (BOOL)isAuthAccessCarmera;

/**
 照片权限检测
 **/
+ (BOOL)isAuthAccessPhotos;

+ (UIWindow *)topWindow;

+ (UIViewController *)topController;

+ (void)launchSettings;

@end
