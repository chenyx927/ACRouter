//
//  UINavigationController+ACAdd.h
//  QualityDevelopment
//
//  Created by creasyma on 2016/12/30.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UINavigationController (ACAdd)

@property (nonatomic, strong, readonly, nullable) UIViewController *rootViewController;

- (nullable UIViewController *)findVC:(Class)vcCls;

- (BOOL)findVCInstance:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(nullable void (^)(void))completion;

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(nullable void (^)(void))completion;

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

@end
NS_ASSUME_NONNULL_END
