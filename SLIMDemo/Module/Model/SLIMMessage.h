//
//  SLIMMessage.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJExtension.h>
#import "SLIMConstants.h"

@interface SLIMMessage : NSObject

@property (nonatomic,   copy) NSString *text;
@property (nonatomic, strong) NSString *localAvatarImageName;
@property (nonatomic, strong) NSURL *imageThumbUrl;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) NSTimeInterval sendTimestampLocal;
@property (nonatomic, assign) NSTimeInterval sendTimestampServer;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *image;


/** 头像 */
@property (nonatomic, strong) NSURL *avatarUrl;
/** 消息ID（系统返回的消息ID，自增，全局唯一） */
@property (nonatomic,   copy) NSString *messageId;
/** 发送者的ID */
@property (nonatomic,   copy) NSString *from;
/** 接收者的ID */
@property (nonatomic,   copy) NSString *to;
/** 服务端收到消息的时间（时间戳毫秒数） */
@property (nonatomic,   copy) NSString *receiptTime;
/** 客户端消息发送时间（消息发送时，客户端的本地时间毫秒数） */
@property (nonatomic,   copy) NSString *sendTime;
/** 消息的hash（对字符串from=xxx&to=xxx&data=xxx&sendTime=xxx进行MD5） */
@property (nonatomic,   copy) NSString *hashValue;
/** 消息的类型 */
@property (nonatomic, assign) SLIMMessageType messageType;
/** 发送者类型 */
@property (nonatomic, assign) SLIMMessageSourceType sourceType;

@end
