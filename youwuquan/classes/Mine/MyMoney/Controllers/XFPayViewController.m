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
#import "XFVipCollectionViewCell.h"
#import "XFVipModel.h"
#import "XFChargeCollectionViewCell.h"
#import "XFChargeModel.h"
#import "XFPayAlertViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface XFPayViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFVipTableViewCellDelegate,XChargeTableViewCellDelegate,NSXMLParserDelegate>

@property (nonatomic,weak) UIView *topView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,weak) UIButton *chargeButton;

@property (nonatomic,weak) UIButton *vipButton;

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,strong) UIScrollView *vipView;
@property (nonatomic,strong) UIScrollView *chargView;

@property (nonatomic,strong) UICollectionView *vipCollectionView;

@property (nonatomic,strong) UILabel *totalLabel;

@property (nonatomic,copy) NSArray *chargeInfos;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) UIButton *alipayButton;
@property (nonatomic,strong) UIButton *wechatButton;

@property (nonatomic,strong) UIButton *chargePayButton;

@property (nonatomic,copy) NSString *vipNum;

@property (nonatomic,assign) NSInteger vipChargeDays;
@property (nonatomic,assign) NSInteger vipPayType;

@property (nonatomic,copy) NSDictionary *vippayInfo;

@property (nonatomic,copy) NSDictionary *vipInfo;
@property (nonatomic,copy) NSArray *vipList;

@property (nonatomic,strong) UICollectionView *chargeCollectionView;

@property (nonatomic,copy) NSArray *chargeList;

@property (nonatomic,strong) UILabel *diamondsNumLabel;

@property (nonatomic,strong) NSIndexPath *selectedVipIndex;
@property (nonatomic,strong) NSIndexPath *selectedChargeIndex;

@property (nonatomic,assign) NSInteger chargeNumber;

@property (nonatomic,strong) NSMutableDictionary *xmlDictionary;

@property (nonatomic,copy) NSString *currentKey;
@property (nonatomic,assign) long timeStamp;

@property (nonatomic,copy) NSString *wxOrderId;

@property (nonatomic,strong) UILabel *diamondsLabel;

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
    
    
    self.xmlDictionary = [NSMutableDictionary dictionary];
    
    [self setupTopView];
    [self setupScrolLView];
    
    
    [self loadVipList];
    [self loadChargeList];
    
    [self.view setNeedsUpdateConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeCanceled) name:@"chargeCancel" object:nil];

}

- (void)chargeCanceled {
    
    [UIAlertController xfalertControllerWithMsg:@"订单取消" doneBlock:^{
        
        
    }];
    
}

- (void)chargeSuccess {
        /*
         WAIT_BUYER_PAY // 等待买家付款
         TRADE_CLOSED  // 超时关闭
         TRADE_SUCCESS // 支付成功
         TRADE_FINISHED // 支付结束
         
         */
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
        [XFMineNetworkManager getTradeStatusWithOrderId:self.wxOrderId successBlock:^(id responseObj) {
            NSDictionary *responseDic = (NSDictionary *)responseObj;
            NSLog(@"订单状态-----%@",responseDic[@"status"]);
            if ([responseDic[@"status"] isEqualToString:@"TRADE_SUCCESS"]) {
                
                [XFToolManager changeHUD:HUD successWithText:@"支付成功"];
                [self loadData];

            } else {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [XFMineNetworkManager getTradeStatusWithOrderId:self.wxOrderId successBlock:^(id responseObj) {
                        NSDictionary *responseDic = (NSDictionary *)responseObj;
                        NSLog(@"订单状态-----%@",responseDic[@"status"]);
                        if ([responseDic[@"status"] isEqualToString:@"TRADE_SUCCESS"]) {
                            
                            [XFToolManager changeHUD:HUD successWithText:@"支付成功"];
                            [self loadData];

                        } else {
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [XFMineNetworkManager getTradeStatusWithOrderId:self.wxOrderId successBlock:^(id responseObj) {
                                    NSDictionary *responseDic = (NSDictionary *)responseObj;
                                    NSLog(@"订单状态-----%@",responseDic[@"status"]);
                                    if ([responseDic[@"status"] isEqualToString:@"TRADE_SUCCESS"]) {
                                        
                                        [XFToolManager changeHUD:HUD successWithText:@"支付成功"];
                                        
                                        [self loadData];
                                        
                                    } else {
                                        
//                                        [XFToolManager changeHUD:HUD successWithText:@"支付失败"];
                                        [HUD hideAnimated:YES];
                                        [XFToolManager showProgressInWindowWithString:@"支付失败"];
                                        
                                    }
                                    
                                } failedBlock:^(NSError *error) {
                                    [HUD hideAnimated:YES];
                                    
                                } progressBlock:^(CGFloat progress) {
                                    
                                }];
                                
                            });
                            
                        }
                        
                    } failedBlock:^(NSError *error) {
                        [HUD hideAnimated:YES];

                    } progressBlock:^(CGFloat progress) {
                        
                    }];
                    
                });
                
            }
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
        }];
    
    
