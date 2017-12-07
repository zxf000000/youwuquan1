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
#import "XFUserInfoNetWorkManager.h"
#import "XFMoneyNetworkManager.h"

@interface XFMyMoneyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSDictionary *moneyInfo;

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
    
    [self loadData];
}

- (void)loadData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFUserInfoNetWorkManager getMyMoneyInfoWithsuccessBlock:^(NSDictionary *responseDic) {
       
        [HUD hideAnimated:YES];
        if (responseDic) {
            
            self.moneyInfo = responseDic[@"data"][0];
            [self.tableView reloadData];
        }
        
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

    }];
    
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
    
    cell.info = self.moneyInfo;
    
    cell.clickCashButtonBlock = ^{
        
        XFCashViewController *cashVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFCashViewController"];
        
        [self.navigationController pushViewController:cashVC animated:YES];
    };
    
    cell.clickPayButtonBlock = ^{
      
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在充值"];

        // 充值
        [XFMoneyNetworkManager chargeDiamondWithNUm:@"1000" successBlock:^(NSDictionary *responseDic) {
            
            if (responseDic) {
                
                [XFToolManager changeHUD:HUD successWithText:@"充值成功"];
                
                [self loadData];
            }
            [HUD hideAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];

        }];
        
    };
    
    return cell;
    
}

@end
