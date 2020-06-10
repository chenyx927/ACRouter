//
//  NSTextAttachment+ACAdd.h
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTextAttachment (ACAdd)

+ (NSTextAttachment *)attachmentWithStr:(NSString *)str color:(UIColor *)attachmentColor fontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