//    XFChargeSuccessViewController *succesVC = [[XFChargeSuccessViewController alloc] init];
//    succesVC.type = XFSuccessViewTypeChargeSuccess;
//    [self.navigationController pushViewController:succesVC animated:YES];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)loadChargeList {
    
    [XFMineNetworkManager getChargeListWithsuccessBlock:^(id responseObj) {
        
        NSArray *datas = (NSArray *)responseObj;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFChargeModel modelWithDictionary:datas[i]]];
            
        }
        self.chargeList = arr.copy;
        [self.chargeCollectionView reloadData];
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

- (void)loadData {
    
    [XFMineNetworkManager getMyWalletDetailWithsuccessBlock:^(id responseObj) {
        
        self.diamondsLabel.text = [NSString stringWithFormat:@"%@",((NSDictionary *)responseObj)[@"balance"]];
        
    } failedBlock:^(NSError *error) {
        
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)loadVipList {

    [self loadData];
    
    [XFMineNetworkManager getVipListWithsuccessBlock:^(id responseObj) {
        
        NSArray *datas = (NSArray *)responseObj;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFVipModel modelWithDictionary:datas[i]]];
            
        }
        self.vipList = arr.copy;
        [self.vipCollectionView reloadData];
        
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

- (void)loadvipInfo {
    
    [XFMineNetworkManager getMyVipInfoWithsuccessBlock:^(id responseObj) {
    
//        NSArray *vipDatas = (NSArray *)responseObj;
        
        
        
    } failedBlock:^(NSError *error) {
        
        if (!error) {
            
            // vip卡未激活
            
            
        }
        
    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

// 充值
- (void)clickChargeButton {
    
    if (!self.selectedChargeIndex) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择充值金额"];
        
        return;
        
    }
    
    __block NSInteger number;
    
    if (self.selectedChargeIndex.item < self.chargeList.count) {
        
        XFChargeModel *model = self.chargeList[self.selectedChargeIndex.item];
        number = [model.price intValue];
        self.chargeNumber = number;
        [self selectChargeType];

        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入充值金额" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           
            textField.placeholder = @"请输入金额";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
           
            UITextField *textField = alert.textFields[0];
            if (![textField.text isHasContent] || [textField.text intValue] <= 0) {
                
                [XFToolManager showProgressInWindowWithString:@"请输入有效金额"];
                return;
            } else {
                
                self.chargeNumber = [textField.text intValue];
                
                [self selectChargeType];
            }
            
            
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }];
        
        [alert addAction:actionDone];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)chargeWithType:(NSString *)type {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在充值"];
    // 充值
    [XFMineNetworkManager chargeWithNumber:[NSString stringWithFormat:@"%zd",_chargeNumber] type:type successBlock:^(id responseObj) {
        [HUD hideAnimated:YES];

        NSDictionary *dic = (NSDictionary *)responseObj;
        self.wxOrderId = dic[@"order_id"];
        
        NSString *str = dic[@"data"][@"ali"];
        self.timeStamp = [dic[@"timestamp"] longValue];
        if ([type isEqualToString:@"ALIPAY"]) {
//            NSString *orderStr = [str substringWithRange:NSMakeRange(1, str.length-2)];
            NSString *orderStr = str;
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"alipayYWQ" callback:^(NSDictionary *resultDic) {
                
                NSLog(@"%@-----alipay回调",resultDic);
                
                if ([resultDic[@"resultStatus"] intValue] == 9000) {
                    
                }
                
                
            }];
            
        } else {
            
            NSDictionary *data = dic[@"data"];
            
            // 解析结果
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = data[@"partnerid"];
            request.prepayId = data[@"prepayid"];
            request.package = data[@"package"];
            request.nonceStr = data[@"noncestr"];
            request.timeStamp = (UInt32)[data[@"timestamp"] longValue];
            request.sign= data[@"sign"];
            
            [WXApi sendReq:request];
        }
    
    } failedBlock:^(NSError *error) {
        
        NSLog(@"支付请求失败---%@",[error userInfo]);
        
        [HUD hideAnimated:YES];
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"kaishijiexi");
    
    self.xmlDictionary = [NSMutableDictionary dictionary];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.currentKey = elementName;
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    

    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"解析出----%@",string);
    [self.xmlDictionary setObject:string forKey:self.currentKey];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"解析结果---%@",self.xmlDictionary);

}

- (void)selectChargeType {
    
    XFPayAlertViewController *alertVC = [[XFPayAlertViewController alloc] init];
    
    [alertVC addButtonWithImage:nil title:@"取消" handle:^{
        
        
    }];
    
    [alertVC addButtonWithImage:[UIImage imageNamed:@"date_wechat"] title:@"微信支付" handle:^{
        
        [self chargeWithType:@"WECHAT"];

    }];
    [alertVC addButtonWithImage:[UIImage imageNamed:@"date_zhifubao"] title:@"支付宝" handle:^{
        
        [self chargeWithType:@"ALIPAY"];
        
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];

    
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

#pragma mark - 购买vip
- (void)clickPayVipButton {
    
    if (!self.selectedVipIndex) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择充值类型"];
        
        return;
    }
    
    XFVipModel *model = self.vipList[self.selectedVipIndex.item];
    
    XFPayAlertViewController *alertVC = [[XFPayAlertViewController alloc] init];
    
    [alertVC addButtonWithImage:nil title:@"取消" handle:^{
        
        
    }];
    
    [alertVC addButtonWithImage:[UIImage imageNamed:@"date_wechat"] title:@"微信支付" handle:^{
        

        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        
        // 微信
        [XFMineNetworkManager buyVipWithWechatWithDays:[model.day intValue] successBlock:^(id responseObj) {
            
            [HUD hideAnimated:YES];

            // 调用微信支付
            NSDictionary *dic = (NSDictionary *)responseObj;
            
            NSDictionary *data = dic[@"data"];
            
            // 解析结果
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = data[@"partnerid"];
            request.prepayId = data[@"prepayid"];
            request.package = data[@"package"];
            request.nonceStr = data[@"noncestr"];
            request.timeStamp = (UInt32)[data[@"timestamp"] longValue];
            request.sign= data[@"sign"];
            
            [WXApi sendReq:request];
            
        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
        }];
    }];
    [alertVC addButtonWithImage:[UIImage imageNamed:@"date_zhifubao"] title:@"支付宝" handle:^{
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        
        // 支付宝
        [XFMineNetworkManager buyVipWithAlipayWithDays:[model.day intValue] successBlock:^(id responseObj) {
            
            NSDictionary *dic = (NSDictionary *)responseObj;
            
            NSString *orderStr = dic[@"data"][@"ali"];
            
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"alipayYWQ" callback:^(NSDictionary *resultDic) {
                
                NSLog(@"%@-----alipay回调",resultDic);
                
                if ([resultDic[@"resultStatus"] intValue] == 9000) {
                    
                }
                
                
            }];
            
            [HUD hideAnimated:YES];

        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
        }];
    }];
    
    [alertVC addButtonWithImage:[UIImage imageNamed:@"charge_zuanshi"] title:@"钻石" handle:^{
        
                MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        
                // 钻石
                [XFMineNetworkManager buyVipWithDiamondsWithDays:[model.day intValue] successBlock:^(id responseObj) {
        
                    [XFToolManager changeHUD:HUD successWithText:@"购买成功!"];
                    XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
        
                    successVC.type = XFSuccessViewTypeVipSuccess;
        
                    [self.navigationController pushViewController:successVC animated:YES];
        
                } failedBlock:^(NSError *error) {
                    [HUD hideAnimated:YES];
        
                } progressBlock:^(CGFloat progress) {
        
                }];
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}
- (void)chargeTableViewCell:(XFChargeTableViewCell *)cell didClickPayButton:(UIButton *)payButton {
    
    XFChargeSuccessViewController *successVC = [[XFChargeSuccessViewController alloc] init];
    
    successVC.type = XFSuccessViewTypeChargeFailed;
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}


#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.vipCollectionView) {
        
        return self.vipList.count;

    } else {
        
        return self.chargeList.count;
    }
    
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.vipCollectionView) {
        
        XFVipCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFVipCollectionViewCell" forIndexPath:indexPath];

        cell.model = self.vipList[indexPath.item];
        
        cell.index = indexPath;
        if (indexPath == self.selectedVipIndex) {
            
            cell.selected = YES;
        } else {
            
            cell.selected = NO;
        }
        
        if (indexPath.item != 0) {
            
            cell.giftLabel.hidden = YES;
        }
        
        cell.selectedBlock = ^(NSIndexPath *indexPath) {
            
            self.selectedVipIndex = indexPath;
        };
        
        cell.giftLabel.backgroundColor = kRGBColorWith(113, 47, 243);
        return cell;

        
    } else {
        XFChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFChargeCollectionViewCell" forIndexPath:indexPath];
        
        cell.index = indexPath;
        
        cell.model = self.chargeList[indexPath.item];
        cell.isAuto = NO;

        cell.selectedBlock = ^(NSIndexPath *indexPath) {
            
            self.selectedChargeIndex = indexPath;
        };
        
        return cell;
        
    }

    return nil;
}

