//
//  NSString+SLIM.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "NSString+SLIM.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SLIM)

- (NSString *)slim_stringByAppendingScale:(NSNumber *)scale {
    double scaleValue = scale.floatValue;
    if (fabs(scaleValue - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) {
        return self.copy;
    }
    return [self stringByAppendingFormat:@"@%@x", scale];
}


- (NSString *)MD5Hash {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
