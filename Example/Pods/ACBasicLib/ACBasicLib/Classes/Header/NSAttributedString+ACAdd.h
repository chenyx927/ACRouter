//
//  NSAttributedString+ACAdd.h
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ACAdd)

- (CGFloat)heightForWidth:(CGFloat)width;
- (CGFloat)widthForHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