- (void)setupScrolLView {
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    self.scrollView.pagingEnabled = YES;
    
    [self setupVipView];
    [self setupChargeView];
    
}

- (void)setupVipView {
    
    self.vipView = [[UIScrollView alloc] init];
    self.vipView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.scrollView addSubview:self.vipView];
    
    CGFloat cardWidth = 255 * kScreenWidth / 375.f;
    CGFloat cardHeight = 160 * kScreenWidth / 375.f;
    
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipcard_shadow"]];
    shadowView.frame = CGRectMake((kScreenWidth - cardWidth)/2, 26 + 30, cardWidth, cardHeight);
    [self.vipView addSubview:shadowView];
    
    UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_card"]];
    cardView.frame = CGRectMake((kScreenWidth - cardWidth)/2, 26 , cardWidth, cardHeight);
    [self.vipView addSubview:cardView];
    
    UILabel *desLabbel = [[UILabel alloc] init];
    desLabbel.textColor = [UIColor blackColor];
    desLabbel.font = [UIFont systemFontOfSize:12];
    desLabbel.text = @"会员可免费查看所有用户的私密图片/视频";
    desLabbel.frame = CGRectMake(0, 26 + cardHeight + 17, kScreenWidth, 15);
    desLabbel.textAlignment = NSTextAlignmentCenter;
    [self.vipView addSubview:desLabbel];
    
    UILabel *vipdes = [[UILabel alloc] init];
    vipdes.textColor = [UIColor blackColor];
    vipdes.text = @"尤物VIP会员";
    vipdes.font = [UIFont systemFontOfSize:14];
    vipdes.frame = CGRectMake(13, desLabbel.bottom + 32, 200, 15);
    [self.vipView addSubview:vipdes];
    
    CGFloat itemWidth = 100 * kScreenWidth / 375.f;
    CGFloat itemHeight = 123 / 100.f * itemWidth;
    CGFloat spacing = (kScreenWidth - itemWidth * 3)/4.f;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = spacing;
    layout.minimumInteritemSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(0, spacing, 0, spacing);
    self.vipCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.vipCollectionView.frame = CGRectMake(0, vipdes.bottom + 20, kScreenWidth, itemHeight);
    [self.vipView addSubview:self.vipCollectionView];
    self.vipCollectionView.backgroundColor = [UIColor whiteColor];
    [self.vipCollectionView registerNib:[UINib nibWithNibName:@"XFVipCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFVipCollectionViewCell"];
    self.vipCollectionView.delegate = self;
    self.vipCollectionView.dataSource = self;
    UIButton *payVipButton = [[UIButton alloc] init];
    [payVipButton setTitle:@"立即开通" forState:(UIControlStateNormal)];
    [payVipButton setBackgroundColor:kRGBColorWith(238, 184, 99)];
    payVipButton.layer.cornerRadius = 15;
    payVipButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.vipView addSubview:payVipButton];
    [payVipButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(self.vipCollectionView.mas_bottom).offset(88);
        make.centerX.mas_equalTo(self.vipCollectionView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 46);
        make.height.mas_equalTo(30);
        
    }];
    
    [payVipButton addTarget:self action:@selector(clickPayVipButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 底部距离83
    self.vipView.contentSize = CGSizeMake(kScreenWidth, 26 + cardHeight + 17 + 15 + 32 + 15 + 20 + itemHeight + 88 + 30 + 83);
    
}

- (void)setupChargeView {
    
    self.chargView = [[UIScrollView alloc] init];
    self.chargView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64);
    [self.scrollView addSubview:self.chargView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kRGBColorWith(128, 128, 128);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"我的钻石";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.chargView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, 22, kScreenWidth, 10);
    
    self.diamondsLabel = [[UILabel alloc] init];
    self.diamondsLabel.textColor = [UIColor blackColor];
    self.diamondsLabel.font = [UIFont systemFontOfSize:22];
    self.diamondsLabel.text = self.diamondsNum;
    self.diamondsLabel.textAlignment = NSTextAlignmentCenter;
    [self.chargView addSubview:self.diamondsLabel];
    self.diamondsLabel.frame = CGRectMake(0, titleLabel.bottom + 14, kScreenWidth, 18);
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = [UIColor blackColor];
    desLabel.font = [UIFont systemFontOfSize:15];
    desLabel.text = @"请选择充值金额";
    [self.chargView addSubview:desLabel];
    desLabel.frame = CGRectMake(13, self.diamondsLabel.bottom + 12, kScreenWidth, 15);
    
    CGFloat itemWidth = 100 * kScreenWidth / 375.f;
    CGFloat itemHeight = 123 / 100.f * itemWidth;
    CGFloat spacing = (kScreenWidth - itemWidth * 3)/4.f;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = spacing;
    layout.minimumInteritemSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(0, spacing, 0, spacing);
    
    self.chargeCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.chargeCollectionView.frame = CGRectMake(0, desLabel.bottom + 22, kScreenWidth, itemHeight * 3 + spacing * 2);
    
    [self.chargView addSubview:self.chargeCollectionView];
    self.chargeCollectionView.backgroundColor = [UIColor whiteColor];
    [self.chargeCollectionView registerNib:[UINib nibWithNibName:@"XFChargeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFChargeCollectionViewCell"];
    self.chargeCollectionView.delegate = self;
    self.chargeCollectionView.dataSource = self;
    
    UIButton *chargeButton = [[UIButton alloc] init];
    [chargeButton setTitle:@"立即充值" forState:(UIControlStateNormal)];
    [chargeButton setBackgroundColor:kRGBColorWith(238, 184, 99)];
    chargeButton.layer.cornerRadius = 15;
    chargeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.chargView addSubview:chargeButton];
    [chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chargeCollectionView.mas_bottom).offset(43);
        make.centerX.mas_equalTo(self.chargeCollectionView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 46);
        make.height.mas_equalTo(30);
        
    }];
    
    [chargeButton addTarget:self action:@selector(clickChargeButton) forControlEvents:(UIControlEventTouchUpInside)];
    self.chargView.contentSize = CGSizeMake(kScreenWidth, 22 + 10 + 14 + 18 + 12 + 15 + 20 + itemHeight * 3 + spacing * 2 + 43 + 30 + 83);

}

