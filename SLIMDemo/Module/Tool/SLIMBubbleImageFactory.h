//
//  SLIMBubbleImageFactory.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLIMConstants.h"

@interface SLIMBubbleImageFactory : NSObject

/**
 聊天气泡背景图片
 */
+ (UIImage *)bubbleImageViewForOwner:(SLIMMessageOwnerType)ownerType
                         messageType:(SLIMMessageType)msgType
                       isHighlighted:(BOOL)isHighlighted;

@end
