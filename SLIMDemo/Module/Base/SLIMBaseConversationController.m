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

@interface SLIMBaseConversationController () {

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SLIMChatBar *chatBar;

@end

@implementation SLIMBaseConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化TableView
    [self p_initilzer];
    [self p_initSubviews];
}

- (void)p_initilzer {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册cell
    [self p_registerChatMessageCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_initSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(kSLIMChatBarMinHeight);
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
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

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
    }
    return _chatBar;
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

@end
