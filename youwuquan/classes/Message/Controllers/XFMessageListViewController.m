//
//  XFMessageListViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMessageListViewController.h"
#import "XFMessageViewController.h"

@interface XFMessageListViewController ()

@property (nonatomic,strong) XFMessageViewController *headerVC;

@end

@implementation XFMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息";
    
    [self setupHeaderView];
}

- (void)setupHeaderView {
    
    self.headerVC = [[XFMessageViewController alloc] init];
    [self addChildViewController:self.headerVC];
    
    __weak typeof(self) weakSelf = self;
    self.headerVC.changeHeaderHeightBlock = ^(CGFloat height) {
      
        weakSelf.headerVC.view.frame = CGRectMake(0, 0, kScreenWidth, height);

        
    };

    self.headerVC.view.frame = CGRectMake(0, 0, kScreenWidth, 2000);
    self.conversationListTableView.tableHeaderView = self.headerVC.view;
    
    self.emptyConversationView = [[UIView alloc] init];
    
}

@end
