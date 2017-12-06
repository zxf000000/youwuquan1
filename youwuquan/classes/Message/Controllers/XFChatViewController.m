//
//  XFChatViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFChatViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface XFChatViewController ()

@end

@implementation XFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backButton = [UIButton naviBackButton];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
