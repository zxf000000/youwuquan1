//
//  XFOtherMainViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"

@interface XFOtherMainViewController ()

@end

@implementation XFOtherMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    [self initNavigationBar];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self setupLoadfailedView];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadAgain {
    
    
    
}

- (void)setupLoadfailedView {
    
    self.noneDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.noneDataView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Load_ Fail"]];
    
    [self.noneDataView addSubview:imgView];
    
    UIButton *reloadButton = [[UIButton alloc] init];
    reloadButton.backgroundColor = kMainRedColor;
    [reloadButton setTitle:@"重新加载" forState:(UIControlStateNormal)];
    [reloadButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    reloadButton.layer.cornerRadius = 4;
    [self.noneDataView addSubview:reloadButton];
    
    [reloadButton addTarget:self action:@selector(loadAgain) forControlEvents:(UIControlEventTouchUpInside)];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-130);
        
    }];
    
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(imgView.mas_bottom).offset(33);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.view addSubview:self.noneDataView];
    self.noneDataView.hidden = YES;
}

@end
