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

@interface SLIMChatMessgaeCell : UITableViewCell

@property (nonatomic, strong, readonly) SLIMMessage *message;

/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 昵称 */
@property (nonatomic, strong) UILabel *nickNameView;
/** 消息 */
@property (nonatomic, strong) UIView *messageContentView;//SLIMMessageContentView
/** 显示消息主体的View */
@property (nonatomic, strong) SLIMMessageSendStateView *sendStateView;
/** 聊天气泡 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

/** 消息类型 */
@property (nonatomic, assign) SLIMMessageType messageType;

/** 消息发送方 */
@property (nonatomic, assign) SLIMMessageOwnerType ownerType;

+ (SLIMMessageType)classMessageType;

- (void)configureCellWithData:(SLIMMessage *)message;

@end
