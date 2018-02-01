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

@interface XFActivityViewController () <WXApiDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *bmButton;

@property (nonatomic,strong) XFPayActView *payView;

@property (nonatomic,strong) UIView *shadowView;

@end

@implementation XFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
    [self initViews];
    
    [self.view setNeedsUpdateConstraints];
}

//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
- (void)onReq:(BaseReq *)req {
    
    
}

//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
}

- (void)clickBmButton {
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.payView.frame = CGRectMake(0, kScreenHeight - 265 - 64, kScreenWidth, 285);
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
    self.payView.wxpayBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            weakpayView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
            weakSelf.shadowView.alpha = 0;
            
        } completion:^(BOOL finished) {
            

            
        }] ;
    };
    
    self.payView.alipayBlock = ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            weakpayView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 285);
            weakSelf.shadowView.alpha = 0;

        } completion:^(BOOL finished) {
            
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
