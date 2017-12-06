//
//  XFMainViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMainViewController.h"

@interface XFMainViewController ()

@end

@implementation XFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self initNavigationBar];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
    
    [self setupLoadfailedView];
    
    
}

- (void)setupLoadfailedView {
    
    self.loadFaildView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.loadFaildView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Load_ Fail"]];
    
    [self.loadFaildView addSubview:imgView];
    
    UIButton *reloadButton = [[UIButton alloc] init];
    reloadButton.backgroundColor = kMainRedColor;
    [reloadButton setTitle:@"重新加载" forState:(UIControlStateNormal)];
    [reloadButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    reloadButton.layer.cornerRadius = 4;
    [self.loadFaildView addSubview:reloadButton];
    
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
    
    [self.view addSubview:self.loadFaildView];
}

@end
