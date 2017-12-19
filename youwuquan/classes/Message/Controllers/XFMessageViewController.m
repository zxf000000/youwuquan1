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

@interface XFMessageViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *cellTitles;

@property (nonatomic,copy) NSArray *cellIcons;

@end

@implementation XFMessageViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        _headerHeight = 65 * (self.cellIcons.count + 1) + 136 + 15 + 15;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self setupTableView];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        XFYueViewController *chatVC = [[XFYueViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.msgs = [NSMutableArray array];
        [chatVC.msgs addObject:@(0)];
        [chatVC.msgs addObject:@(2)];
        [chatVC.msgs addObject:@(2)];
        [chatVC.msgs addObject:@(0)];
        chatVC.title = @"综合消息";
        chatVC.hasSeprator = NO;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    } else {
        
        
        XFYueViewController *chatVC = [[XFYueViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.msgs = [NSMutableArray array];
        [chatVC.msgs addObject:@(4)];
        [chatVC.msgs addObject:@(3)];
        [chatVC.msgs addObject:@(4)];
        [chatVC.msgs addObject:@(3)];
        [chatVC.msgs addObject:@(5)];
        [chatVC.msgs addObject:@(5)];
        [chatVC.msgs addObject:@(6)];
        [chatVC.msgs addObject:@(6)];
        chatVC.title = @"动态互动";
        chatVC.hasSeprator = YES;
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
    }
    
    if (indexPath.section == 1 || indexPath.row == 7) {
        
        [cell setMyShadow];
        
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row < 5) {
            
            cell.iconImage.image = [UIImage imageNamed:self.cellIcons[indexPath.row]];
            cell.titleLabel.text = self.cellTitles[indexPath.row];
            
        }else {
            
            cell.iconImage.image = [UIImage imageNamed:@"zhanweitu44"];
            cell.titleLabel.text = @"小妖精";
            
        }
    }
    
    if (indexPath.row == 3) {
        
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.tableView.contentSize.height - 64);
        
        
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
//    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
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
