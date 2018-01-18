//
//  ViewController.m
//  SLIMDemo
//
//  Created by gaoshilei on 2018/1/18.
//  Copyright © 2018年 gaoshilei. All rights reserved.
//

#import "ViewController.h"
#import "SLIMViewController.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"客服入口";
    UIButton *launchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [launchBtn setTitle:@"客服入口" forState:UIControlStateNormal];
    [launchBtn setBackgroundColor:[UIColor yellowColor]];
    [launchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    launchBtn.layer.cornerRadius = 8.f;
    launchBtn.layer.masksToBounds = YES;
    [launchBtn addTarget:self action:@selector(p_customService) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:launchBtn];
    [launchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150.f, 50.f));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150.f);
    }];
}

- (void)p_customService {
    SLIMViewController *IM = [[SLIMViewController alloc] init];
    [self.navigationController pushViewController:IM animated:YES];
}


@end
