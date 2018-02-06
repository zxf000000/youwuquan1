//
//  XFActivityViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActivityViewController.h"
#import "XFPayActView.h"
#import <WXApi.h>
#import "XFFindNetworkManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "XFMineNetworkManager.h"
@interface XFActivityViewController () <WXApiDelegate,NSXMLParserDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *bmButton;

@property (nonatomic,strong) XFPayActView *payView;

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) NSMutableDictionary *xmlDictionary;

@property (nonatomic,copy) NSString *currentKey;

@property (nonatomic,copy) NSDictionary *activityInfo;
@property (nonatomic,copy) NSString *wxOrderId;
@property (nonatomic,assign) long timeStamp;

@end

@implementation XFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
    [self initViews];
    
    [self.view setNeedsUpdateConstraints];
    
    [self loadData];
    
    self.bmButton.enabled = NO;
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
            
        } else {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [XFMineNetworkManager getTradeStatusWithOrderId:self.wxOrderId successBlock:^(id responseObj) {
                    NSDictionary *responseDic = (NSDictionary *)responseObj;
                    NSLog(@"订单状态-----%@",responseDic[@"status"]);
                    if ([responseDic[@"status"] isEqualToString:@"TRADE_SUCCESS"]) {
                        
                        [XFToolManager changeHUD:HUD successWithText:@"支付成功"];
                        
                    } else {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [XFMineNetworkManager getTradeStatusWithOrderId:self.wxOrderId successBlock:^(id responseObj) {
                                NSDictionary *responseDic = (NSDictionary *)responseObj;
                                NSLog(@"订单状态-----%@",responseDic[@"status"]);
                                if ([responseDic[@"status"] isEqualToString:@"TRADE_SUCCESS"]) {
                                    
                                    [XFToolManager changeHUD:HUD successWithText:@"支付成功"];
                                    
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

- (void)loadData {
   
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFFindNetworkManager getActivityDetailWith:self.activityId successBlock:^(id responseObj) {
       
        [HUD hideAnimated:YES];
        
        NSDictionary *dic = (NSDictionary *)responseObj;
        self.activityInfo = dic;
        self.bmButton.enabled = YES;
        self.payView.price = [self.activityInfo[@"price"] integerValue];

    } failBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
    }];
    
}


- (void)clickBmButton {
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.payView.frame = CGRectMake(0, kScreenHeight - 320 - 64, kScreenWidth, 320);
        self.shadowView.alpha = 1;
    }];

}

- (void)initViews {
    
    self.bmButton = [[UIButton alloc] init];
    self.bmButton.backgroundColor = kMainRedColor;
    [self.bmButton setTitle:@"报名" forState:(UIControlStateNormal)];
    [self.bmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.bmButton];
    
    
    UIImage *img = [UIImage imageNamed:@"huodong"];
    CGSize imggSize = img.size;
    
//    CGFloat width = kScreenWidth;
    CGFloat height = kScreenWidth / imggSize.width * imggSize.height;
    
    self.scrollView = [[UIScrollView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.scrollView addSubview:imgView];
    self.scrollView.contentSize = CGSizeMake(0, height);
    [self.view addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.bmButton addTarget:self action:@selector(clickBmButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.payView = [[XFPayActView alloc] init];
    
    self.payView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
    [self.view addSubview:self.payView];
    
    __weak typeof(_payView) weakpayView = _payView;
    __weak typeof(self) weakSelf = self;
    
    self.payView.wxpayBlock = ^(NSInteger number) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakpayView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
            weakSelf.shadowView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf payAvtivityWithType:@"WECHAT" number:number];
            
        }] ;
    };
    
    self.payView.alipayBlock = ^(NSInteger number) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakpayView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
            weakSelf.shadowView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf payAvtivityWithType:@"ALIPAY" number:number];
            
        }];
    };

    self.payView.cancelBlock = ^{
      
        [UIView animateWithDuration:0.2 animations:^{
           
            weakpayView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
            weakSelf.shadowView.alpha = 0;

        }];
        
    };
    self.shadowView = [[UIView alloc] init];
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view insertSubview:self.shadowView belowSubview:self.payView];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.shadowView.alpha = 0;
}

- (void)payAvtivityWithType:(NSString *)type number:(NSInteger)number {
   
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    // 微信支付
    
    [XFFindNetworkManager checkinActivityWithId:self.activityId payment:type quantity:number successBlock:^(id responseObj) {
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
    } failBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
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
    
    NSTimeInterval time = NSTimeIntervalSince1970;
    
    // 解析结果
    PayReq *request = [[PayReq alloc] init];
    request.openID = self.xmlDictionary[@"appid"];
    request.partnerId = self.xmlDictionary[@"mch_id"];
    request.prepayId = self.xmlDictionary[@"prepay_id"];
    request.package = @"Sign=WXPay";
    request.nonceStr = self.xmlDictionary[@"nonce_str"];
    request.timeStamp = time;
    request.sign= self.xmlDictionary[@"sign"];
    
    [WXApi sendReq:request];
}

- (void)updateViewConstraints {
    
    [self.bmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_offset(0);
        make.bottom.mas_equalTo(self.bmButton.mas_top);
        
    }];
    [super updateViewConstraints];
}

@end
