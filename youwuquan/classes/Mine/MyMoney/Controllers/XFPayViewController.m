//
//  XFPayViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPayViewController.h"
#import "XFSlideView.h"
#import "XFVipTableViewCell.h"
#import "XFChargeTableViewCell.h"
#import "XFChargeSuccessViewController.h"
#import "XFChargeSmallTableViewCell.h"
#import "XFMineNetworkManager.h"


@interface XFPayViewController () <UITableViewDelegate,UITableViewDataSource,XFVipTableViewCellDelegate,XChargeTableViewCellDelegate>

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,weak) UIButton *chargeButton;

@property (nonatomic,weak) UIButton *vipButton;

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,strong) UITableView *vipView;
@property (nonatomic,strong) UITableView *chargView;

@property (nonatomic,strong) UILabel *totalLabel;

@property (nonatomic,copy) NSArray *chargeInfos;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) UIButton *alipayButton;
@property (nonatomic,strong) UIButton *wechatButton;

@property (nonatomic,strong) UIButton *chargePayButton;

@property (nonatomic,copy) NSString *chargeNumber;
@property (nonatomic,copy) NSString *vipNum;

@property (nonatomic,assign) NSInteger vipChargeDays;
@property (nonatomic,assign) NSInteger vipPayType;

@property (nonatomic,copy) NSDictionary *vippayInfo;

@property (nonatomic,copy) NSDictionary *vipInfo;

@end

