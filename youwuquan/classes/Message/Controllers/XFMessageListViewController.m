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
#import "XFYueViewController.h"

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
    
    // 系统消息
    UIButton *rightButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    [rightButton setImage:[UIImage imageNamed:@"msg_ring"] forState:(UIControlStateNormal)];
    
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);

    if (@available (ios 11 , *)) {
        
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);

    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UILabel *numberLabel  = [[UILabel alloc] init];
    numberLabel.text = @"11";
    numberLabel.font = [UIFont systemFontOfSize:10];
    [rightButton addSubview:numberLabel];
    numberLabel.backgroundColor = kMainRedColor;
    numberLabel.textColor = [UIColor whiteColor];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(0);
        make.top.mas_offset(-8);
        make.height.width.mas_equalTo(20);
    }];
    numberLabel.layer.cornerRadius = 10;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}

- (void)clickRightButton {
    
    
    XFYueViewController *chatVC = [[XFYueViewController alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.msgs = [NSMutableArray array];
    [chatVC.msgs addObject:@(1)];
    [chatVC.msgs addObject:@(1)];
    [chatVC.msgs addObject:@(1)];
    [chatVC.msgs addObject:@(1)];
    [chatVC.msgs addObject:@(1)];

    chatVC.title = @"系统通知";
    chatVC.hasSeprator = NO;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    XFChatViewController *conversationVC = [[XFChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = @"小美同学";
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
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.emptyConversationView = [[UIView alloc] init];
    
}

@end
