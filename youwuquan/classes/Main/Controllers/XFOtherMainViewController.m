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

    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
