//
//  SLIMConstants.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <Foundation/Foundation.h>

//消息类型
typedef NS_ENUM(NSInteger, SLIMMessageType) {
    /** 未知类型消息 */
    SLIMMessageTypeNone     = 0,
    /** 纯文本消息 */
    SLIMMessageTypeText     = 1,
    /** 图片消息 */
    SLIMMessageTypeImage    = 2,
    /** 语音消息（预留） */
    SLIMMessageTypeAudio    = 3,
    /** 视频消息（预留） */
    SLIMMessageTypeVideo    = 4,
    /** 位置消息（预留） */
    SLIMMessageTypeLocation = 5,
    /** 系统消息 */
    SLIMMessageTypeSystem   = 6,
};

//消息归属类型
typedef NS_ENUM(NSInteger, SLIMMessageSourceType) {
    /** 未知类型消息 */
    SLIMMessageSourceTypeNone    = 0,
    /** 发出的消息 */
    SLIMMessageSourceTypeSelf    = 1,
    /** 收到的消息 */
    SLIMMessageSourceTypeOther   = 2,
    /** 系统消息 */
    SLIMMessageSourceTypeSystem  = 3,
};

//消息发送状态
typedef NS_ENUM(NSInteger, SLIMMessageSendStatus) {
    /** 未知状态 */
    SLIMMessageSendStatusNone       = 100,
    /** 消息发送中 */
    SLIMMessageSendStatusSending    = 0,
    /** 消息发送成功（客服未读） */
    SLIMMessageSendStatusSent       = 1,
    /** 消息已送达（客服已读） */
    SLIMMessageSendStatusDelivered  = 2,
    /** 消息发送失败 */
    SLIMMessageSendStatusFailed     = 3,
};

/**储存不同类型的cell class*/
FOUNDATION_EXPORT NSMutableDictionary const * SLIMChatMessageCellTypeDict;

static NSString *const SLIMCellIdentifierOwnerSelf      = @"SLIMCellIdentifierOwnerSelf";
static NSString *const SLIMCellIdentifierOwnerOther     = @"SLIMCellIdentifierOwnerOther";
static NSString *const SLIMCellIdentifierOwnerSystem    = @"SLIMCellIdentifierOwnerSystem";

static CGFloat const SLIMCellMessageContentCapInsetsTopAndBottom = 12.f;
static CGFloat const SLIMCellMessageContentCapInsetsLeftAndRight = 15.f;
