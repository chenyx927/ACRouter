//
//  UIApplication+ACAdd.m
//  DMKJ
//
//  Created by zhanggy on 2018/2/28.
//  Copyright © 2018年 jingcai. All rights reserved.
//

#import "UIApplication+ACAdd.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <Photos/Photos.h>

@implementation UIApplication (ACAdd)
- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)appBundleDisplayName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (CGFloat)statusBarHeight {
    return [self statusBarFrame].size.height;
}

- (CGFloat)navigationBarHeight {
    return 44.0;
}

+ (BOOL)isAuthAccessCarmera {
#if TARGET_IPHONE_SIMULATOR
    [self showAlertForSimulator];
    return NO;
#else
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status) {
            case ALAuthorizationStatusNotDetermined:
                //用户未选择 所以要让他进入界面后选择
                return YES;
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
            {
                [self showUnauthAccessCarmeraAlert];
            }
                return NO;
                
            default:
                break;
        }
    }
#endif
    
    return YES;
}

+ (BOOL)isAuthAccessPhotos {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            //用户未选择 所以要让他进入界面后选择
            return YES;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self showUnauthAccessPhotosAlert];
        }
            
            return NO;
            
        default:
            break;

    }
    return YES;
}

+ (UIWindow *)topWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    return window;
}

+ (UIViewController *)topController
{
    UIViewController *result = nil;
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIViewController *topVC = topWindow.rootViewController;
    
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *topNavController = (UINavigationController *)topVC;
        
        if (topNavController.topViewController) {
            result = topNavController.topViewController;
        }
    }else if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *topTabController = (UITabBarController *)topVC;
        topVC = topTabController.selectedViewController;
        
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *topNavController = (UINavigationController *)topVC;
            
            if (topNavController.topViewController) {
                result = topNavController.topViewController;
            }
        }else {
            result = topVC;
        }
    } else {
        result = topVC;
    }
    
    return result;
}

#pragma mark - alert
+ (void)showAlertForSimulator {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"模拟器不能使用相机功能！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }];
    [alertController addAction:confirmAction];
    [[self topController] presentViewController:alertController
                                       animated:YES
                                     completion:nil];
}



+ (void)showUnauthAccessPhotosAlert {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *mssage = [NSString stringWithFormat:@"请授权%@可以访问照片,设置方式:设置->%@->照片,允许%@访问照片", appName, appName, appName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:mssage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancleAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
    }];
    
    [alertController addAction:confirmAction];
    [[self topController] presentViewController:alertController animated:YES completion:nil];
    
}
+ (void)showUnauthAccessCarmeraAlert {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *mssage = [NSString stringWithFormat:@"请授权%@可以访问相机,设置方式:设置->%@->相机,允许%@访问相机", appName, appName, appName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:mssage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancleAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    [alertController addAction:confirmAction];
    [[self topController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)launchSettings {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}

@end
