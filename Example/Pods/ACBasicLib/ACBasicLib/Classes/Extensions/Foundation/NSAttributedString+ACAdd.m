//
//  NSAttributedString+ACAdd.m
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/29.
//

#import "NSAttributedString+ACAdd.h"

@implementation NSAttributedString (ACAdd)

- (CGFloat)heightForWidth:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return rect.size.height;
}

- (CGFloat)widthForHeight:(CGFloat)height {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return rect.size.width;
}

@end
