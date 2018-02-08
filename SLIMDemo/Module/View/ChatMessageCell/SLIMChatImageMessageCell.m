//
//  SLIMChatImageMessageCell.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/30.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatImageMessageCell.h"
#import <SDWebImageDownloader.h>

@interface SLIMChatImageMessageCell()

/**
 消息图片
 */
@property (nonatomic, strong) UIImageView *messageImageView;

/**
 显示发送图片的进度View
 */
@property (nonatomic, strong) UIView *messageProgressView;

/**
 显示发送图片的进度百分比的View
 */
@property (nonatomic, strong) UILabel *messageProgressLabel;

@end

@implementation SLIMChatImageMessageCell

+ (void)load {
    [self registerSubClass];
}

+ (SLIMMessageType)classMessageType {
    return SLIMMessageTypeImage;
}

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
    }
    return _messageImageView;
}

- (UIView *)messageProgressView {
    if (!_messageProgressView) {
        _messageProgressView = [[UIView alloc] init];
        
    }
    return _messageProgressView;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).insets(UIEdgeInsetsMake(SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight, SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight));
        make.height.mas_lessThanOrEqualTo(200.f).priorityHigh();
    }];
}

- (void)addSubClassSubviews {
    [self.messageContentView addSubview:self.messageImageView];
    [self.messageContentView addSubview:self.messageProgressView];
}

- (void)configureCellWithData:(SLIMMessage *)message {
    [super configureCellWithData:message];
    UIImage *thumbnailImage = message.thumbnailImage;
    if (self.messageImageView.image && self.messageImageView.image == thumbnailImage) {
        return;
    }
    if (thumbnailImage) {
        self.messageImageView.image = thumbnailImage;
        return;
    }
    UIImage *placeholdImage = [UIImage slim_imageNamed:@"Placeholder_Image" bundleName:@"Placeholder" bundleForClass:[self class]];
    [self.messageImageView sd_setImageWithURL:message.imageUrl placeholderImage:placeholdImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                self.messageImageView.image = [image slim_imageByScalingAspectFill];
            }
        });
    }];
}

@end
