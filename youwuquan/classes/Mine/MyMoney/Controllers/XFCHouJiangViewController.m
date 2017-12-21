//
//  XFCHouJiangViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/19.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCHouJiangViewController.h"

@interface XFCHouJiangViewController ()

@end

@implementation XFCHouJiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"抽奖";
    
    UIButton *cancelButton = [UIButton naviBackButton];
 
    [cancelButton setImage:[UIImage imageNamed:@"home_cancel"] forState:(UIControlStateNormal)];
    
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
}

- (void)clickCancelButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
