//
//  SLIMViewController.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/18.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "SLIMViewController.h"
#import "SLIMSocketManager.h"
#import <Masonry.h>

@interface SLIMViewController ()<UITextFieldDelegate>

@end

@implementation SLIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"客服";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self p_initSubviews];
    [self p_initWebSocketManager];
}

- (void)p_initSubviews {
    UITextField *inputView = [[UITextField alloc] init];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(self.view.frame.size.width/2);
        make.height.mas_equalTo(20.f);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100.f);
    }];
    
}

- (void)p_initWebSocketManager {
    [[SLIMSocketManager shareManager] connect];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


@end
