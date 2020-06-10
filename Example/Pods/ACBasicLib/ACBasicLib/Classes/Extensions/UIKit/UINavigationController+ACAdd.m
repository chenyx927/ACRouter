//
//  UINavigationController+ACAdd.m
//  QualityDevelopment
//
//  Created by creasyma on 2016/12/30.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import "UINavigationController+ACAdd.h"

@implementation UINavigationController (ACAdd)

- (UIViewController *)rootViewController
{
    if (self.viewControllers.count>0) {
        return self.viewControllers.firstObject;
    }
    
    return nil;
}

- (nullable UIViewController *)findVC:(Class)vcCls
{
    UIViewController *targetVC = nil;
    if (self.viewControllers.count > 0) {
        for (UIViewController *item in self.viewControllers) {
            if ([item isMemberOfClass:vcCls]) {
                targetVC = item;
                break;
            }
        }
    }
    
    return targetVC;
}

- (BOOL)findVCInstance:(UIViewController *)viewController
{
    BOOL result = NO;
    if (self.viewControllers.count > 0) {
        for (UIViewController *item in self.viewControllers) {
            if ([item isEqual:viewController]) {
                result = YES;
                break;
            }
        }
    }
    
    return result;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        [CATransaction setCompletionBlock:completion];
        [CATransaction begin];
        [self pushViewController:viewController animated:animated];
        [CATransaction commit];
    }else {
        if (completion) {
            completion();
        }
        
        [self pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        UIViewController *result = nil;
        
        [CATransaction setCompletionBlock:completion];
        [CATransaction begin];
        result = [self popViewControllerAnimated:animated];
        [CATransaction commit];
        
        return result;
    }else {
        if (completion) {
            completion();
        }
        
        return [self popViewControllerAnimated:animated];
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(nullable void (^)(void))completion
{
    if (animated) {
        NSArray<UIViewController*> *result = nil;
        
        [CATransaction setCompletionBlock:completion];
        [CATransaction begin];
        result = [self popToViewController:viewController animated:animated];
        [CATransaction commit];
        
        return result;
    }else {
        if (completion) {
            completion();
        }
        
        return [self popToViewController:viewController animated:animated];
    }
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        NSArray<UIViewController*> *result = nil;
        
        [CATransaction setCompletionBlock:completion];
        [CATransaction begin];
        result = [self popToRootViewControllerAnimated:animated];
        [CATransaction commit];
        
        return result;
    }else {
        if (completion) {
            completion();
        }
        
        return [self popToRootViewControllerAnimated:animated];
    }
}

@end
