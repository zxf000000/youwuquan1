//
//  XFChargeSuccessViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFChargeSuccessViewController.h"
#import "AppDelegate.h"

@interface XFChargeSuccessViewController ()

@property (nonatomic,strong) UIImageView *picView;

@property (nonatomic,strong) UIButton *backButton;

@end

@implementation XFChargeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = nil;
    [self setupViews];

    [self.view setNeedsUpdateConstraints];
}

- (void)clickBackButton {
    
    if (self.type == XFSuccessViewTypeChargeFailed || self.type == XFSuccessViewTypeVipFailed) {
    
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
        [self.navigationController popViewControllerAnimated:YES];
    
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }
    
}

- (void)setupViews {
    
    self.picView = [[UIImageView alloc] init];
    [self.view addSubview:self.picView];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTitle:@"返回" forState:(UIControlStateNormal)];
    self.backButton.backgroundColor = kMainRedColor;
    [self.view addSubview:self.backButton];
    
    [self.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    switch (self.type) {
            
        case XFSuccessViewTypeVipSuccess:
        {
            self.picView.image = [UIImage imageNamed:@"huiyuanchenggong"];
        }
            break;
        case XFSuccessViewTypeVipFailed:
        {
            self.picView.image = [UIImage imageNamed:@"huiyuanshibai"];

        }
            break;
        case XFSuccessViewTypeChargeSuccess:
        {
            self.picView.image = [UIImage imageNamed:@"chongzhichenggong"];

        }
            break;
        case XFSuccessViewTypeChargeFailed:
        {
            self.picView.image = [UIImage imageNamed:@"chongzhishibai"];

        }
            break;
            
    }
    
}

- (void)updateViewConstraints {
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-100);
        
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.picView.mas_bottom).offset(37.5);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(125);
        
    }];
    
    [super updateViewConstraints];
}


@end
