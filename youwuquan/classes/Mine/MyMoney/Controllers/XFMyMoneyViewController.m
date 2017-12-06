//
//  XFMyMoneyViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyMoneyViewController.h"
#import "XFMyMoneyTableViewCell.h"
#import "XFTxViewController.h"
#import "XFCashViewController.m"

@interface XFMyMoneyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation XFMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的财富";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"交易记录" forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
}

- (void)clickRightButton {
    
    XFTxViewController *txVC = [[XFTxViewController alloc] init];
    
    [self.navigationController pushViewController:txVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenHeight - 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMyMoneyTableViewCell" owner:nil options:nil] lastObject];
    
    cell.clickCashButtonBlock = ^{
        
        XFCashViewController *cashVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFCashViewController"];
        
        [self.navigationController pushViewController:cashVC animated:YES];
    };
    
    return cell;
    
}

@end
