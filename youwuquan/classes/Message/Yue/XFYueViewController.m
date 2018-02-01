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
#import "XFSystemMsgModel.h"
#import "XFLikeCommentModel.h"
#import "XFMessageNetworkManager.h"

@interface XFYueViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;


@end

@implementation XFYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.msgs = [NSMutableArray array];
    
    [self setupTableView];
    
    [self loadData];
    
}

- (void)loadData {
    
    self.page = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *lastDate;
    if ([XFUserInfoManager sharedManager].lastGetNotificationDate) {
        
        lastDate = [XFUserInfoManager sharedManager].lastGetNotificationDate;
        
    } else {
        
        lastDate = @"2017-01-01 01:00:00";
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:-3600 * 24 * 10 sinceDate:[NSDate date]];
    
    lastDate = [dateFormatter stringFromDate:date];
    
    switch(self.type) {
            
        case LikeComment:
        {
            [XFMessageNetworkManager getPersonalNotificationWithDate:lastDate type:@"like,comment" successBlock:^(id responseObj) {
                
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
                
                self.msgs = arrLike;
                
                [self.tableView reloadData];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
            
        }
            break;
        case System:
        {
            [XFMessageNetworkManager getSystemNotificationListWithPage:self.page size:10 successBlock:^(id responseObj) {
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < datas.count; i ++ ) {
                    
                    [arr addObject:[XFSystemMsgModel modelWithDictionary:datas[i]]];
                    
                }
                
                self.msgs = arr;
                
                [self.tableView reloadData];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
        case  Activity:
        {
            [XFMessageNetworkManager getPersonalNotificationWithDate:lastDate type:@"reward,gift,yellowPicture" successBlock:^(id responseObj) {
                
                NSArray *likeComments = (NSArray *)responseObj;
                NSMutableArray *arrLike = [NSMutableArray array];
                
                for (int i = 0 ; i < likeComments.count ; i ++ ) {
                    
                    [arrLike addObject:[XFLikeCommentModel modelWithDictionary:likeComments[i]]];
                    
                }
                
                self.msgs = arrLike;
                
                [self.tableView reloadData];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
            
        }
            break;
    }
    
}

- (void)loadMoreData {
    
    self.page += 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *lastDate;
    if ([XFUserInfoManager sharedManager].lastGetNotificationDate) {
        
        lastDate = [XFUserInfoManager sharedManager].lastGetNotificationDate;
        
    } else {
        
        lastDate = @"2017-01-01 01:00:00";
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:-3600 * 24 * 10 sinceDate:[NSDate date]];
    
    lastDate = [dateFormatter stringFromDate:date];
    
    switch(self.type) {
            
        case LikeComment:
        {
            [self.tableView.mj_footer endRefreshing];

            [XFMessageNetworkManager getPersonalNotificationWithDate:lastDate type:@"like,comment" successBlock:^(id responseObj) {
                
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
                
                self.msgs = arrLike.copy;
                
                [self.tableView reloadData];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
            
        }
            break;
        case System:
        {
            [XFMessageNetworkManager getSystemNotificationListWithPage:self.page size:10 successBlock:^(id responseObj) {
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < datas.count; i ++ ) {
                    
                    [arr addObject:[XFSystemMsgModel modelWithDictionary:datas[i]]];
                    
                }
                
                [self.msgs addObjectsFromArray:arr.copy];
                
                [self.tableView reloadData];
                
                [self.tableView.mj_footer endRefreshing];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
        case  Activity:
        {
            [self.tableView.mj_footer endRefreshing];

            [XFMessageNetworkManager getPersonalNotificationWithDate:lastDate type:@"reward,gift,yellowPicture" successBlock:^(id responseObj) {
                
                NSArray *likeComments = (NSArray *)responseObj;
                NSMutableArray *arrLike = [NSMutableArray array];
                
                for (int i = 0 ; i < likeComments.count ; i ++ ) {
                    
                    [arrLike addObject:[XFLikeCommentModel modelWithDictionary:likeComments[i]]];
                    
                }
                
                self.msgs = arrLike.copy;
                
                [self.tableView reloadData];
                
            } failBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
            
        }
            break;
    }
    
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    self.tableView.separatorStyle = self.hasSeprator?UITableViewCellSeparatorStyleSingleLineEtched: UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorHex(f4f4f4);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    XFSystemMsgType type = [self.msgs[indexPath.row] integerValue];
    //
    //    switch (type) {
    //
    //        case XFSystemMsgTypeSystem:
    //        {
    //            [XFToolManager showProgressInWindowWithString:@"查看详情"];
    //        }
    //            break;
    //
    //        case XFSystemMsgTypeActivity:
    //        {
    //            XFActivityViewController *activityVC = [[XFActivityViewController alloc] init];
    //            [self.navigationController pushViewController:activityVC animated:YES];
    //        }
    //            break;
    //
    //        case XFSystemMsgTypeCommentNoPic:
    //        {
    //            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
    //
    //            [self.navigationController pushViewController:statusVC animated:YES];
    //        }
    //            break;
    //
    //        case XFSystemMsgTypeCommentPic:
    //        {
    //            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
    //
    //            [self.navigationController pushViewController:statusVC animated:YES];
    //        }
    //            break;
    //
    //        case XFSystemMsgTypeLikeNoPic:
    //        {
    //            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
    //
    //            [self.navigationController pushViewController:statusVC animated:YES];
    //        }
    //            break;
    //        case XFSystemMsgTypelikePic:
    //        {
    //            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
    //
    //            [self.navigationController pushViewController:statusVC animated:YES];
    //        }
    //            break;
    
    //    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.msgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.type) {
            
        case Activity:
        {
            XFAvtivityMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAvtivityMsgTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAvtivityMsgTableViewCell" owner:nil options:nil] lastObject];
            }
            
            XFLikeCommentModel *model = self.msgs[indexPath.row];
            NSData *jsonData = [model.extraJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
            
            if ([model.type isEqualToString:@"reward"]) {
                
                cell.titleLabel.text = @"打赏信息";
                cell.detailLabel.text = [NSString stringWithFormat:@"%@打赏了你",info[@"nickName"]];
                cell.desbutton.hidden = YES;
            } else if ([model.type isEqualToString:@"yellowPicture"]) {
                
                cell.titleLabel.text = @"活动通知";
                cell.detailLabel.text = @"活动报名成功";
                
            }
            
            return cell;
        }
            break;
        case LikeComment:
        {
            // XFCommentMessageTableViewCell
            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
            }
            
            XFLikeCommentModel *model = self.msgs[indexPath.row];
            NSData *jsonData = [model.extraJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
            
            if ([model.type isEqualToString:@"like"]) {
                
                cell.contentLabel.text = [NSString stringWithFormat:@"%@点赞了你的动态",info[@"nickname"]];
                
                if (info[@"imgUrl"]) {
                    
                    cell.statusPic.hidden = NO;
                    cell.hasNoPicContrains.active = NO;
                    cell.hasPicConstain.active = YES;
                    
                    [cell.statusPic setImageWithURL:[NSURL URLWithString:info[@"imgUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
                } else {
                    cell.statusPic.hidden = YES;
                    cell.hasNoPicContrains.active = YES;
                    cell.hasPicConstain.active = NO;
                }
                
                cell.likeButton.hidden = NO;
                cell.commentBottomContrains.active = NO;
                cell.likeBottomContrains.active = YES;
                
                return cell;
                
            } else {
                
                cell.contentLabel.text = [NSString stringWithFormat:@"%@评论了你的动态",info[@"nickname"]];
                
                if (info[@"imgUrl"]) {
                    
                    cell.statusPic.hidden = NO;
                    cell.hasNoPicContrains.active = NO;
                    cell.hasPicConstain.active = YES;
                    
                    [cell.statusPic setImageWithURL:[NSURL URLWithString:info[@"imgUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
                } else {
                    cell.statusPic.hidden = YES;
                    cell.hasNoPicContrains.active = YES;
                    cell.hasPicConstain.active = NO;
                }
                
                [cell layoutIfNeeded];
                cell.likeButton.hidden = YES;
                cell.commentBottomContrains.active = YES;
                cell.likeBottomContrains.active = NO;
                
            }
            
            [cell.iconView setImageWithURL:[NSURL URLWithString:info[@"headIconUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
            
            return cell;
        }
            break;
        case System:
        {
            XFSystemMsgModel *model = self.msgs[indexPath.row];
            
            XFAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAcceptTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAcceptTableViewCell" owner:nil options:nil] lastObject];
            }
            cell.titleLabel.text = @"系统消息";
            cell.commentLabel.text = model.text;
            
            return cell;
        }
            break;
            
            
    }
    
    return nil;
}



//    switch (type) {
//
//        case XFSystemMsgTypeSystem:
//        {
//
//        }
//            break;
//
//        case XFSystemMsgTypeActivity:
//        {

//        }
//            break;
//
//        case XFSystemMsgTypeCommentNoPic:
//        {

//        }
//        case XFSystemMsgTypeCommentPic:
//        {
//            // XFCommentMessageTableViewCell
//            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
//
//            if (cell == nil) {
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
//            }
//
//            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
//
//            cell.statusPic.hidden = YES;
//
//            cell.hasPicConstain.active = YES;
//            cell.hasNoPicContrains.active = NO;
//
//            [cell layoutIfNeeded];
//            cell.likeButton.hidden = YES;
//            cell.commentBottomContrains.active = YES;
//            cell.likeBottomContrains.active = NO;
//            return cell;
//        }
//
//        case XFSystemMsgTypeLikeNoPic:
//        {
//            // XFCommentMessageTableViewCell
//            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
//
//            if (cell == nil) {
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
//            }
//
//            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
//
//            cell.statusPic.hidden = NO;
//
//            cell.hasPicConstain.active = NO;
//            cell.hasNoPicContrains.active = YES;
//
//            cell.likeButton.hidden = NO;
//            cell.commentBottomContrains.active = NO;
//            cell.likeBottomContrains.active = YES;
//            return cell;
//        }
//        case XFSystemMsgTypelikePic:
//        {
//            // XFCommentMessageTableViewCell
//            XFCommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFCommentMessageTableViewCell"];
//
//            if (cell == nil) {
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFCommentMessageTableViewCell" owner:nil options:nil] lastObject];
//            }
//
//            cell.contentLabel.text = @"比你好看的人平困了你的动态:我是你芭比";
//
//            cell.statusPic.hidden = YES;
//
//            cell.hasPicConstain.active = YES;
//            cell.hasNoPicContrains.active = NO;
//
//            cell.likeButton.hidden = NO;
//            cell.commentBottomContrains.active = NO;
//            cell.likeBottomContrains.active = YES;
//
//            return cell;
//        }
//    }

//    return nil;


@end
