//
//  SLIMChatMessgaeCell.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatMessgaeCell.h"
#import "SLIMMessageContentView.h"

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
@property (nonatomic, strong) UIView *messageContentView;
@property (nonatomic, strong) 

@property (nonatomic, assign) SLIMMessageType messageType;

@end


@implementation SLIMChatMessgaeCell

#pragma mark - life cycle

+ (void)load {
    SLIMChatMessageCellTypeDict = [NSMutableDictionary dictionary];
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
