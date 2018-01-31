//
//  SLIMChatTextMessageCell.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/30.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatTextMessageCell.h"
#import <MLLinkLabel.h>

CGFloat const SLIMTextMessageCellLabelFont = 16.f;

@interface SLIMChatTextMessageCell()

@property (nonatomic, strong) MLLinkLabel *messageTextLabel;

@end

@implementation SLIMChatTextMessageCell

- (void)updateConstraints {
    [super updateConstraints];
    [self.messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).insets(UIEdgeInsetsMake(SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight, SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight));
    }];
    
}

- (void)configureCellWithData:(SLIMMessage *)message {
    [super configureCellWithData:message];
}

+ (SLIMMessageType)classMessageType {
    return SLIMMessageTypeText;
}

- (MLLinkLabel *)messageTextLabel {
    if (!_messageTextLabel) {
        _messageTextLabel = [[MLLinkLabel alloc] init];
        _messageTextLabel.numberOfLines = 0;
        _messageTextLabel.font = [UIFont systemFontOfSize:SLIMTextMessageCellLabelFont];
        
        [_messageTextLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSLog(@"%@",linkText);
        }];
    }
    return _messageTextLabel;
}

@end
