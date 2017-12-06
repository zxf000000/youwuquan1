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

- (void)setupBackView {
    
    UIImageView *topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_bjt"]];
    [self.view addSubview:topImgView];
    
    // 位置 按照比例
    CGFloat topHeight = 52/75.f * kScreenWidth;
    topImgView.frame = CGRectMake(0, 0, kScreenWidth, topHeight);
    
}


@end
