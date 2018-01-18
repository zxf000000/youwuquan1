//
//  XFLoginVCViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLoginVCViewController.h"
#import "XFRegistViewController.h"
#import "XFForgetViewController.h"
#import "XFLoginNetworkManager.h"
#import "XFMineNetworkManager.h"
#import <UMSocialCore/UMSocialCore.h>


@interface XFLoginVCViewController ()

@property (nonatomic,strong) UIView *loginView;

@property (nonatomic,strong) UIImageView *phoneImage;

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UIView *line1;

@property (nonatomic,strong) UIImageView *pwdImg;

@property (nonatomic,strong) UITextField *pwdTextField;

@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *registBUtton;

@property (nonatomic,strong) UIButton *forgetButton;

@property (nonatomic,strong) UILabel *loginLabel;

@property (nonatomic,strong) UIView *line3;

@property (nonatomic,strong) UIView *line4;

@property (nonatomic,strong) UIButton *qqButton;
@property (nonatomic,strong) UIButton *wbButton;
@property (nonatomic,strong) UIButton *wxbutton;

@end

@implementation XFLoginVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(10, 30, 60, 30))];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLoginView];
    
    [self.view setNeedsUpdateConstraints];
    
    self.navigationController.navigationBar.hidden = YES;
}

// 登录
- (void)clickLoginButton {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号"];
        
        return;
        
    }
    
    if (![self.pwdTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号"];
        
        return;

    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view withText:@"正在登陆"];
    
    [XFLoginNetworkManager loginWithPhone:self.phoneTextField.text pwd:self.pwdTextField.text longitude:@"100" latitude:@"100" progress:^(CGFloat progress) {
        
        
    } successBlock:^(id responseObj) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 获取个人信息
            [XFMineNetworkManager getAllInfoWithsuccessBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"登陆成功"];
                
                // 保存用户信息
                [[XFUserInfoManager sharedManager] updateUserInfo:responseObj];
                [XFUserInfoManager sharedManager].userName = self.phoneTextField.text;
                [XFUserInfoManager sharedManager].pwd = self.pwdTextField.text;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
                
                [self dismissViewControllerAnimated:YES completion:nil];

            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];

        });
        
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];

        });
        

    }];
    
}

// 忘记密码
- (void)clickForgetButton {
    
    [self.view endEditing:YES];
    
    XFForgetViewController *forgetVC = [[XFForgetViewController alloc] init];
    
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

// 点击注册按钮
- (void)clickRegistButton {
    
    [self.view endEditing:YES];

    
    XFRegistViewController *registVC = [[XFRegistViewController alloc] init];
    
    [self.navigationController pushViewController:registVC animated:YES];
    
}

- (void)clickBackButton {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)clickqqButton {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ unionid: %@", resp.unionId);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp);
        }
    }];
}

