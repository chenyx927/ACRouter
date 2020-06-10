//
//  NSTextAttachment+ACAdd.m
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/29.
//

#import "NSTextAttachment+ACAdd.h"
#import "UIDevice+ACAdd.h"
#import "CGFloat+ACAdd.h"
#import "NSString+ACAdd.h"
#import "UIView+ACAdd.h"
#import "UIImage+ACAdd.h"

@implementation NSTextAttachment (ACAdd)

+ (NSTextAttachment *)attachmentWithStr:(NSString *)str color:(UIColor *)attachmentColor fontSize:(CGFloat)fontSize{
    
    CGFloat ratio = [UIDevice screenWidth] / 750;
    UILabel *tagLabel = [UILabel new];
    UIFont *font = !CGFloatEquals(fontSize, 0) ? [UIFont systemFontOfSize:fontSize]: [UIFont systemFontOfSize:22 * ratio];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.backgroundColor = attachmentColor;
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.text = str;
    tagLabel.font = font;
    CGSize strSize = [str sizeForFont:tagLabel.font size:CGSizeMake(0, 0) mode:0];
    CGRect boundsWithInsideMagin = CGRectMake(0, 0,strSize.width + 4 * ratio,strSize.height + 4 * ratio);
    tagLabel.bounds = boundsWithInsideMagin;
    UIImage *snapShot = [tagLabel screenshot];
    snapShot = [snapShot roundCorner:2.5];
    NSTextAttachment *attachement = [[NSTextAttachment alloc] init];
    attachement.image = snapShot;
    attachement.bounds = CGRectMake(0, -3,snapShot.size.width ,snapShot.size.height);
    return attachement;
}

@end
