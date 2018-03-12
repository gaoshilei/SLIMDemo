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
#pragma mark - Life Cycle
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
}

- (void)p_initSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];

    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_lessThanOrEqualTo(kSLIMChatBarMaxHeight);
    }];
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

#pragma mark - SLIMChatBarDelegate
- (void)chatBarFrameDidChange:(SLIMChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom {
    [UIView animateWithDuration:.25f animations:^{
        [self.view layoutIfNeeded];
        self.allowScrollToBottom = shouldScrollToBottom;
        [self scrollToBottomAnimated:NO];
    }];
}

#pragma mark - UITableViewDelegate

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
#pragma mark - Public Method
- (void)scrollToBottomAnimated:(BOOL)animated {
    if (!self.allowScrollToBottom) {
        return;
    }
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows==0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottomAnimated:NO];
    });
}

#pragma mark - Private Method

@end
