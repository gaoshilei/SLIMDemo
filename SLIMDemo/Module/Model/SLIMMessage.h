//
//  SLIMMessage.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLIMConstants.h"

@interface SLIMMessage : NSObject

@property (nonatomic,   copy) NSString *text;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, strong) NSURL *imageThumbUrl;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) NSTimeInterval sendTimestampLocal;
@property (nonatomic, assign) NSTimeInterval sendTimestampServer;

@property (nonatomic, assign) SLIMMessageType messageType;
@property (nonatomic, assign) SLIMMessageOwnerType ownerType;

@end
