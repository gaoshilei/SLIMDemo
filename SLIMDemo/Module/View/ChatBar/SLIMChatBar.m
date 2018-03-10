//
//  SLIMChatBar.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMChatBar.h"
#import <Masonry.h>

CGFloat   const   kSLIMChatBarFontSize = 16.f;
CGFloat   const   kSLIMChatBarLayerCornerRadius = 4.f;
NSInteger const   kSLIMChatBarTextColor = 0x979797;
NSInteger const   kSLIMChatBarBackgroundColor = 0xffffff;
NSInteger const   kSLIMChatBarBorderColor = 0x979797;

NSString *const kSLIMCharBarKeyboardHideNotificationName = @"kSLIMCharBarKeyboardHideNotificationName";

@interface SLIMChatBar()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *messageChatBarBackgroundView;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, assign) CGFloat kbHeight;
@property (nonatomic, assign) NSTimeInterval kbAnimationDuration;

@end

@implementation SLIMChatBar

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSLIMCharBarKeyboardHideNotificationName object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [self p_setUp];
    }
    return self;
}

- (void)p_setUp {
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.messageChatBarBackgroundView];
    [self addSubview:self.topLineView];
    [self.messageChatBarBackgroundView addSubview:self.textView];
    [self.messageChatBarBackgroundView addSubview:self.imageButton];
    
    [self.messageChatBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.messageChatBarBackgroundView).offset(-13.f);
        make.left.equalTo(self.messageChatBarBackgroundView).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(28, 24));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageButton.mas_right).offset(kSLIMChatBarTextViewLROffset);
        make.right.equalTo(self.messageChatBarBackgroundView).offset(-kSLIMChatBarTextViewLROffset);
        make.top.equalTo(self.messageChatBarBackgroundView).offset(kSLIMChatBarTextViewBottomOffset);
        make.bottom.equalTo(self.messageChatBarBackgroundView).offset(-kSLIMChatBarTextViewBottomOffset);
        make.height.mas_equalTo(kSLIMChatBarTextViewMinHeight).priorityLow();
        make.height.mas_greaterThanOrEqualTo(kSLIMChatBarTextViewMinHeight).priorityHigh();
        make.height.mas_lessThanOrEqualTo(kSLIMChatBarTextViewMaxHeight).priorityHigh();
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardHide) name:kSLIMCharBarKeyboardHideNotificationName object:nil];
}

#pragma mark - 键盘事件
- (void)p_keyboardHide {
    [self.textView resignFirstResponder];
}

- (void)p_keyboardWillShow:(NSNotification *)noti {
    self.kbHeight = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.kbAnimationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self p_updateChatBarKeyboardConstraints];
}

- (void)p_keyboardWillHidden:(NSNotification *)noti {
    self.kbHeight = 0;
    [self p_updateChatBarKeyboardConstraints];
}

- (void)p_updateChatBarKeyboardConstraints{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-self.kbHeight);
    }];
    [UIView animateWithDuration:self.kbAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    [self p_chatBarFrameDidChangeShouldScrollToBottom:YES];
}

- (void)p_textViewDidChange:(UITextView *)textView shouldCacheText:(BOOL)shouldCacheText{
    if (shouldCacheText) {
        self.cachedText = textView.text;
    }
    CGSize textSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), 1000)];
    CGFloat newTextHeight = MAX(kSLIMChatBarTextViewMinHeight, MIN(kSLIMChatBarTextViewMaxHeight, textSize.height));
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newTextHeight);
    }];
    void(^setContentOffBlock)(void) = ^void{
        if (textView.scrollEnabled && self.allowTextViewContentOffset) {
            if (newTextHeight == kSLIMChatBarTextViewMaxHeight) {
                [textView setContentOffset:CGPointMake(0, textView.contentSize.height - newTextHeight) animated:YES];
            } else {
                [textView setContentOffset:CGPointZero animated:YES];
            }
            [self p_chatBarFrameDidChangeShouldScrollToBottom:YES];
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        setContentOffBlock();
    });
}

- (void)p_chatBarFrameDidChangeShouldScrollToBottom:(BOOL)shouldScrollToBottom {
    if ([self.delegate respondsToSelector:@selector(chatBarFrameDidChange:shouldScrollToBottom:)]) {
        [self.delegate chatBarFrameDidChange:self shouldScrollToBottom:shouldScrollToBottom];
    }
}

#pragma mark - 消息类动作
- (void)p_sendTextMessage:(NSString *)message {
    if ([self.delegate respondsToSelector:@selector(chatBar:sendTextMessage:)]) {
        [self.delegate chatBar:self sendTextMessage:message];
    }
}

- (void)p_sendPhotoAction:(UIButton *)button {
    
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //在文字中间进行编辑不滚动textView
    if (range.location == textView.text.length) {
        self.allowTextViewContentOffset = YES;
    }else {
        self.allowTextViewContentOffset = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self p_sendTextMessage:textView.text];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self p_textViewDidChange:textView shouldCacheText:YES];
}

#pragma mark - lazy load
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
        _textView.layer.borderColor = [UIColor slim_colorWithHexValue:kSLIMChatBarBorderColor].CGColor;
        _textView.layer.borderWidth = .5f;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.clipsToBounds = YES;
        _textView.scrollsToTop = NO;
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

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor slim_colorWithHexValue:kSLIMChatBarBorderColor];
    }
    return _topLineView;
}

@end
