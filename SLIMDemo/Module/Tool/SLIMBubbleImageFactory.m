//
//  SLIMBubbleImageFactory.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMBubbleImageFactory.h"
#import "NSBundle+SLIM.h"
#import "UIImage+SLIM.h"

NSString const *SLIMBubbleImageBundleName = @"MessageBubble";

@implementation SLIMBubbleImageFactory

+ (UIImage *)bubbleImageViewForOwner:(SLIMMessageOwnerType)ownerType
                         messageType:(SLIMMessageType)msgType
                       isHighlighted:(BOOL)isHighlighted {
    NSString *messageTypeString = @"message_";
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    switch (msgType) {
        case SLIMMessageTypeImage:
        case SLIMMessageTypeVideo:
            messageTypeString = [messageTypeString stringByAppendingString:@"hollow_"];
            break;
        default:
            break;
    }
    switch (ownerType) {
        case SLIMMessageOwnerTypeSelf: {
            edgeInsets = UIEdgeInsetsMake(30, 16, 16, 24);
            messageTypeString = [messageTypeString stringByAppendingString:@"sender_"];
        }
            break;
        case SLIMMessageOwnerTypeOther: {
            edgeInsets = UIEdgeInsetsMake(30, 16, 16, 24);
            messageTypeString = [messageTypeString stringByAppendingString:@"receiver_"];
        }
            break;
        default:
            break;
    }
    messageTypeString = [messageTypeString stringByAppendingString:@"background_"];
    if (isHighlighted) {
        messageTypeString = [messageTypeString stringByAppendingString:@"highlight"];
    }else {
        messageTypeString = [messageTypeString stringByAppendingString:@"normal"];
    }
    UIImage *bubbleImage = [UIImage slim_imageNamed:messageTypeString bundleName:SLIMBubbleImageBundleName.copy bundleForClass:[self class]];
    bubbleImage =  [bubbleImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    return bubbleImage;
}

@end
