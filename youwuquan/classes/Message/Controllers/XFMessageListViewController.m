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
#import "XFMessageNetworkManager.h"
#import "XFSystemMsgModel.h"
#import "XFLikeCommentModel.h"

@interface XFMessageListViewController ()

@property (nonatomic,strong) XFMessageViewController *headerVC;

@property (nonatomic,strong) __block UILabel *systemNumberLabel;

@property (nonatomic,copy) NSArray *systemMsgs;
@property (nonatomic,copy) NSArray *likeDatas;
@property (nonatomic,copy) NSArray *otherDatas;

@end

@implementation XFMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息";
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_SYSTEM)]];
    [self setupHeaderView];
    
    
    self.conversationListTableView.showsVerticalScrollIndicator = NO;
    // 系统消息
    UIButton *rightButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [rightButton setImage:[UIImage imageNamed:@"msg_ring"] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    self.navigationItem.rightBarButtonItem.badgeBGColor = kMainRedColor;
    self.navigationItem.rightBarButtonItem.badge.hidden = YES;

    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.conversationListTableView.bounces = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadData];

    
}

- (void)loadData {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *lastDate;
    if ([XFUserInfoManager sharedManager].lastGetNotificationDate) {
        
        lastDate = [XFUserInfoManager sharedManager].lastGetNotificationDate;

    } else {
        
        lastDate = @"2017-01-01 01:00:00";
    }
    
//    lastDate = @"2017-01-01 01:00:00";

    // 获取系统消息
    [XFMessageNetworkManager getSystemNotificationWithDate:lastDate successBlock:^(id responseObj) {
        
        NSArray *datas = (NSArray *)responseObj;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < datas.count; i ++ ) {
            
            [arr addObject:[XFSystemMsgModel modelWithDictionary:datas[i]]];
            
        }
        
        self.systemMsgs = arr.copy;
        
        NSString *date = [dateFormatter stringFromDate:[NSDate date]];
        
        [[XFUserInfoManager sharedManager] updateLastDate:date];
        
        if (self.systemMsgs.count > 0) {
            
            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%zd",self.systemMsgs.count];
            self.navigationItem.rightBarButtonItem.badge.hidden = NO;

        } else {
            
            self.navigationItem.rightBarButtonItem.badge.hidden = YES;

        }
        
    } failBlock:^(NSError *error) {
        
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
    [XFMessageNetworkManager getPersonalNotificationWithDate:lastDate type:@"like,comment,reward,gift,yellowPicture" successBlock:^(id responseObj) {
    
        NSArray *likeComments = (NSArray *)responseObj;
        NSMutableArray *arrLike = [NSMutableArray array];
        NSMutableArray *arrOther = [NSMutableArray array];

        for (int i = 0 ; i < likeComments.count ; i ++ ) {
            
            NSDictionary *dic = likeComments[i];
            
            if ([dic[@"type"] isEqualToString:@"like"] || [dic[@"type"] isEqualToString:@"comment"]) {
                [arrLike addObject:[XFLikeCommentModel modelWithDictionary:likeComments[i]]];

                
            } else {
                
                [arrOther addObject:[XFLikeCommentModel modelWithDictionary:likeComments[i]]];

            }
            
        }
        
        self.likeDatas = arrLike.copy;
        self.otherDatas = arrOther.copy;
        self.headerVC.likeDatas = self.likeDatas;
        self.headerVC.otherDatas = self.otherDatas;

    } failBlock:^(NSError *error) {
    
    } progressBlock:^(CGFloat progress) {
    
    }];

}


- (void)clickRightButton {
    
    XFYueViewController *chatVC = [[XFYueViewController alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.msgs = self.systemMsgs;
    chatVC.title = @"系统通知";
    chatVC.hasSeprator = NO;
    chatVC.type = System;
    [self.navigationController pushViewController:chatVC animated:YES];
    self.navigationItem.rightBarButtonItem.badge.hidden = YES;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    XFChatViewController *conversationVC = [[XFChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)setupHeaderView {
    
    self.headerVC = [[XFMessageViewController alloc] init];
    [self addChildViewController:self.headerVC];
    
    __weak typeof(self) weakSelf = self;
    self.headerVC.refreshMsgBlock = ^(NSArray *systemMsgs) {
        
        if (systemMsgs.count == 0) {
            
            weakSelf.systemNumberLabel.hidden = YES;
            
        } else {
            
            weakSelf.systemNumberLabel.text = [NSString stringWithFormat:@"%zd",systemMsgs.count];
        }
        
    };

    self.headerVC.view.frame = CGRectMake(0, -self.headerVC.headerHeight, kScreenWidth, self.headerVC.headerHeight);
    
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(self.headerVC.headerHeight, 0, 0, 0);
    [self.conversationListTableView addSubview:self.headerVC.view];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.emptyConversationView = [[UIView alloc] init];
    
}

@end
