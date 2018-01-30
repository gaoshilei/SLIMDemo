//
//  SLIMChatMessgaeCell.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatMessgaeCell.h"
#import "SLIMMessageContentView.h"
#import "SLIMMessageSendStateView.h"
#import "UIImageView+cornerRadius.h"

NSMutableDictionary const * SLIMChatMessageCellTypeDict = nil;

static CGFloat const kAvatarImageViewWidth = 40.f;
static CGFloat const kAvatarImageViewHeight = kAvatarImageViewWidth;
static CGFloat const kMessageSendStateViewWidthAndHeight = 30.f;
static CGFloat const kMessageSendStateViewLeftOrRightMarginToMessageContent = 2.f;
static CGFloat const kAvatarToMessageContent = 5.f;

static CGFloat const SLIM_MSG_CELL_EDGES_OFFSET = 12.f;
static CGFloat const SLIM_MSG_CELL_NICKNAME_HEIGHT = 16.f;
static CGFloat const SLIM_MSG_CELL_NICKNAME_FONTSIZE = 12.f;

@interface SLIMChatMessgaeCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *messageContentView;//SLIMMessageContentView
@property (nonatomic, strong) SLIMMessageSendStateView *sendStateView;
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

@property (nonatomic, assign) SLIMMessageType messageType;

@end


@implementation SLIMChatMessgaeCell

#pragma mark - life cycle

+ (void)load {
    if (!SLIMChatMessageCellTypeDict) {
        SLIMChatMessageCellTypeDict = [NSMutableDictionary dictionary];
    }
    NSLog(@"%s_%@",__func__,self);
}

+ (void)initialize {
    [self p_registerSubClass];
    NSLog(@"%s_%@",__func__,self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_commonSetup];
    }
    return self;
}

#pragma mark - lazy load

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        //设置圆角不可以用layer.cornerRadius的方式，离屏渲染非常卡顿
        _avatarImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:4.f rectCornerType:UIRectCornerAllCorners];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImageView;
}

- (UIView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [[UIView alloc] init];
    }
    return _messageContentView;
}

- (SLIMMessageSendStateView *)sendStateView {
    if (!_sendStateView) {
        _sendStateView = [[SLIMMessageSendStateView alloc] init];
    }
    return _sendStateView;
}

- (UIImageView *)messageContentBackgroundImageView {
    if (!_messageContentBackgroundImageView) {
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundImageView;
}

#pragma mark - 类方法

+ (void)p_registerSubClass {
    //注册所有子类
    SLIMMessageType classType = [self classMessageType];
    Class class = [SLIMChatMessageCellTypeDict objectForKey:@(classType)];
    if (!class) {
        [SLIMChatMessageCellTypeDict setObject:self forKey:@(classType)];
    }
}

+ (SLIMMessageType)classMessageType {
    //必须由子类实现
    [self doesNotRecognizeSelector:_cmd];
    return SLIMMessageTypeNone;
}

- (void)p_commonSetup {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.messageType = [[self class] classMessageType];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
