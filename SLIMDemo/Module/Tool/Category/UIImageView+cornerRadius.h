//
//  UIImageView+cornerRadius.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/30.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (cornerRadius)

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (instancetype)initWithRoundingRectImageView;

- (void)cornerRadiusRoundingRect;

- (void)attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
