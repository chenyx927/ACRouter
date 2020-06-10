//
//  UIView+ACAdd.m
//  izhuanC2C
//
//  Created by 李明伟 on 15/7/8.
//  Copyright (c) 2015年 jingcai. All rights reserved.
//

#import "UIView+ACAdd.h"
#import <objc/runtime.h>

void Swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIView (ACAdd)

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerDoubleTapBlockKey;
static char kDTActionHandlerDoubleTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;
static char kTouchExtendInsetKey;

//static const char * kLastClickedEventTime = "LastClickedEventTime";

static const CGFloat kUIViewMaterialDesignTransitionDuration = 0.65;
//static const NSTimeInterval kAcceptClickEventInterval        = 1.5;

+ (void)load {
    Swizzle(self, @selector(pointInside:withEvent:), @selector(extendPointInside:withEvent:));
}

- (BOOL)extendPointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchExtendInset, UIEdgeInsetsZero) || self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self extendPointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0);
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

//- (NSTimeInterval)lastClickedEventTime
//{
//    return [objc_getAssociatedObject(self, kLastClickedEventTime) doubleValue];
//}
//
//- (void)setLastClickedEventTime:(NSTimeInterval)lastClickedEventTime
//{
//    objc_setAssociatedObject(self, kLastClickedEventTime, @(lastClickedEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)layerShadow:(UIColor *)color opacity:(float)opacity radius:(CGFloat)radius offset:(CGSize)offset
{
    self.layer.shadowColor   = color.CGColor;
    self.layer.shadowOffset  = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius  = radius;
}

- (void)solidBorder:(UIColor *)borderColor top:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom
{
    
    CALayer *layer = self.layer;
    
    if (top > 0) {
        CALayer *topBorder = [CALayer layer];
        CGFloat borderWidth   = top / [UIScreen mainScreen].scale;
        
        if (((int)top + 1) % 2 == 0) {
            CGFloat offset  = (1.f / [UIScreen mainScreen].scale) / 2.f;
            topBorder.frame = CGRectMake(0, offset, layer.frame.size.width, borderWidth);
        }
        else {
            topBorder.frame = CGRectMake(0, 0, layer.frame.size.width, borderWidth);
        }
        
        [topBorder setBackgroundColor:borderColor.CGColor];
        [layer addSublayer:topBorder];
    }
    
    if (right > 0) {
        CALayer *rightBorder = [CALayer layer];
        CGFloat borderWidth     = right / [UIScreen mainScreen].scale;
        
        if (((int)right + 1) % 2 == 0) {
            CGFloat offset  = (1.f / [UIScreen mainScreen].scale) / 2.f;
            rightBorder.frame = CGRectMake(layer.frame.size.width-borderWidth-offset, 0, borderWidth, layer.frame.size.height);
        }
        else {
            rightBorder.frame = CGRectMake(layer.frame.size.width-borderWidth, 0, borderWidth, layer.frame.size.height);
        }
        
        [rightBorder setBackgroundColor:borderColor.CGColor];
        [layer addSublayer:rightBorder];
    }
    
    if (bottom > 0) {
        CALayer *bottomBorder = [CALayer layer];
        CGFloat borderWidth      = bottom / [UIScreen mainScreen].scale;
        
        if (((int)bottom + 1) % 2 == 0) {
            CGFloat offset  = (1.f / [UIScreen mainScreen].scale) / 2.f;
            bottomBorder.frame = CGRectMake(0, layer.frame.size.height-borderWidth-offset, layer.frame.size.width, borderWidth);
        }
        else {
            bottomBorder.frame = CGRectMake(0, layer.frame.size.height-borderWidth, layer.frame.size.width, borderWidth);
        }
        
        [bottomBorder setBackgroundColor:borderColor.CGColor];
        [layer addSublayer:bottomBorder];
    }
    
    if (left > 0) {
        CALayer *leftBorder = [CALayer layer];
        CGFloat borderWidth    = left / [UIScreen mainScreen].scale;
        
        if (((int)left + 1) % 2 == 0) {
            CGFloat offset  = (1.f / [UIScreen mainScreen].scale) / 2.f;
            leftBorder.frame = CGRectMake(offset, 0, borderWidth, layer.frame.size.height);
        }
        else {
            leftBorder.frame = CGRectMake(0, 0, borderWidth, layer.frame.size.height);
        }
        
        [leftBorder setBackgroundColor:borderColor.CGColor];
        [layer addSublayer:leftBorder];
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)clicked:(nonnull void(^)(void))clicked
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIImageView class]]) {
            self.userInteractionEnabled = YES;
        }
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, clicked, OBJC_ASSOCIATION_COPY);
}

- (void)doubleClick:(nonnull void(^)(void))doubleClick
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerDoubleTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForDoubleTapGesture:)];
        gesture.numberOfTapsRequired = 2;
        if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIImageView class]]) {
            self.userInteractionEnabled = YES;
        }
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerDoubleTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerDoubleTapBlockKey, doubleClick, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
//    if ([NSDate date].timeIntervalSince1970 - self.lastClickedEventTime < kAcceptClickEventInterval) {
//        return;
//    }
//
//    self.lastClickedEventTime = [NSDate date].timeIntervalSince1970;
    
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)() = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

