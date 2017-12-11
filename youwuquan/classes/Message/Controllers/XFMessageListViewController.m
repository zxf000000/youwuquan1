//
//  XFMessageListViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMessageListViewController.h"
#import "XFMessageViewController.h"
#import "XFChatViewController.h"

@interface XFMessageListViewController ()

@property (nonatomic,strong) XFMessageViewController *headerVC;

@end

@implementation XFMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息";
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    [self setupHeaderView];
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    XFChatViewController *conversationVC = [[XFChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"想显示的会话标题";
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)setupHeaderView {
    
    self.headerVC = [[XFMessageViewController alloc] init];
    [self addChildViewController:self.headerVC];
    
//    __weak typeof(self) weakSelf = self;
//    self.headerVC.changeHeaderHeightBlock = ^(CGFloat height) {
//
//        weakSelf.headerVC.view.frame = CGRectMake(0, 0, kScreenWidth, height);
//
//    };

    self.headerVC.view.frame = CGRectMake(0, 0, kScreenWidth, self.headerVC.headerHeight);
    self.conversationListTableView.tableHeaderView = self.headerVC.view;
    
    self.emptyConversationView = [[UIView alloc] init];
    
}

@end
