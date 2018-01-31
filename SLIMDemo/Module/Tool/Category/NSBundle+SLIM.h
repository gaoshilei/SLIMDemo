//
//  NSBundle+SLIM.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (SLIM)

+ (NSBundle *)slim_bundleForName:(NSString *)bundleName class:(Class)aClass;

@end
