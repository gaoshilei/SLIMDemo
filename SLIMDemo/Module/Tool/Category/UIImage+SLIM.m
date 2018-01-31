//
//  UIImage+SLIM.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "UIImage+SLIM.h"
#import "NSBundle+SLIM.h"
#import "SLIMImageManager.h"

@implementation UIImage (SLIM)

+ (UIImage *)slim_imageNamed:(NSString *)imageName
                  bundleName:(NSString *)bundleName
              bundleForClass:(Class)aClass {
    if (imageName.length == 0) return nil;
    if ([imageName hasPrefix:@"/"]) return nil;
    NSBundle *bundle = [NSBundle slim_bundleForName:bundleName class:aClass];
    SLIMImageManager *imageManager = [SLIMImageManager shareInstance];
    UIImage *image = [imageManager imageWithName:imageName inBundle:bundle];
    if (!image) {
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end
