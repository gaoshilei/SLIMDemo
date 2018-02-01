//
//  SLIMBaseTableViewController.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/26.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMBaseTableViewController.h"
#import "SLIMConstants.h"
#import "SLIMChatSystemMessageCell.h"

static CGFloat const kSLIMChatBarHeight = 50.f;

@interface SLIMBaseTableViewController ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation SLIMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化TableView
    [self p_initSubviews];
    [self p_initilzer];
}

- (void)p_initilzer {
    //注册cell
    [self p_registerChatMessageCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_initSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSLIMChatBarHeight);
    }];
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
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
