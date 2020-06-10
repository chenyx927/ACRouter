//
//  UIImage+ACAdd.h
//  izhuan-enterprise
//
//  Created by creasyma on 15/6/17.
//  Copyright (c) 2015年 creasyma. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ACAdd)

/**
 压缩图片
 @param size 压缩后的尺寸
 @return 压缩后的图片对象
 **/
- (nullable UIImage *)scaleWithImageWithSize:(CGSize)size;

/**
 高斯模糊方法
 **/
- (nullable UIImage *)boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;

/**
 高斯模糊
 **/
- (nullable UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;

/**
 将图像转换为黑白照片
 **/
- (nullable UIImage *)transformToBlackAndWhite;

/**
 修改图片颜色
 */
-(nullable UIImage*)imageChangeColor:(UIColor*)color;

/**
 圆角纯色图片
 
 @param color 颜色
 @param size 尺寸
 @param radius 圆角
 @return 图片
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;

+ (nullable instancetype)imageWithColor:(nonnull UIColor *)color size:(CGSize)size;
+ (nullable instancetype)imageWithColor:(nonnull UIColor *)color;

+ (nullable UIImage *)clipCricleWithImage:(UIImage *)image;

- (nullable UIImage *)roundCorner:(CGFloat)radius;
- (nullable UIImage *)roundCorner:(CGFloat)radius corners:(UIRectCorner)corners borderWidth:(CGFloat)borderWidth;

+ (nullable instancetype)as_cachedImageNamed:(nonnull NSString *)name;
+ (nullable instancetype)as_documentsImageNamed:(nonnull NSString *)name;

+ (nullable instancetype)imageWithText:(NSString *)text font:(UIFont *)font;
+ (nullable instancetype)imageWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size;
+ (nullable instancetype)imageWithAppIcon;
+ (nullable instancetype)imageWithEmoji:(NSString *)emoji size:(CGFloat)size;
+ (nullable instancetype)imageWithView:(nonnull UIView *)view;
+ (nullable instancetype)imageWithView:(nonnull UIView *)view afterScreenUpdates:(BOOL)afterUpdates;
+ (nullable instancetype)imageWithGradientColors:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size;
+ (nullable instancetype)imageWithGradientColors:(UIColor *)startColor endColor:(UIColor *)endColor
                                      startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint size:(CGSize)size;
+ (nullable instancetype)imageWithGradientColors:(UIColor *)startColor endColor:(UIColor *)endColor
                                  gradientCenter:(CGPoint)gradientCenter radius:(CGFloat)radius size:(CGSize)size;

+ (nullable UIImage *)QRCodeImageWithText:(nonnull NSString *)text QRCodeSize:(CGSize)QRCodeSize icon:(nullable UIImage *)icon;
+ (nullable UIImage *)QRCodeImageWithText:(nonnull NSString *)text QRCodeSize:(CGSize)QRCodeSize icon:(nullable UIImage *)icon
                                 iconSize:(CGSize)iconSize;

+ (nullable UIImage *)imageWithCacheKey:(nonnull NSString *)cacheKey;

+ (id)downloadAndCacheImage:(nonnull NSString *)imageUrl
                  completed:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable cacheKey, NSError * _Nullable error))completed;

//both memory & cache
+ (void)removeCacheForKey:(NSString *)cacheKey;

- (nonnull UIImage *)fixOrientation;

- (nullable UIImage *)applyTintColor:(nonnull UIColor *)tintColor;
- (nullable UIImage *)applyGrayscale;
- (nullable UIImage *)applyBlurSoft;
- (nullable UIImage *)applyBlurLight;
- (nullable UIImage *)applyBlurExtraLight;
- (nullable UIImage *)applyBlurDark;
- (nullable UIImage *)applyBlurExtraDark;
- (nullable UIImage *)applyBlurTintColor:(nonnull UIColor *)tintColor;
- (nullable UIImage *)applyGradientColors:(UIColor *)startColor endColor:(UIColor *)endColor;

- (nullable UIImage *)applyImageWaterMask:(UIImage*)mask inRect:(CGRect)rect;
- (nullable UIImage *)applyTextWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (nullable UIImage *)applyTextWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

- (nullable UIImage *)resize:(CGSize)size;
- (nullable UIImage *)resize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (nullable UIImage *)resize:(CGSize)size interpolationQuality:(CGInterpolationQuality)quality;
- (nullable UIImage *)scaleByWidth:(CGFloat)width;
- (nullable UIImage *)scaleByHeight:(CGFloat)height;

- (nullable UIImage *)compress:(CGFloat)ratio scaleToSize:(CGSize)size;
- (nullable UIImage *)compress:(CGFloat)ratio byWidth:(CGFloat)width;
- (nullable UIImage *)compress:(CGFloat)ratio byHeight:(CGFloat)height;
- (nullable NSData *)fastCompressToDataLength:(NSInteger)length;

- (nullable UIImage *)crop:(CGRect)rect;
- (nullable UIImage *)insetEdge:(UIEdgeInsets)insets withColor:(nonnull UIColor *)color;

- (nonnull UIColor *)mostColor;

//保存至相册
- (void)saveToPhotosAlbum:(nullable void(^)(BOOL success))finished;

//截图
+ (nonnull UIImage *)captureScreenNomalQuality;
+ (nonnull UIImage *)captureScreenHighQuality;

@end


@interface UIImage (Gif)

+ (nullable UIImage *)animatedGIFNamed:(NSString *)name;

+ (nullable UIImage *)animatedGIFWithData:(NSData *)data;
- (NSTimeInterval)yy_animatedGifDuration;

@end
NS_ASSUME_NONNULL_END
