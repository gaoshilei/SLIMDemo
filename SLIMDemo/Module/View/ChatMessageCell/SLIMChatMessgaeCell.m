//
//  SLIMChatMessgaeCell.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/29.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatMessgaeCell.h"
#import "UIImageView+cornerRadius.h"
#import "SLIMBubbleImageFactory.h"

NSMutableDictionary const * SLIMChatMessageCellTypeDict = nil;

static CGFloat const kAvatarImageViewWidthAndHeight = 40.f;
static CGFloat const kMessageSendStateViewWidthAndHeight = 30.f;
static CGFloat const kMessageSendStateViewLeftOrRightMarginToMessageContent = 2.f;
static CGFloat const kAvatarToMessageContent = 5.f;

static CGFloat const SLIM_MSG_CELL_EDGES_OFFSET = 12.f;
//static CGFloat const SLIM_MSG_CELL_NICKNAME_HEIGHT = 16.f;
static CGFloat const SLIM_MSG_CELL_NICKNAME_FONTSIZE = 12.f;

@interface SLIMChatMessgaeCell()

@property (nonatomic, strong, readwrite) SLIMMessage *message;

@end


@implementation SLIMChatMessgaeCell

#pragma mark - life cycle

+ (void)initialize {
    //不可以将registerSubClass调用放在这里，initialize是懒加载，这个类方法仅仅会调用一次
    //当它的子类再次调用时，父类的这个方法不会被调用了
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

#pragma mark - lazy load

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        //解决离屏渲染的问题
        _avatarImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:4.f rectCornerType:UIRectCornerAllCorners];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameView {
    if (!_nickNameView) {
        _nickNameView = [[UILabel alloc] init];
        _nickNameView.font = [UIFont systemFontOfSize:SLIM_MSG_CELL_NICKNAME_FONTSIZE];
        _nickNameView.textColor = [UIColor grayColor];
        [_nickNameView sizeToFit];
    }
    return _nickNameView;
}

- (SLIMMessageContentView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [[SLIMMessageContentView alloc] init];
    }
    return _messageContentView;
}

- (SLIMMessageSendStateView *)sendStateView {
    if (!_sendStateView) {
        _sendStateView = [[SLIMMessageSendStateView alloc] init];
        _sendStateView.hidden = YES;
    }
    return _sendStateView;
}

- (UIImageView *)messageContentBackgroundImageView {
    if (!_messageContentBackgroundImageView) {
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
        [_messageContentBackgroundImageView setImage:[SLIMBubbleImageFactory bubbleImageViewForOwner:self.ownerType messageType:self.messageType isHighlighted:NO]];
        [_messageContentBackgroundImageView setHighlightedImage:[SLIMBubbleImageFactory bubbleImageViewForOwner:self.ownerType messageType:self.messageType isHighlighted:YES]];
    }
    return _messageContentBackgroundImageView;
}

- (SLIMMessageOwnerType)ownerType {
    _ownerType = SLIMMessageOwnerTypeNone;
    if ([self.reuseIdentifier containsString:SLIMCellIdentifierOwnerSelf]) {
        _ownerType = SLIMMessageOwnerTypeSelf;
    }else if ([self.reuseIdentifier containsString:SLIMCellIdentifierOwnerOther]) {
        _ownerType = SLIMMessageOwnerTypeOther;
    }else if ([self.reuseIdentifier containsString:SLIMCellIdentifierOwnerSystem]) {
        _ownerType = SLIMMessageOwnerTypeSystem;
    }
    return _ownerType;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - private method

+ (void)registerSubClass {
    if (!SLIMChatMessageCellTypeDict) {
        SLIMChatMessageCellTypeDict = [NSMutableDictionary dictionary];
    }
    //注册所有子类
    SLIMMessageType classType = [self classMessageType];
    Class class = [SLIMChatMessageCellTypeDict objectForKey:@(classType)];
    if (!class) {
        [SLIMChatMessageCellTypeDict setObject:self forKey:@(classType)];
    }
}

- (void)addSubClassSubviews {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
    CGFloat messageContentWidthMax = width - (kAvatarImageViewWidthAndHeight+SLIM_MSG_CELL_EDGES_OFFSET)*2;
    switch (self.ownerType) {
        case SLIMMessageOwnerTypeSelf: {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-SLIM_MSG_CELL_EDGES_OFFSET);
                make.top.equalTo(self.contentView).offset(SLIM_MSG_CELL_EDGES_OFFSET);
                make.width.height.mas_equalTo(kAvatarImageViewWidthAndHeight);
            }];
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView);
                make.right.equalTo(self.avatarImageView.mas_left).offset(-kAvatarToMessageContent);
                make.width.mas_lessThanOrEqualTo(messageContentWidthMax).priorityHigh();
                make.bottom.equalTo(self.contentView).offset(-SLIM_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
            [self.sendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentView.mas_left).offset(-kMessageSendStateViewLeftOrRightMarginToMessageContent);
                make.centerY.equalTo(self.messageContentView);
                make.width.height.mas_equalTo(kMessageSendStateViewWidthAndHeight);
            }];
        }
            break;
        case SLIMMessageOwnerTypeOther: {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self.contentView).offset(SLIM_MSG_CELL_EDGES_OFFSET);
                make.width.height.mas_equalTo(kAvatarImageViewWidthAndHeight);
            }];
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView);
                make.left.equalTo(self.avatarImageView.mas_right).offset(kAvatarToMessageContent);
                make.width.mas_lessThanOrEqualTo(messageContentWidthMax).priorityHigh();
                make.bottom.equalTo(self.contentView).offset(-SLIM_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
            [self.sendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageContentView.mas_right).offset(kMessageSendStateViewLeftOrRightMarginToMessageContent);
                make.centerY.equalTo(self.messageContentView);
                make.width.height.mas_equalTo(kMessageSendStateViewWidthAndHeight);
            }];
        }
            break;
        default:
            break;
    }
    [self.messageContentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView);
    }];
}

- (void)addSubviews {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.sendStateView];
    [self.contentView addSubview:self.messageContentBackgroundImageView];
    //记得要给messageContentView设置蒙版大小，不然内容就显示不出来啦！
    self.messageContentView.layer.mask.contents = (__bridge id _Nullable)self.messageContentBackgroundImageView.image.CGImage;
    [self.contentView insertSubview:self.messageContentBackgroundImageView belowSubview:self.messageContentView];
    //添加子类的视图，否则更新约束会报错
    [self addSubClassSubviews];
    //更新约束
    [self updateConstraintsIfNeeded];
}

+ (SLIMMessageType)classMessageType {
    //必须由子类实现
    [self doesNotRecognizeSelector:_cmd];
    return SLIMMessageTypeNone;
}

- (void)configureCellWithData:(SLIMMessage *)message {
    self.message = message;
    self.ownerType = message.ownerType;
    UIImage *placeholder = [UIImage slim_imageNamed:@"Placeholder_Avatar" bundleName:@"Placeholder" bundleForClass:[self class]];
    if ([message.avatarUrl.scheme containsString:@"http"]) {
        [self.avatarImageView sd_setImageWithURL:message.avatarUrl placeholderImage:placeholder];
    }else if(message.localAvatarImageName){
        self.avatarImageView.image = [UIImage imageNamed:message.localAvatarImageName];
    }
}

- (void)setup {
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.messageType = [[self class] classMessageType];
    [self addSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
