//
//  SLIMImageManager.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLIMImageManager : NSObject

+ (instancetype)shareInstance;

/**
 在bundle中寻找对应的图片 @2x @3x
 */
- (UIImage *)imageWithName:(NSString *)imageName inBundle:(NSBundle *)bundle;

@end
