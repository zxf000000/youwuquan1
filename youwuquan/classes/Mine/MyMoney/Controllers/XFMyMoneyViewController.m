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
#import "XFPayViewController.h"
#import "XFCHouJiangViewController.h"
#import "XFShareCardViewController.h"
#import "XFYwqAlertView.h"
#import "XFAlertViewController.h"
#import "XFMineNetworkManager.h"

@implementation XFMyMoneyModel

@end

@interface XFMyMoneyViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *moneyInfo;

@property (nonatomic,strong) XFMyMoneyModel *model;

@end

@implementation XFMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的财富";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.moneyInfo = [NSMutableDictionary dictionary];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 40))];
    [rightButton setTitle:@"交易记录" forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadData];

    
}

- (void)loadData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
//    [XFMineNetworkManager getMyWalletDataWithSuccessBlock:^(id responseObj) {
//
//        NSDictionary *balance = (NSDictionary *)responseObj;
//
//        [balance enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//
//            [self.moneyInfo setObject:obj forKey:key];
//
//        }];
    
        [XFMineNetworkManager getMyWalletDetailWithsuccessBlock:^(id responseObj) {
            
            [HUD hideAnimated:YES];
            NSLog(@"%@",responseObj);
            [(NSDictionary *)responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [self.moneyInfo setObject:obj forKey:key];
            }];
            
            self.model = [XFMyMoneyModel modelWithDictionary:self.moneyInfo];
            
            [self.tableView reloadData];

        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
//    } failedBlock:^(NSError *error) {
//
//        [HUD hideAnimated:YES];
//
//    } progressBlock:^(CGFloat progress) {
//
//
//    }];

    
//    [XFUserInfoNetWorkManager getMyMoneyInfoWithsuccessBlock:^(NSDictionary *responseDic) {
//
//        [HUD hideAnimated:YES];
//        if (responseDic) {
//
//            self.moneyInfo = responseDic[@"data"][0];
//            [self.tableView reloadData];
//        }
//
//    } failedBlock:^(NSError *error) {
//
//        [HUD hideAnimated:YES];
//
//    }];
    
}

- (void)loadDataWithoutProgress {
    
    [XFUserInfoNetWorkManager getMyMoneyInfoWithsuccessBlock:^(NSDictionary *responseDic) {
        
        if (responseDic) {
            
            self.moneyInfo = responseDic[@"data"][0];
            [self.tableView reloadData];
        }
    
    } failedBlock:^(NSError *error) {
        
        
    }];
    
}

- (void)clickRightButton {
    
    XFTxViewController *txVC = [[XFTxViewController alloc] init];
    
    [self.navigationController pushViewController:txVC animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return kScreenHeight - 64;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMyMoneyTableViewCell" owner:nil options:nil] lastObject];
    
    cell.model = self.model;
    
    cell.clickCashButtonBlock = ^{
        
        XFCashViewController *cashVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFCashViewController"];
        
        cashVC.canCashMoney = [NSString stringWithFormat:@"%@",self.moneyInfo[@"balance"]];
        
        [self.navigationController pushViewController:cashVC animated:YES];
        
    };
    
    cell.clickPayButtonBlock = ^{
      
        XFPayViewController *payVC = [[XFPayViewController alloc] init];
        
//        payVC.type = XFPayVCTypeCharge;
        
        [self.navigationController pushViewController:payVC animated:YES];
        
    };
    
//    cell.clickChouJiangBlock = ^{
//
//        XFCHouJiangViewController *choujiangVC = [[XFCHouJiangViewController alloc] init];
//
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:choujiangVC];
//
//        [self presentViewController:navi animated:YES completion:nil];
//
//    };
    
    cell.clickShareButtonBlock = ^{
        
        XFShareCardViewController *shareSelectVC = [[XFShareCardViewController alloc] init];
        
        [self.navigationController pushViewController:shareSelectVC animated:YES];
        
    };
    
    cell.clickCoinButtonBlock = ^{
      
        XFAlertViewController *alertVC = [[XFAlertViewController alloc] init];
        alertVC.type = XFAlertViewTypeChangeCoin;
        
        __weak typeof(alertVC) weakAlert = alertVC;
        alertVC.clickDoneButtonBlock = ^(XFAlertViewController *alert) {
            
            // 点击兑换
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:[UIApplication sharedApplication].keyWindow];
            [XFMineNetworkManager exchangeCoinsNumForDiamonds:[weakAlert.numberTextField.text longValue] successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"兑换成功"];
                
                [self loadData];

            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
            
            
        };
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    };
    
    return cell;
    
}

@end