- (void)__handleActionForDoubleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)() = objc_getAssociatedObject(self, &kDTActionHandlerDoubleTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

- (void)longPressed:(nonnull void(^)(UITapGestureRecognizer *gesture))longPressed
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
    
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
        if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UIImageView class]]) {
            self.userInteractionEnabled = YES;
        }
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, longPressed, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        void(^action)(UITapGestureRecognizer *tapGesture) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
        if (action)
        {
            action(gesture);
        }
    }
}

- (void)setTouchExtendInset:(UIEdgeInsets)touchExtendInset
{
    objc_setAssociatedObject(self, &kTouchExtendInsetKey, [NSValue valueWithUIEdgeInsets:touchExtendInset], OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)touchExtendInset
{
    return [objc_getAssociatedObject(self, &kTouchExtendInsetKey) UIEdgeInsetsValue];
}

- (void)shake {
    [self _shake:10 direction:1 currentTimes:0 withDelta:5 speed:0.03 shakeDirection:ShakeDirectionHorizontal
      completion:nil];
}

- (void)_shake:(int)times
     direction:(int)direction
  currentTimes:(int)current
     withDelta:(CGFloat)delta
         speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
    completion:(nullable void (^)())handler {
    [UIView animateWithDuration:interval animations:^{
        self.transform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (handler) {
                    handler();
                }
            }];
            return;
        }
        [self _shake:(times - 1)
           direction:direction * -1
        currentTimes:current + 1
           withDelta:delta
               speed:interval
      shakeDirection:shakeDirection
          completion:handler];
    }];
}

- (CGPoint)convertPoint:(CGPoint)point to:(UIView *)view
{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)convertPoint:(CGPoint)point from:(UIView *)view
{
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

#pragma mark - Material Design Animation
- (CGFloat)mdShapeDiameterForPoint:(CGPoint)point {
    CGPoint cornerPoints[] = { {0.0, 0.0}, {0.0, self.bounds.size.height}, {self.bounds.size.width, self.bounds.size.height}, {self.bounds.size.width, 0.0} };
    CGFloat radius = 0.0;
    for (int i = 0; i < sizeof(cornerPoints) / sizeof(CGPoint); i++) {
        CGPoint p = cornerPoints[i];
        CGFloat d = sqrt( pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0) );
        if (d > radius) {
            radius = d;
        }
    }
    return radius * 2.0f;
}

- (CAShapeLayer *)mdShapeLayerForAnimationAtPoint:(CGPoint)point {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGFloat diameter = [self mdShapeDiameterForPoint:point];
    shapeLayer.frame = CGRectMake(floor(point.x - diameter * 0.5), floor(point.y - diameter * 0.5), diameter, diameter);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, diameter, diameter)].CGPath;
    return shapeLayer;
}

- (CABasicAnimation *)shapeAnimationWithTimingFunction:(CAMediaTimingFunction *)timingFunction scale:(CGFloat)scale inflating:(BOOL)inflating {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    if (inflating) {
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
    } else {
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    }
    animation.timingFunction = timingFunction;
    animation.removedOnCompletion = YES;
    return animation;
}

- (void)mdAnimateAtPoint:(CGPoint)point backgroundColor:(UIColor *)backgroundColor duration:(NSTimeInterval)duration inflating:(BOOL)inflating zTopPosition:(BOOL)zTopPosition shapeLayer:(CAShapeLayer *)shapeLayer completion:(void (^)(void))block {
    if (!shapeLayer) {
        shapeLayer = [self mdShapeLayerForAnimationAtPoint:point];
        self.layer.masksToBounds = YES;
        if (zTopPosition) {
            [self.layer addSublayer:shapeLayer];
        } else {
            [self.layer insertSublayer:shapeLayer atIndex:0];
        }
        
        if (!inflating) {
            shapeLayer.fillColor = self.backgroundColor.CGColor;
            self.backgroundColor = backgroundColor;
        } else {
            shapeLayer.fillColor = backgroundColor.CGColor;
        }
    }
    
    CGFloat scale = 1.0f / shapeLayer.frame.size.width;
    NSString *timingFunctionName = kCAMediaTimingFunctionDefault; //inflating ? kCAMediaTimingFunctionDefault : kCAMediaTimingFunctionDefault;
    CABasicAnimation *animation = [self shapeAnimationWithTimingFunction:[CAMediaTimingFunction functionWithName:timingFunctionName] scale:scale inflating:inflating];
    animation.duration = duration;
    shapeLayer.transform = [animation.toValue CATransform3DValue];
    
    __block UIView *selfRef = self;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (inflating) {
            selfRef.backgroundColor = backgroundColor;
        }
        [shapeLayer removeFromSuperlayer];
        if (block) {
            block();
        }
    }];
    [shapeLayer addAnimation:animation forKey:@"shapeBackgroundAnimation"];
    [CATransaction commit];
}

- (void)mdInflateAnimatedFromPoint:(CGPoint)point backgroundColor:(UIColor *)backgroundColor duration:(NSTimeInterval)duration completion:(void (^)(void))block {
    [self mdAnimateAtPoint:point backgroundColor:backgroundColor duration:duration inflating:YES zTopPosition:NO shapeLayer:nil completion:block];
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
