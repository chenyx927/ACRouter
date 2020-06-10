//
//  NSObject+ACAdd.h
//  QualityDevelopment
//
//  Created by creasyma on 16/1/18.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ACAdd)

+ (NSString *)className;
- (NSString *)className;

+ (BOOL)isNotEmpty:(id)obj;
+ (BOOL)isEmpty:(id)obj;

@end
