//
//  ACRouter.m
//  QualityDevelopment
//
//  Created by creasyma on 2016/12/28.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import "ACRouter.h"


















NSString *const ACRouterRegisterHandlerKey = @"ACRouterRegisterHandlerKey";
NSString *const ACRouterParameterCompletion = @"ACRouterParameterCompletion";
NSString *const ACRouterParameterUserInfo = @"ACRouterParameterUserInfo";

@interface ACRouter()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation ACRouter

+ (ACRouter *)sharedInstance
{
    static ACRouter *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ACRouter alloc] init];
    });
    
    return _instance;
}
- (void)openWithURLString:(NSString *)URLString
{
    NSLog(@"-------------------%@",URLString);
}

@end
