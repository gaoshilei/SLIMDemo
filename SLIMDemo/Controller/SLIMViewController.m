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

@interface SLIMViewController ()<UITextFieldDelegate,SLIMWebSocketDelegate>

@property (nonatomic, strong) UITextField       *inputView;
@property (nonatomic, strong) SLIMSocketManager *webSocket;

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

- (void)p_sendMessage {
    [self.webSocket send:self.inputView.text];
}

- (void)p_close {
    [self.webSocket disconnect];
}

- (void)p_initWebSocketManager {
    self.webSocket = [[SLIMSocketManager alloc] initWithDelegate:self];
    [self.webSocket connect];
}

- (void)webSocket:(SLIMSocketManager *)webSocket didReceiveMessage:(id)message {
}

- (void)webSocket:(SLIMSocketManager *)webSocket didFailWithError:(NSError *)error connectionErrorCode:(SLIMSocketErrorCode)reason {
    
}

- (void)p_initSubviews {
    UITextField *inputView = [[UITextField alloc] init];
    inputView.borderStyle = UITextBorderStyleRoundedRect;
    inputView.delegate = self;
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(self.view.frame.size.width/2);
        make.height.mas_equalTo(40.f);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150.f);
    }];
    self.inputView = inputView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(p_sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView.mas_right).offset(10.f);
        make.centerY.equalTo(inputView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(p_close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendBtn.mas_right).offset(10.f);
        make.centerY.equalTo(inputView);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView resignFirstResponder];
}

@end
