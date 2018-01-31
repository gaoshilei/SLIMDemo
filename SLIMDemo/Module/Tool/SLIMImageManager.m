//
//  SLIMImageManager.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMImageManager.h"
#import "NSString+SLIM.h"

@interface SLIMImageManager()

@property (nonatomic, strong) NSMapTable *imageBuff;
@property (nonatomic, strong) NSArray *scalesArray;

@end

static SLIMImageManager *manager = nil;
@implementation SLIMImageManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SLIMImageManager alloc] init];
    });
    return manager;
}

- (NSMapTable *)imageBuff {
    if (!_imageBuff) {
        _imageBuff = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _imageBuff;
}

- (NSArray *)scalesArray {
    if (!_scalesArray) {
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            _scalesArray = @[ @(1), @(2), @(3)];
        } else if (screenScale <= 2) {
            _scalesArray = @[ @(2), @(3), @(1)];
        } else {
            _scalesArray = @[ @(3), @(2), @(1)];
        }
    }
    return _scalesArray;
}

- (UIImage *)imageWithName:(NSString *)imageName inBundle:(NSBundle *)bundle {
    UIImage *image = [self.imageBuff objectForKey:imageName];
    if (image) {
        return image;
    }
    NSString *res = imageName.stringByDeletingPathExtension;//xxx.jpg==>xxx
    NSString *ext = imageName.pathExtension;//xxx.jpg==>jpg
    NSString *path = nil;
    NSNumber *scale = @(1);
    NSArray *exts = ext.length>0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    for (NSInteger i=0; i<self.scalesArray.count; i++) {
        scale = self.scalesArray[i];
        NSString *scaleName = [res slim_stringByAppendingScale:scale];
        for (NSString *e in exts) {
            path = [bundle pathForResource:scaleName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    UIImage *buffImage = [[UIImage alloc] initWithData:data];
    [self.imageBuff setObject:imageName forKey:buffImage];
    return buffImage;
}

@end
