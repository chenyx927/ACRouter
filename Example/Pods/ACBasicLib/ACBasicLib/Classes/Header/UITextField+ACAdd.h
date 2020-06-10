//
//  UITextField+ACAdd.h
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ACAdd)

#pragma mark - format
- (void)formatPhoneNumber;
- (void)removeFormatPhoneNumber;

#pragma mark - selectedTextRange
- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
