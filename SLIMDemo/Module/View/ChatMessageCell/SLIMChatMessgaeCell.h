//
//  SLIMChatMessgaeCell.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "SLIMConstants.h"
#import "SLIMMessage.h"
#import <UIImageView+WebCache.h>
#import "SLIMMessageContentView.h"
#import "SLIMMessageSendStateView.h"
#import "UIImage+SLIM.h"


@class SLIMChatImageMessageCell;

@protocol SLIMChatMessageCellDelegate<NSObject>

- (void)messageImageDidDownload:(SLIMChatImageMessageCell *)messageCell;

@end

//所有消息的父类，方便以后添加其他类型消息以及定制卡片消息

@interface SLIMChatMessgaeCell : UITableViewCell

@property (nonatomic, strong, readonly) SLIMMessage *message;

/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 昵称 */
@property (nonatomic, strong) UILabel *nickNameView;
/** 显示消息主体的View */
@property (nonatomic, strong) SLIMMessageContentView *messageContentView;//SLIMMessageContentView
/** 显示消息发送失败的View */
@property (nonatomic, strong) SLIMMessageSendStateView *sendStateView;
/** 聊天气泡 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

/** 消息类型 */
@property (nonatomic, assign) SLIMMessageType messageType;

/** 消息发送方 */
@property (nonatomic, assign) SLIMMessageOwnerType ownerType;

/** 消息的代理 */
@property (nonatomic,   weak) id <SLIMChatMessageCellDelegate> delegate;

+ (void)registerSubClass;
+ (SLIMMessageType)classMessageType;

- (void)setup;
- (void)configureCellWithData:(SLIMMessage *)message;

/** 必须由子类实现，添加子类的视图 **/
- (void)addSubClassSubviews;

@end
