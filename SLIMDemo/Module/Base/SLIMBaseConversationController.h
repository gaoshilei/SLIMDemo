//
//  SLIMBaseConversationController.h
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/26.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLIMChatBar.h"

@interface SLIMBaseConversationController : UIViewController<UITableViewDelegate, UITableViewDataSource, SLIMChatBarDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) SLIMChatBar *chatBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL allowScrollToBottom;

- (void)scrollToBottomAnimated:(BOOL)animated;

@end
