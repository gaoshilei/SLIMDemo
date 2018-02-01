//
//  NSString+SLIM.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "NSString+SLIM.h"

@implementation NSString (SLIM)

- (NSString *)slim_stringByAppendingScale:(NSNumber *)scale {
    double scaleValue = scale.floatValue;
    if (fabs(scaleValue - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) {
        return self.copy;
    }
    return [self stringByAppendingFormat:@"@%@x", scale];
}

@end
