//
//  NSBundle+SLIM.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "NSBundle+SLIM.h"

@implementation NSBundle (SLIM)

+ (NSBundle *)slim_bundleForName:(NSString *)bundleName class:(Class)aClass {
    NSString *bundlePath = [NSBundle slim_bundlePathForBundleName:bundleName class:aClass];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

+ (NSString *)slim_bundlePathForBundleName:(NSString *)bundleName class:(Class)aClass {
    NSString *pathComponent = [NSString stringWithFormat:@"%@.bundle",bundleName];
    NSString *bundlePath = [[[NSBundle bundleForClass:aClass] resourcePath] stringByAppendingPathComponent:pathComponent];
    return bundlePath;
}

@end
