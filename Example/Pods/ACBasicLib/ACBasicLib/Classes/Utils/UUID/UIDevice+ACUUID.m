//
//  UIDevice+ACUUID.m
//  QualityDevelopment
//
//  Created by creasyma on 2017/12/5.
//  Copyright © 2017年 jingcai. All rights reserved.
//

#import "UIDevice+ACUUID.h"
#import "FCUUID.h"

@implementation UIDevice (ACUUID)

- (NSString *)uuidForDevice
{
    NSString *uuid = [FCUUID uuidForDevice];
    
    return uuid;
}

@end
