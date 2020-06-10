//
//  DES3.h
//  DES3
//
//  Created by 徐鹏 on 15/11/19.
//  Copyright © 2015年 徐鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3 : NSObject

/**
*  3des加密
*
*  @param src     待加密的string
*  @param key     约定的密钥
*  @param ivKey   约定的密钥
*
*  @return 3des加密后的string
*/
+ (NSString*)encrypt:(NSString*)src key:(NSString*)key ivKey:(NSString*)ivKey;

/**
 *  3des解密
 *
 *  @param src     待解密的string
 *  @param key     约定的密钥
 *  @param ivKey   约定的密钥
 *
 *  @return 3des解密后的string
 */
+ (NSString*)decrypt:(NSString*)src key:(NSString*)key ivKey:(NSString*)ivKey;

@end
