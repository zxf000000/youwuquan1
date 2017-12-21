//
//  XFYueViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFYueViewController.h"
#import "XFYueTableViewCell.h"
#import "XFAcceptTableViewCell.h"
#import "XFAvtivityMsgTableViewCell.h"
#import "XFCommentMessageTableViewCell.h"
#import "XFStatusDetailViewController.h"
#import "XFActivityViewController.h"

@interface XFYueViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XFYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];

}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    self.tableView.separatorStyle = self.hasSeprator?UITableViewCellSeparatorStyleSingleLineEtched: UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorHex(f4f4f4);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFSystemMsgType type = [self.msgs[indexPath.row] integerValue];
    
    switch (type) {

        case XFSystemMsgTypeSystem:
        {
            [XFToolManager showProgressInWindowWithString:@"查看详情"];
        }
            break;
            
        case XFSystemMsgTypeActivity:
        {
            XFActivityViewController *activityVC = [[XFActivityViewController alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
            
        case XFSystemMsgTypeCommentNoPic:
        {
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
            break;

        case XFSystemMsgTypeCommentPic:
        {
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
            break;

        case XFSystemMsgTypeLikeNoPic:
        {
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
            break;
        case XFSystemMsgTypelikePic:
        {
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
            break;

    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.msgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFSystemMsgType type = [self.msgs[indexPath.row] integerValue];
    
    switch (type) {
//        case -1:
//        {
//            XFYueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFYueTableViewCell"];
//
//            if (cell == nil) {
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFYueTableViewCell" owner:nil options:nil] lastObject];
//
//            }
//
//            cell.clickDenyButtonBlock = ^{
//
//
//            };
//
//            cell.clickAcceptButtonBlock = ^{
//
//                [self.msgs addObject:@(1)];
//
//                [self.tableView insertRow:self.msgs.count-1 inSection:0 withRowAnimation:(UITableViewRowAnimationFade)];
//
//                [self.tableView scrollToRow:self.msgs.count-1 inSection:0 atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
//            };
//
//            return cell;
//        }
//            break;
        case XFSystemMsgTypeSystem:
        {
            XFAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAcceptTableViewCell"];

            if (cell == nil) {

                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAcceptTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.commentLabel.text = @"活动期间参与微博美女举办的抽奖送红包活动，通过打开新浪微博app手机客户端扫码进入活动页面参与，按提示参与抢红包均可赢取到一份数额不等的支付宝现金红包奖励，活动期间官方号称将送出总额20万元支付宝现金奖励，所得奖励可以直接在新浪微博app内直接体现至支付宝无任何限制。活动资讯网的网友快去参加试试运气吧！";

            return cell;
        }
            break;
            
        case XFSystemMsgTypeActivity:
        {
            XFAvtivityMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAvtivityMsgTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAvtivityMsgTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return cell;
        }
            break;
            
        case XFSystemMsgTypeCommentNoPic:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }

            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
        
            cell.statusPic.hidden = NO;
            
            cell.hasPicConstain.active = NO;
            cell.hasNoPicContrains.active = YES;
            cell.likeButton.hidden = YES;
            cell.commentBottomContrains.active = YES;
            cell.likeBottomContrains.active = NO;
            return cell;
        }
        case XFSystemMsgTypeCommentPic:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = YES;
            
            cell.hasPicConstain.active = YES;
            cell.hasNoPicContrains.active = NO;
            
            [cell layoutIfNeeded];
            cell.likeButton.hidden = YES;
            cell.commentBottomContrains.active = YES;
            cell.likeBottomContrains.active = NO;
            return cell;
        }
            
        case XFSystemMsgTypeLikeNoPic:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = NO;
            
            cell.hasPicConstain.active = NO;
            cell.hasNoPicContrains.active = YES;
            
            cell.likeButton.hidden = NO;
            cell.commentBottomContrains.active = NO;
            cell.likeBottomContrains.active = YES;
            return cell;
        }
        case XFSystemMsgTypelikePic:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
            
            cell.statusPic.hidden = YES;
            
            cell.hasPicConstain.active = YES;
            cell.hasNoPicContrains.active = NO;
            
            cell.likeButton.hidden = NO;
            cell.commentBottomContrains.active = NO;
            cell.likeBottomContrains.active = YES;
    
            return cell;
        }
    }

    return nil;
}

@end