- (void)clickwxButton {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (void)clickwbButton {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
    
}

- (void)setupLoginView {
    
    self.loginView = [[UIView alloc] init];
    self.loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginView];
    
    // 登录界面高度
    CGFloat totalHeight = 351.f;
    // 上方高度
    CGFloat topHeight = (kScreenHeight - totalHeight) * kTopBottomRatio;
    
    self.loginView.frame = CGRectMake(15, topHeight, kScreenWidth - 30, totalHeight);
    
    self.loginView.layer.cornerRadius = 5;
    self.loginView.layer.shadowColor = UIColorHex(f80378).CGColor;
    self.loginView.layer.shadowOffset = CGSizeMake(0, 0);
    self.loginView.layer.shadowOpacity = 0.12;
    
    // 子控件
    self.phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_phone"]];
    [self.loginView addSubview:self.phoneImage];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = [UIFont systemFontOfSize:13];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [self.loginView addSubview:self.phoneTextField];
    
    
    self.pwdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_password"]];
    self.pwdImg.contentMode = UIViewContentModeScaleAspectFit;

    [self.loginView addSubview:self.pwdImg];
    
    self.pwdTextField = [[UITextField alloc] init];
    self.pwdTextField.placeholder = @"请输入密码";
    self.pwdTextField.borderStyle = UITextBorderStyleNone;
    self.pwdTextField.font = [UIFont systemFontOfSize:13];
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.loginView addSubview:self.pwdTextField];
    
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.backgroundColor = kMainRedColor;
    self.loginButton.layer.cornerRadius = 22;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginView addSubview:self.loginButton];
    
    self.registBUtton = [[UIButton alloc] init];
    self.registBUtton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.registBUtton setTitle:@"注册账号" forState:(UIControlStateNormal)];
    [self.registBUtton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    [self.registBUtton addTarget:self action:@selector(clickRegistButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginView addSubview:self.registBUtton];
    
    self.forgetButton = [[UIButton alloc] init];
    self.forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.forgetButton setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
    [self.forgetButton setTitleColor:UIColorHex(cccccc) forState:(UIControlStateNormal)];
    [self.forgetButton addTarget:self action:@selector(clickForgetButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginView addSubview:self.forgetButton];
    
    self.loginLabel = [[UILabel alloc] init];
    self.loginLabel.text = @"第三方登录";
    self.loginLabel.font = [UIFont systemFontOfSize:13];
    self.loginLabel.textColor = UIColorHex(808080);
    [self.loginView addSubview:self.loginLabel];
    
    self.qqButton = [[UIButton alloc] init];
    [self.qqButton setImage:[UIImage imageNamed:@"qq"] forState:(UIControlStateNormal)];
    [self.loginView addSubview:self.qqButton];
    self.wxbutton = [[UIButton alloc] init];
    [self.wxbutton setImage:[UIImage imageNamed:@"wechat"] forState:(UIControlStateNormal)];
    [self.loginView addSubview:self.wxbutton];
    self.wbButton = [[UIButton alloc] init];
    [self.wbButton setImage:[UIImage imageNamed:@"weibo"] forState:(UIControlStateNormal)];
    [self.loginView addSubview:self.wbButton];
    
    [self.qqButton addTarget:self action:@selector(clickqqButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.wxbutton addTarget:self action:@selector(clickwxButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.wbButton addTarget:self action:@selector(clickwbButton) forControlEvents:(UIControlEventTouchUpInside)];

    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = UIColorHex(e0e0e0);
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = UIColorHex(e0e0e0);
    self.line3 = [[UIView alloc] init];
    self.line3.backgroundColor = UIColorHex(e0e0e0);
    self.line4 = [[UIView alloc] init];
    self.line4.backgroundColor = UIColorHex(e0e0e0);
    [self.loginView addSubview:self.line1];
    [self.loginView addSubview:self.line2];
    [self.loginView addSubview:self.line3];
    [self.loginView addSubview:self.line4];
    
}

- (void)updateViewConstraints {
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(1);
        make.top.mas_offset(60);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.line1.mas_bottom).mas_offset(57.5);
    }];
    
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line1.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.phoneImage.mas_right).offset(18);
        make.centerY.mas_equalTo(self.phoneImage);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    
    [self.pwdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line2.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.pwdImg.mas_right).offset(18);
        make.centerY.mas_equalTo(self.pwdImg);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.line2.mas_bottom).offset(30);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.registBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(15);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(25);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
        
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(25);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(75);
        make.centerX.mas_offset(0);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.loginLabel.mas_centerY);
        make.right.mas_equalTo(self.loginLabel.mas_left).offset(-11);
        make.left.mas_offset(33);
        make.height.mas_equalTo(1);

    }];

    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.loginLabel);
        make.left.mas_equalTo(self.loginLabel.mas_right).offset(11);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(1);

    }];
    
    [self.wbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.loginLabel.mas_bottom).offset(20);
        make.height.width.mas_equalTo(26);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(-70);
        make.top.mas_equalTo(self.loginLabel.mas_bottom).offset(20);
        make.height.width.mas_equalTo(26);
    }];
    
    [self.wxbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(70);
        make.top.mas_equalTo(self.loginLabel.mas_bottom).offset(20);
        make.height.width.mas_equalTo(26);
    }];
    
    [super updateViewConstraints];
}


@end
