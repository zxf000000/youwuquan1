//
//  XFLoginBaseViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLoginBaseViewController.h"


@interface XFLoginBaseViewController ()

@end

@implementation XFLoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)setupBackView {
    
    UIImageView *topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_bjt"]];
    [self.view addSubview:topImgView];
    
    // 位置 按照比例
    CGFloat topHeight = 52/75.f * kScreenWidth;
    topImgView.frame = CGRectMake(0, 0, kScreenWidth, topHeight);
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

@end
