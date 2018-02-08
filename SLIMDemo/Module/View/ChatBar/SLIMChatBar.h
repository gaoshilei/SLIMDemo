//
//  SLIMChatBar.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/31.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+SLIM.h"
#import "SLIMConstants.h"

static CGFloat const kSLIMChatBarHeight = 50.f;
static CGFloat const kSLIMChatBarTextViewBottomOffset = 7.f;
static CGFloat const kSLIMChatBarTextViewLROffset = 15.f;
static CGFloat const kSLIMChatBarTextViewMinHeight = 36.f;
static CGFloat const kSLIMChatBarTextViewMaxHeight = 102.f;
static CGFloat const kSLIMChatBarMinHeight = kSLIMChatBarTextViewMinHeight + 2*kSLIMChatBarTextViewBottomOffset;
static CGFloat const kSLIMChatBarMaxHeight = kSLIMChatBarTextViewMaxHeight + 2*kSLIMChatBarTextViewBottomOffset;

@class SLIMChatBar;
@protocol SLIMChatBarDelegate<NSObject>

- (void)chatBarFrameDidChange:(SLIMChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom;

@end

@interface SLIMChatBar : UIView

@property (nonatomic, weak) id<SLIMChatBarDelegate> delegate;

@end
