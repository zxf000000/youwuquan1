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
