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

- (UIImage *)slim_imageByScalingAspectFill {
    CGSize kMaxImageViewSize = {.width = 200, .height = 200};
    CGSize originSize = ({
        CGFloat width = self.size.width;
        CGFloat height = self.size.height;
        CGSize size = CGSizeMake(width, height);
        size;
    });
    UIImage *resizedImage = [self slim_imageByScalingAspectFillWithOriginSize:originSize limitSize:kMaxImageViewSize];
    return resizedImage;
}

- (UIImage *)lcck_imageByScalingAspectFillWithOriginSize:(CGSize)originSize {
    CGSize kMaxImageViewSize = {.width = 200, .height = 200};
    UIImage *resizedImage = [self slim_imageByScalingAspectFillWithOriginSize:originSize limitSize:kMaxImageViewSize];
    return resizedImage;
}

- (UIImage *)slim_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize {
    if (originSize.width == 0 || originSize.height == 0) {
        return self;
    }
    CGFloat aspectRatio = originSize.width / originSize.height;
    CGFloat width;
    CGFloat height;
    //胖照片
    if (limitSize.width / aspectRatio <= limitSize.height) {
        width = limitSize.width;
        height = limitSize.width / aspectRatio;
    } else {
        //瘦照片
        width = limitSize.height * aspectRatio;
        height = limitSize.height;
    }
    return [self slim_scaledToSize:CGSizeMake(width, height)];
}

- (UIImage *)slim_scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
