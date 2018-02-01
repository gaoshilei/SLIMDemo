//
//  UIImageView+cornerRadius.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/30.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "UIImageView+cornerRadius.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat slRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat slBorderWidth;
@property (strong, nonatomic) UIColor *slBorderColor;
@property (assign, nonatomic) BOOL slHadAddObserver;
@property (assign, nonatomic) BOOL slIsRounding;

@end


@implementation UIImageView (cornerRadius)

/**
 * @brief init the Rounding UIImageView, no off-screen-rendered
 */
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self cornerRadiusRoundingRect];
    }
    return self;
}

/**
 * @brief init the UIImageView with cornerRadius, no off-screen-rendered
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

/**
 * @brief attach border for UIImageView with width & color
 */
- (void)attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.slBorderWidth = width;
    self.slBorderColor = color;
}

#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (void)cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.slRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.slIsRounding = NO;
    if (!self.slHadAddObserver) {
//        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.slHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)cornerRadiusRoundingRect {
    self.slIsRounding = YES;
    if (!self.slHadAddObserver) {
//        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.slHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.slBorderWidth && nil != self.slBorderColor) {
        [path setLineWidth:2 * self.slBorderWidth];
        [self.slBorderColor setStroke];
        [path stroke];
    }
}

- (void)dealloc {
    if (self.slHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

//+ (void)swizzleDealloc {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(dealloc)];
//    });
//}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(LayoutSubviews)];
    });
}

- (void)LayoutSubviews {
    [self LayoutSubviews];
    if (self.slIsRounding) {
        [self cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.slRadius && 0 != self.roundingCorners && nil != self.image) {
        [self cornerRadiusWithImage:self.image cornerRadius:self.slRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.slIsRounding) {
            [self cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.slRadius && 0 != self.roundingCorners && nil != self.image) {
            [self cornerRadiusWithImage:newImage cornerRadius:self.slRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark  - property
- (CGFloat)slBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSlBorderWidth:(CGFloat)slBorderWidth {
    objc_setAssociatedObject(self, @selector(slBorderWidth), @(slBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)slBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSlBorderColor:(UIColor *)slBorderColor {
    objc_setAssociatedObject(self, @selector(slBorderColor), slBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)slHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSlHadAddObserver:(BOOL)slHadAddObserver {
    objc_setAssociatedObject(self, @selector(slHadAddObserver), @(slHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)slIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSlIsRounding:(BOOL)slIsRounding {
    objc_setAssociatedObject(self, @selector(slIsRounding), @(slIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)slRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSlRadius:(CGFloat)slRadius {
    objc_setAssociatedObject(self, @selector(slRadius), @(slRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
