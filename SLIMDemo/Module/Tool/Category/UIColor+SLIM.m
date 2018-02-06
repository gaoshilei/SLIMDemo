//
//  UIColor+SLIM.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/2/6.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "UIColor+SLIM.h"

@implementation UIColor (SLIM)

+ (UIColor *)slim_colorWithHexValue:(NSInteger)hexValue {
    return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16)/255.0 green:((hexValue & 0xFF00) >> 8)/255.0 blue:(hexValue & 0xFF)/255.0 alpha:1.0];
}

@end