- (void)setupFooter {
//
//    UIView *footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor whiteColor];
//
//    footerView.frame = CGRectMake(0, 0, kScreenWidth, 250);
//    self.chargView.tableFooterView = footerView;
//
//    UILabel *desLabel = [[UILabel alloc] init];
//    desLabel.textColor = [UIColor blackColor];
//    desLabel.text = @"请选择充值方式";
//    desLabel.font = [UIFont systemFontOfSize:15];
//    [footerView addSubview:desLabel];
//
//    self.alipayButton = [[UIButton alloc] init];
//    [self.alipayButton setImage:[UIImage imageNamed:@"date_zhifubao"] forState:(UIControlStateNormal)];
//    [self.alipayButton setBackgroundImage:[UIImage imageNamed:@"my_weixuanze"] forState:(UIControlStateNormal)];
//    [self.alipayButton setBackgroundImage:[UIImage imageNamed:@"my_xuanze"] forState:(UIControlStateSelected)];
//    [self.alipayButton setTitle:@" 支付宝" forState:(UIControlStateNormal)];
//    [self.alipayButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    self.alipayButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [footerView addSubview:self.alipayButton];
//
//    self.wechatButton = [[UIButton alloc] init];
//    [self.wechatButton setImage:[UIImage imageNamed:@"date_wechat"] forState:(UIControlStateNormal)];
//    [self.wechatButton setBackgroundImage:[UIImage imageNamed:@"my_weixuanze"] forState:(UIControlStateNormal)];
//    [self.wechatButton setBackgroundImage:[UIImage imageNamed:@"my_xuanze"] forState:(UIControlStateSelected)];
//    [self.wechatButton setTitle:@" 微信" forState:(UIControlStateNormal)];
//    [self.wechatButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    self.wechatButton.titleLabel.font = [UIFont systemFontOfSize:14];
//
//    [footerView addSubview:self.wechatButton];
//
//    self.chargePayButton = [[UIButton alloc] init];
//    [self.chargePayButton setTitle:@"支付" forState:(UIControlStateNormal)];
//    self.chargePayButton.backgroundColor = kMainRedColor;
//    self.chargePayButton.layer.cornerRadius = 22;
//    [footerView addSubview:self.chargePayButton];
//
//    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.mas_offset(15);
//
//    }];
//
//    [self.alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(desLabel.mas_bottom).offset(20);
//        make.left.mas_offset(20);
//        make.width.mas_equalTo(110);
//        make.height.mas_equalTo(60);
//
//    }];
//    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(desLabel.mas_bottom).offset(20);
//        make.left.mas_equalTo(self.alipayButton.mas_right).offset(20);
//        make.width.mas_equalTo(110);
//        make.height.mas_equalTo(60);
//
//    }];
//
//    [self.chargePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(self.alipayButton.mas_bottom).offset(56);
//        make.left.mas_offset(30);
//        make.right.mas_offset(-30);
//        make.height.mas_equalTo(44);
//
//    }];
//
//    [self.alipayButton addTarget:self action:@selector(clickPayTypebutton:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.wechatButton addTarget:self action:@selector(clickPayTypebutton:) forControlEvents:(UIControlEventTouchUpInside)];
//
//    [self.chargePayButton addTarget:self action:@selector(clickChargeButton) forControlEvents:(UIControlEventTouchUpInside)];

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



@end
