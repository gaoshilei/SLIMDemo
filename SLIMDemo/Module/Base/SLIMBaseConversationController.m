//
//  SLIMBaseConversationController.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/26.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMBaseConversationController.h"
#import "SLIMConstants.h"
#import "SLIMChatSystemMessageCell.h"

@interface SLIMBaseConversationController ()<UIGestureRecognizerDelegate> {

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SLIMChatBar *chatBar;

@end

@implementation SLIMBaseConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_initSubviews];
    //初始化TableView
    [self p_initilzer];
    
    //给UITableView添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)p_initilzer {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self p_registerChatMessageCell];
    [self p_setTableViewInsets];
}

- (void)p_initSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(kSLIMChatBarMinHeight).priorityLow();
        make.height.mas_greaterThanOrEqualTo(kSLIMChatBarMinHeight).priorityHigh();
        make.height.mas_lessThanOrEqualTo(kSLIMChatBarMaxHeight).priorityHigh();
    }];
}

- (void)p_setTableViewInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake(20.f, 0, kSLIMChatBarMinHeight, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - register cell
- (void)p_registerChatMessageCell {
    [SLIMChatMessageCellTypeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *classType, Class  _Nonnull aClass, BOOL * _Nonnull stop) {
        [self p_registerMessageCellClass:aClass];
    }];
}

-(void)p_registerMessageCellClass:(Class)aClass {
    NSString *messageCellClassString = NSStringFromClass(aClass);
    if ([aClass isKindOfClass:[SLIMChatSystemMessageCell class]]) {
        //系统消息
        [self.tableView registerClass:aClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@",messageCellClassString,SLIMCellIdentifierOwnerSystem]];
    }else {
        //发出的消息
        [self.tableView registerClass:aClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@",messageCellClassString,SLIMCellIdentifierOwnerSelf]];
        //收到的消息
        [self.tableView registerClass:aClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@",messageCellClassString,SLIMCellIdentifierOwnerOther]];
    }
}

#pragma mark - lazy load
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SLIMChatBar *)chatBar {
    if (!_chatBar) {
        _chatBar = [[SLIMChatBar alloc] init];
        [self.view addSubview:_chatBar];
        [self.view bringSubviewToFront:_chatBar];
        _chatBar.delegate = self;
    }
    return _chatBar;
}

#pragma mark - SLChatBarDelegate
- (void)chatBarFrameDidChange:(SLIMChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom {
    [UIView animateWithDuration:.35f animations:^{
        [self.tableView.superview layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //子类实现
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //点击页面收起键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:kSLIMCharBarKeyboardHideNotificationName object:nil];
    //点击了tableViewCell，不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