@implementation XFPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.chargeInfos = @[@{@"diamonds":@"80",@"money":@"6元"},
                         @{@"diamonds":@"10",@"money":@"1元"},
                         @{@"diamonds":@"60",@"money":@"6元"},
                         @{@"diamonds":@"500(送50)",@"money":@"45元"},
                         @{@"diamonds":@"750(送70)",@"money":@"68元"},
                         @{@"diamonds":@"1380(送100)",@"money":@"128元"},
                         @{@"diamonds":@"2200(送220)",@"money":@"198元"},
                         @{@"diamonds":@"4000(送620)",@"money":@"388元"}];
    
    [self setupTopView];
    [self setupScrolLView];
    
    [self loadvipInfo];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)loadvipInfo {
    
    [XFMineNetworkManager getMyVipInfoWithsuccessBlock:^(id responseObj) {
    
        self.vipInfo = (NSDictionary *)responseObj;
        
    } failedBlock:^(NSError *error) {
        
        if (!error) {
            
            // vip卡未激活
            
            
        }
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

// 充值
- (void)clickChargeButton {
    
    if (!self.selectedIndexPath) {
      
        [XFToolManager showProgressInWindowWithString:@"请选择充值金额"];
        
        return;
        
    }
    
    if (!(self.alipayButton.selected || self.wechatButton.selected)) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择充值方式"];
        
        return;
    }
    
    NSString *chargeNumber = self.chargeInfos[self.selectedIndexPath.row][@"diamonds"];
    
    if ([chargeNumber containsString:@"("]) {
        
        NSRange range = [chargeNumber rangeOfString:@"("];
    
        chargeNumber = [chargeNumber substringToIndex:range.location];
        
    }
    
    // 充值
    [XFMineNetworkManager chargeWithNumber:chargeNumber successBlock:^(id responseObj) {
        
        // 充值成功,刷新
        [self.navigationController pushViewController:[[XFChargeSuccessViewController alloc] init] animated:YES];
        
        // 刷新财富页面
        
        
    } failedBlock:^(NSError *error) {
        
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.type == XFPayVCTypeCharge) {
        
        [self clickTopButton:self.chargeButton];
        
    }
}

- (void)clickBackButton {
    
    [super clickBackButton];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)clickTopButton:(UIButton *)sender {
    
    CGFloat centerOffset = 0;
    
    if (sender == self.vipButton) {
        
        centerOffset = -45;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (sender == self.chargeButton) {
        
        centerOffset = 45;
        self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);

    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    for (UIButton *button in self.titleButtons) {
        
        if (sender == button) {
            
            button.selected = YES;
            
        } else {
            
            button.selected = NO;
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    if (scrollView != self.scrollView) {
        
        return;
    }
   
    if (scrollView.contentOffset.x != 0) {
        
        self.chargeButton.selected = YES;
        self.vipButton.selected = NO;


    } else {
        
        self.chargeButton.selected = NO;
        self.vipButton.selected = YES;
    }
    
    CGFloat centerOffset = 0;
    
    if (self.vipButton.selected) {
        
        centerOffset = -45;
    }
    if (self.chargeButton.selected) {
        
        centerOffset = 45;
        
    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
}

#pragma mark - cellDelegate
- (void)vipTableViewCell:(XFVipTableViewCell *)cell didClickPayButton:(UIButton *)payButton {
    
    // 充值vip
    if (self.vipChargeDays == 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择vip类型"];
        
        return;
        
    }
    
    if (self.vipPayType == 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择充值方式"];
        
        return;
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    switch (self.vipPayType) {
            
        case 1:
        {
            // 微信
            [XFMineNetworkManager buyVipWithWechatWithDays:self.vipChargeDays successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"购买成功!"];
                XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
                
                successVC.type = XFSuccessViewTypeVipSuccess;
                
                [self.navigationController pushViewController:successVC animated:YES];
            } failedBlock:^(NSError *error) {
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
        case 2:
        {
            // 支付宝
            [XFMineNetworkManager buyVipWithAlipayWithDays:self.vipChargeDays successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"购买成功!"];
                XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
                
                successVC.type = XFSuccessViewTypeVipSuccess;
                
                [self.navigationController pushViewController:successVC animated:YES];
                
            } failedBlock:^(NSError *error) {
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
        case 3:
        {
            // 钻石
            [XFMineNetworkManager buyVipWithDiamondsWithDays:self.vipChargeDays successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"购买成功!"];
                XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
                
                successVC.type = XFSuccessViewTypeVipSuccess;
                
                [self.navigationController pushViewController:successVC animated:YES];
                
            } failedBlock:^(NSError *error) {
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
            
    }
    

    

}

- (void)chargeTableViewCell:(XFChargeTableViewCell *)cell didClickPayButton:(UIButton *)payButton {
    
    
    
    XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
    
    successVC.type = XFSuccessViewTypeChargeFailed;
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.chargView) {
        
        XFChargeSmallTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.selected = NO;
        
        if (self.selectedIndexPath) {
            
            XFChargeSmallTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];

            selectedCell.monneyButton.selected = NO;
            selectedCell.monneyButton.layer.borderColor = UIColorHex(808080).CGColor;
        }
        
        cell.monneyButton.selected = YES;
        cell.monneyButton.layer.borderColor = kMainRedColor.CGColor;
        
        self.selectedIndexPath = indexPath;
    
    }
    
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _vipView) {
    
        return 1;
        
    } else {
        
        return self.chargeInfos.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _vipView) {
        
        XFVipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFVipTableViewCell"];
        
        if (!cell)  {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XFVipTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.delegate = self;
        if (!self.vipInfo) {
            
            cell.daysLeftLabel.text = @"还未开通会员";
        } else {

        }
        __weak typeof(cell) weakCell = cell;
        cell.selectedVipCardBlock = ^(NSInteger index) {
          
            switch (index) {
                case 0:
                {
                    self.vipChargeDays = 30;

                }
                    break;
                case 1:{
                    self.vipChargeDays = 90;

                }
                    break;
                case 2:{
                    
                    self.vipChargeDays = 365;

                }
                    break;
                    
                default:
                    break;
            }
            
            // 获取需要多少钱
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
            
            [XFMineNetworkManager chargeVipWithDays:[NSString stringWithFormat:@"%zd",self.vipChargeDays] successBlock:^(id responseObj) {
                
                [HUD hideAnimated:YES];
                
                NSDictionary *vipInfo = (NSDictionary *)responseObj;
                self.vippayInfo = vipInfo;
                
                if (self.vipPayType == 3) {
                    [weakCell.payButton setTitle:[NSString stringWithFormat:@"支付%@钻石",vipInfo[@"diamonds"]] forState:(UIControlStateNormal)];

                } else {
                    
                    [weakCell.payButton setTitle:[NSString stringWithFormat:@"支付%@元",vipInfo[@"price"]] forState:(UIControlStateNormal)];

                }
                
                
            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
                
            }];
            
            
        };
        
        cell.selectedPayTypeBlock = ^(NSInteger index) {
          
            self.vipPayType = index;
            
            if (self.vippayInfo) {
                
                switch (index) {
                        
                    case 3:
                    {
                        [weakCell.payButton setTitle:[NSString stringWithFormat:@"支付%@钻石",self.vippayInfo[@"diamonds"]] forState:(UIControlStateNormal)];

                    }
                        break;
                    default:
                    {
                        [weakCell.payButton setTitle:[NSString stringWithFormat:@"支付%@元",self.vippayInfo[@"price"]] forState:(UIControlStateNormal)];

                    }
                        break;
                        
                }
                
            }
            
        };
        
        return cell;

    } else {
        
        XFChargeSmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFChargeSmallTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XFChargeSmallTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.info = self.chargeInfos[indexPath.row];
        
        cell.indexPath = indexPath;
        
        if (self.selectedIndexPath == indexPath) {
            
            cell.monneyButton.selected = YES;
            cell.monneyButton.layer.borderColor = kMainRedColor.CGColor;
        }
        
        cell.clickButtonBlock = ^(NSIndexPath *indexPath, UIButton *moneyButton) {
            
            if (self.selectedIndexPath) {
                
                XFChargeSmallTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
                
                selectedCell.monneyButton.selected = NO;
                selectedCell.monneyButton.layer.borderColor = UIColorHex(808080).CGColor;
            }
            
            moneyButton.selected = YES;
            moneyButton.layer.borderColor = kMainRedColor.CGColor;
            
            self.selectedIndexPath = indexPath;
            
            
        };
        
        return cell;
    }
    
}

- (void)setupScrolLView {
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.vipView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.vipView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.vipView];
    
    self.chargView = [[UITableView alloc] initWithFrame:(CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.chargView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.chargView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    self.scrollView.pagingEnabled = YES;
    
    self.chargView.delegate = self;
    self.chargView.dataSource = self;
    self.vipView.delegate = self;
    self.vipView.dataSource = self;
    
    self.vipView.estimatedRowHeight = kScreenHeight;
    self.vipView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.vipView.showsVerticalScrollIndicator = NO;
    self.chargView.estimatedRowHeight = kScreenHeight;
//    self.chargView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chargView.showsVerticalScrollIndicator = NO;
    
    // 头部
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    self.chargView.tableHeaderView = headerView;
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = UIColorHex(808080);
    topLabel.text = @"我的钻石";
    topLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:topLabel];
    
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.textColor = [UIColor blackColor];
    self.totalLabel.text = @"123";
    self.totalLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview:self.totalLabel];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = [UIColor blackColor];
    desLabel.text = @"请选择充值金额";
    desLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:desLabel];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.top.mas_offset(15);
        
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(topLabel.mas_bottom).offset(20);
        make.centerX.mas_offset(0);
        
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(15);
        make.bottom.mas_offset(-10);
        
    }];
    
    [self setupFooter];
}

- (void)setupFooter {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 250);
    self.chargView.tableFooterView = footerView;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = [UIColor blackColor];
    desLabel.text = @"请选择充值方式";
    desLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:desLabel];
    
    self.alipayButton = [[UIButton alloc] init];
    [self.alipayButton setImage:[UIImage imageNamed:@"date_zhifubao"] forState:(UIControlStateNormal)];
    [self.alipayButton setBackgroundImage:[UIImage imageNamed:@"my_weixuanze"] forState:(UIControlStateNormal)];
    [self.alipayButton setBackgroundImage:[UIImage imageNamed:@"my_xuanze"] forState:(UIControlStateSelected)];
    [self.alipayButton setTitle:@" 支付宝" forState:(UIControlStateNormal)];
    [self.alipayButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.alipayButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.alipayButton];
    
    self.wechatButton = [[UIButton alloc] init];
    [self.wechatButton setImage:[UIImage imageNamed:@"date_wechat"] forState:(UIControlStateNormal)];
    [self.wechatButton setBackgroundImage:[UIImage imageNamed:@"my_weixuanze"] forState:(UIControlStateNormal)];
    [self.wechatButton setBackgroundImage:[UIImage imageNamed:@"my_xuanze"] forState:(UIControlStateSelected)];
    [self.wechatButton setTitle:@" 微信" forState:(UIControlStateNormal)];
    [self.wechatButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.wechatButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [footerView addSubview:self.wechatButton];

    self.chargePayButton = [[UIButton alloc] init];
    [self.chargePayButton setTitle:@"支付" forState:(UIControlStateNormal)];
    self.chargePayButton.backgroundColor = kMainRedColor;
    self.chargePayButton.layer.cornerRadius = 22;
    [footerView addSubview:self.chargePayButton];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.mas_offset(15);
        
    }];
    
    [self.alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(desLabel.mas_bottom).offset(20);
        make.left.mas_offset(20);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(60);
        
    }];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(desLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.alipayButton.mas_right).offset(20);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(60);
        
    }];
    
    [self.chargePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.alipayButton.mas_bottom).offset(56);
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.alipayButton addTarget:self action:@selector(clickPayTypebutton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.wechatButton addTarget:self action:@selector(clickPayTypebutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.chargePayButton addTarget:self action:@selector(clickChargeButton) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)clickPayTypebutton:(UIButton *)sender {
    
    if (sender == self.alipayButton) {
        self.alipayButton.selected = YES;
        self.wechatButton.selected = NO;
    } else {
        
        self.alipayButton.selected = NO;
        self.wechatButton.selected = YES;
    }
    
}

- (void)setupTopView {
    
    UIView *titleView = [[UIView alloc] init];
    
    titleView.frame = CGRectMake(0, 0, 180, 44);
    
    self.navigationItem.titleView = titleView;

    
    UIButton *whButton = [[UIButton alloc] init];
    
    [whButton setTitle:@"会员" forState:(UIControlStateNormal)];
    
    [whButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [whButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    whButton.titleLabel.font = [UIFont systemFontOfSize:16];
    whButton.tag = 1001;
    [titleView addSubview:whButton];
    whButton.selected = YES;
    
    UIButton *yyButton = [[UIButton alloc] init];
    
    [yyButton setTitle:@"充值" forState:(UIControlStateNormal)];
    
    [yyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [yyButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    yyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    yyButton.tag = 1002;
    [titleView addSubview:yyButton];
    
    
    self.slideView = [[UIView alloc] init];
    self.slideView.backgroundColor = kMainColor;
    
    self.vipButton = whButton;
    self.chargeButton = yyButton;
    
    self.topView = titleView;
    
    [self.topView addSubview:self.slideView];
    self.titleButtons = @[self.chargeButton,self.vipButton];
    
    [self.chargeButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vipButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)updateViewConstraints {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.mas_offset(0);

    }];
    
    [self.vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(90);
        
    }];
    
    [self.chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.vipButton.mas_right);
        make.top.bottom.right.mas_offset(0);
        make.width.mas_equalTo(90);
    }];
    
    [@[self.chargeButton,self.vipButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
        
    }];
    
    
    CGFloat centerOffset = 0;
    
    if (self.vipButton.selected) {
        
        centerOffset = -45;
    }
    if (self.chargeButton.selected) {
        
        centerOffset = 45;
    }
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    [super updateViewConstraints];
}
@end
