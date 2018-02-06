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

+ (void)load {
    [self registerSubClass];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.messageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).insets(UIEdgeInsetsMake(SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight, SLIMCellMessageContentCapInsetsTopAndBottom, SLIMCellMessageContentCapInsetsLeftAndRight));
    }];
}

- (void)configureCellWithData:(SLIMMessage *)message {
    [super configureCellWithData:message];
    self.messageTextLabel.text = message.text;
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

- (void)addSubClassSubviews {
    [self.messageContentView addSubview:self.messageTextLabel];
}

- (void)setup {
    [super setup];
    //链接的颜色
    self.messageTextLabel.linkTextAttributes = @{
                                                 NSForegroundColorAttributeName: [UIColor redColor]
                                                 };
    //链接点击之后的颜色
    self.messageTextLabel.activeLinkTextAttributes  = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                        NSBackgroundColorAttributeName: [UIColor colorWithWhite:.35f alpha:.3f]
                                                        };
    
}

@end
