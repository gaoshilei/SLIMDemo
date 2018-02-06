//
//  SLIMChatBar.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatBar.h"

CGFloat   const   kSLIMChatBarFontSize = 16.f;
CGFloat   const   kSLIMChatBarLayerCornerRadius = 4.f;
NSInteger const   kSLIMChatBarTextColor = 0x979797;
NSInteger const   kSLIMChatBarBackgroundColor = 0x00000;
NSInteger const   kSLIMChatBarBorderColor = 0x979797;

@interface SLIMChatBar()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *messageChatBarBackgroundView;
@property (nonatomic, strong) UIButton *imageButton;

@end

@implementation SLIMChatBar

- (instancetype)init {
    if (self = [super init]) {
        [self p_setUp];
    }
    return self;
}

- (void)p_setUp {
    [self addSubview:self.messageChatBarBackgroundView];
    [self.messageChatBarBackgroundView addSubview:self.textView];
    [self.messageChatBarBackgroundView addSubview:self.imageButton];
}

- (UIView *)messageChatBarBackgroundView {
    if (!_messageChatBarBackgroundView) {
        _messageChatBarBackgroundView = [[UIView alloc] init];
    }
    return _messageChatBarBackgroundView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:kSLIMChatBarFontSize];
        _textView.delegate = self;
        _textView.textColor = [UIColor slim_colorWithHexValue:kSLIMChatBarTextColor];
        _textView.backgroundColor = [UIColor slim_colorWithHexValue:kSLIMChatBarBackgroundColor];
        _textView.layer.cornerRadius = kSLIMChatBarLayerCornerRadius;
        _textView.layer.borderColor = (__bridge CGColorRef)([UIColor slim_colorWithHexValue:kSLIMChatBarBorderColor]);
        _textView.layer.borderWidth = .5f;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.clipsToBounds = YES;
    }
    return _textView;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"icon_pic"] forState:UIControlStateNormal];
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"icon_pic"] forState:UIControlStateSelected];
        [_imageButton addTarget:self action:@selector(p_sendPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageButton sizeToFit];
    }
    return _imageButton;
}


- (void)p_sendPhotoAction:(UIButton *)button {

}

@end
