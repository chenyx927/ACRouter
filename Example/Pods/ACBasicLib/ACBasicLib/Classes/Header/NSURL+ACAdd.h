//
//  NSURL+ACAdd.h
//  QualityDevelopment
//
//  Created by 李明伟 on 16/4/16.
//  Copyright © 2016年 jingcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ACAdd)

- (NSDictionary *)parseQuery;
- (NSArray *)parseQueryKeyArray;
- (NSString *)parseQueryFromDictionary:(NSDictionary *)dictionary withKeyOrder:(NSArray *)keyOrder;

//考虑了除去uid 和 sign的url是否相等
- (BOOL)isEqualTo:(NSURL *)url;

@end
