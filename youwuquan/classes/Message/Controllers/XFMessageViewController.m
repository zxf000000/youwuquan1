//
//  XFMessageViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMessageViewController.h"
#import "XFMessageListTableViewCell.h"
#import "XFRewardedTableViewCell.h"
#import "XFChatViewController.h"
#import "XFYueViewController.h"
#import "XFMessageCacheManager.h"
#import "XFHomeCacheManger.h"
#import "XFNearModel.h"
#import "XFMessageNetworkManager.h"
#import "XFSystemMsgModel.h"
#import "XFLikeCommentModel.h"
#import "XFHomeNetworkManager.h"
#import "XFFindDetailViewController.h"

@interface XFMessageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *cellTitles;

@property (nonatomic,copy) NSArray *cellIcons;

@property (nonatomic,copy) NSArray *nearData;

@property (nonatomic,copy) NSArray *systemNOtification;
@property (nonatomic,copy) NSArray *activityNotification;
@property (nonatomic,copy) NSArray *statusNotification;
@property (nonatomic,assign) NSInteger *likeCommentCount;

@end

@implementation XFMessageViewController

- (instancetype)init {
    
    if (self = [super init]) {
        // 头部的高度
        _headerHeight = 65 * (self.cellIcons.count + 1) + 136 + 15 + 15;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self setupTableView];
    
//    // 从首页缓存的附近的人拿到数据
//    if ([XFHomeCacheManger sharedManager].nearData) {
//
//        self.nearData = [XFHomeCacheManger sharedManager].nearData;
//
//        [self.tableView reloadData];
//    }
    
    [self loadNearData];
}

- (void)loadNearData {
    
    [XFHomeNetworkManager getNearbyDataWithSex:@"" longitude:[XFUserInfoManager sharedManager].userLong latitude:[XFUserInfoManager sharedManager].userLati distance:100 page:0 size:10 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFNearModel modelWithDictionary:datas[i]]];
            
        }
        // 成功之后
        //        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:(UITableViewRowAnimationFade)];
        self.nearData = arr.copy;
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)setLikeDatas:(NSArray *)likeDatas {
    
    _likeDatas = likeDatas;
    
    [_tableView reloadSection:2 withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (void)setOtherDatas:(NSArray *)otherDatas {
    
    _otherDatas = otherDatas;
    
    [_tableView reloadSection:0 withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    
    if (indexPath.section == 0) {
        
        XFYueViewController *chatVC = [[XFYueViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.msgs = [NSMutableArray arrayWithArray:self.otherDatas];
        chatVC.title = @"综合消息";
        chatVC.hasSeprator = NO;
        chatVC.type = Activity;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    } else {
        
        XFYueViewController *chatVC = [[XFYueViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.msgs = [NSMutableArray arrayWithArray:self.likeDatas];
        chatVC.title = @"动态互动";
        chatVC.hasSeprator = YES;
        chatVC.type = LikeComment;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
            
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return self.cellIcons.count;
        }
            break;
            
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 136;
    }
    
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return 15;
            
        }
            break;
        case 1:
        {
            return 15;
            
        }
            break;
        case 2:
        {
            
            return 0;
        }
            break;
        default:
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] init];
    
    header.backgroundColor = kBgGrayColor;
    
    header.backgroundColor = [UIColor clearColor];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] init];
    
    header.backgroundColor = kBgGrayColor;
    header.backgroundColor = [UIColor clearColor];

    return header;}

//去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 47;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        XFRewardedTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFRewardedTableViewCell" owner:nil options:nil] lastObject];
        cell.datas = self.nearData;
        cell.didSelectedNearDataWithModel = ^(XFNearModel *model) {
          
            XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
            detailVC.userId = model.uid;
            detailVC.userName = model.nickname;
            detailVC.iconUrl = model.headIconUrl;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        };
        return cell;
    }
    
    XFMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMessageListTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMessageListTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    if (indexPath.section == 0) {
        
        [cell setMyShadow];
        
        cell.iconImage.image = [UIImage imageNamed:@"message_gg"];
        cell.titleLabel.text = @"综合消息";
        cell.countLabel.text = [NSString stringWithFormat:@"%zd",self.otherDatas.count];
        
        if (self.otherDatas.count == 0) {
            
            cell.countLabel.hidden = YES;
        }
        
        XFLikeCommentModel *model = [self.otherDatas firstObject];
        
        if ([XFUserInfoManager sharedManager].lastGetNotificationDate) {
            
            cell.timeLabel.text = [[XFUserInfoManager sharedManager].lastGetNotificationDate substringWithRange:(NSMakeRange(5, 5))];
            
        } else {
            
            cell.timeLabel.hidden = YES;
        }
        
        if (model) {
            
            cell.timeLabel.text = [XFToolManager changeLongToDateWith:model.creatTime];
            
            NSData *jsonData = [model.extraJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
            
            if ([model.type isEqualToString:@"reward"]) {
                
                cell.detailLabel.text = [NSString stringWithFormat:@"%@打赏了你",info[@"nickname"]];
                
            } else if ([model.type isEqualToString:@"yellowPicture"]) {
                
                cell.detailLabel.text = @"有新的活动消息";
                
            }
        }
    }
    
    if (indexPath.section == 1 || indexPath.row == 7) {
        
        [cell setMyShadow];
        
    }
    
    if (indexPath.section == 2) {
        
        cell.countLabel.text = [NSString stringWithFormat:@"%zd",self.likeDatas.count];
        
        if (self.likeDatas.count == 0) {
            
            cell.countLabel.hidden = YES;
        }
        cell.iconImage.image = [UIImage imageNamed:@"message_like"];
        cell.titleLabel.text = @"动态互动";
        // 获取最近的一条消息
        XFLikeCommentModel *model = [self.likeDatas firstObject];
        if (model) {
            
            cell.timeLabel.text = [XFToolManager changeLongToDateWith:model.creatTime];
            NSData *jsonData = [model.extraJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers) error:nil];
            
            if ([model.type isEqualToString:@"like"]) {
                
                cell.detailLabel.text = [NSString stringWithFormat:@"%@点赞了你的动态",info[@"nickname"]];
                
            } else {
                
                cell.detailLabel.text = [NSString stringWithFormat:@"%@评论了你的动态",info[@"nickname"]];
                
            }
        }
    }
    return cell;
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kBgGrayColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
    }];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.scrollEnabled = NO;
}

- (NSArray *)cellTitles {
    if (_cellTitles == nil) {
        
        _cellTitles = @[@"动态互动"];
    }
    return _cellTitles;
    
}

- (NSArray *)cellIcons {
    if (_cellIcons == nil) {
        
        _cellIcons = @[@"message_like"];
        
    }
    return _cellIcons;
    
}

@end
