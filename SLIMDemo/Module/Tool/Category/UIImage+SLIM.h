//
//  UIImage+SLIM.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SLIM)

+ (UIImage *)slim_imageNamed:(NSString *)imageName
                  bundleName:(NSString *)bundleName
              bundleForClass:(Class)aClass;

@end
