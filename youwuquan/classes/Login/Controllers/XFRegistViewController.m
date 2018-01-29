//
//  XFRegistViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFRegistViewController.h"
#import "XFFillInfoViewController.h"
#import "XFLoginManager.h"
#import "XFRegistInfoViewController.h"
#import <YYCache.h>
#import "XFLoginNetworkManager.h"

@interface XFRegistViewController ()

@property (nonatomic,strong) UIView *registView;
@property (nonatomic,strong) UIImageView *phoneImage;

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UIImageView *codeImg;

@property (nonatomic,strong) UITextField *codeTextField;

@property (nonatomic,strong) UIButton *codeButton;

@property (nonatomic,strong) UIView *line1;

@property (nonatomic,strong) UIImageView *pwdImg;

@property (nonatomic,strong) UITextField *pwdTextField;

@property (nonatomic,strong) UIImageView *nickImg;

@property (nonatomic,strong) UITextField *nickTextField;

@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *registBUtton;

@property (nonatomic,strong) UIView *line3;

@property (nonatomic,strong) UIView *line4;

@property (nonatomic,strong) UILabel *desLabel;

@property (nonatomic,strong) UIButton *userCodeButton;

@end

@implementation XFRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backButton = [[UIButton alloc] init];
    
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(10, 30, 60, 30);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupregistView];
    [self.view setNeedsUpdateConstraints];
}

/**
 直接登录
 */
- (void)clickLoginButton {
    
    [self.view endEditing:YES];

    
    [self.navigationController popViewControllerAnimated:YES];
    
}


// 点击注册
- (void)clickRegistButton {
    
    [self.view endEditing:YES];

//    // 完善信息界面
//    XFRegistInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XFRegistInfoViewController"];
//
//    [self.navigationController pushViewController:infoVC animated:YES];
//
//    return;
    
    if (![self.phoneTextField.text isPhoneNumber]) {

        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号码"];

        return;

    }

    if (![self.codeTextField.text isHasContent]) {

        [XFToolManager showProgressInWindowWithString:@"请输入验证码"];

        return;

    }


    if (![self.pwdTextField.text isPasswordContent]) {

        [XFToolManager showProgressInWindowWithString:@"密码必须由字母数字组成,且大于8位"];

        return;

    }
    
    __block MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在登录"];

    [XFLoginNetworkManager registWithPhone:self.phoneTextField.text pwd:self.pwdTextField.text code:self.codeTextField.text progress:^(CGFloat progress) {
        
    } successBlock:^(id responseObj) {
        
//        NSDictionary *dic = responseObj;
        
        [XFUserInfoManager sharedManager].userName = self.phoneTextField.text;
        [XFUserInfoManager sharedManager].pwd = self.pwdTextField.text;
        // 登录
        
        [XFLoginNetworkManager loginWithPhone:self.phoneTextField.text pwd:[XFToolManager md5:self.pwdTextField.text] longitude:@"100" latitude:@"100" progress:^(CGFloat progress) {
            
            NSLog(@"%f",progress);
            
        } successBlock:^(id responseObj) {
            
            
            [XFLoginNetworkManager getMyTokenWithsuccessBlock:^(id responseObj) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XFToolManager changeHUD:HUD successWithText:@"注册成功"];
                    
                    // 完善信息界面
                    XFRegistInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XFRegistInfoViewController"];
                    
                    [self.navigationController pushViewController:infoVC animated:YES];
                });
                
                [[XFUserInfoManager sharedManager] updateToken:((NSDictionary *)responseObj)[@"token"]];
                [[XFUserInfoManager sharedManager] updateTokenDate:[NSDate date]];
                
                
                
            } failedBlock:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
                    
                });
            }];
        } failBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HUD hideAnimated:YES];

            });
            
            
        }];
        
        // 登录融云
//        [[XFLoginManager sharedInstance] loginRongyunWithRongtoken:dic[@"data"][0] successBlock:^(id reponseDic) {
//
//            // 发送成功
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [XFToolManager changeHUD:HUD successWithText:@"注册成功"];
//                [HUD hideAnimated:YES afterDelay:0.3];
//
//                // 保存token和userName
//                [XFUserInfoManager sharedManager].token = dic[@"data"][1];
//                [XFUserInfoManager sharedManager].rongToken = dic[@"data"][0];
//

//            });
//
//
//        } failedBlock:^(NSError *error) {
//
//            [XFToolManager changeHUD:HUD successWithText:@"注册失败"];
//            [HUD hideAnimated:YES afterDelay:0.3];
//
////            dispatch_async(dispatch_get_main_queue(), ^{
////
////                [XFToolManager changeHUD:HUD successWithText:@"登陆失败"];
////            });
//
//
//
//        }];
        
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

    }];
}
/**
 获取验证码
 */

- (void)clickCodeButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTextField.text isPhoneNumber]) {

        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号码"];

        return;

    }
//    // 开始倒计时
//
//    [[XFLoginManager sharedInstance] getCodeWithPhone:self.phoneTextField.text regist:nil successBlock:^(NSDictionary *reponseDic) {
//
//        if (reponseDic) {
//
//            [XFToolManager changeHUD:HUD successWithText:@"发送成功"];
//

//
//        } else {
//
//            [HUD hideAnimated:YES];
//        }
//
//    } failedBlock:^(NSError *error) {
//
//        [HUD hideAnimated:YES];
//
//    }];
    
    // 发送验证码
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];

    [XFLoginNetworkManager getCodeWithPhoneNumber:self.phoneTextField.text progress:^(CGFloat progress) {
        
        
    } successBlock:^(id responseObj) {
       
        [XFToolManager changeHUD:HUD successWithText:@"发送成功"];
        // 发送成功
        [XFToolManager countdownbutton:sender];
        
        
    } failBlock:^(NSError *error) {
        
        [XFToolManager changeHUD:HUD successWithText:@"请求失败,请检查网络设置"];

    }];
    
}

- (void)setupregistView {
    
    self.registView = [[UIView alloc] init];
    self.registView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registView];
    
    // 登录界面高度
    CGFloat totalHeight = 758/2.f - 60;
    // 上方高度
    CGFloat topHeight = (kScreenHeight - totalHeight) * kTopBottomRatio;
    
    self.registView.frame = CGRectMake(15, topHeight, kScreenWidth - 30, totalHeight);
    
    self.registView.layer.cornerRadius = 5;
    self.registView.layer.shadowColor = UIColorHex(f80378).CGColor;
    self.registView.layer.shadowOffset = CGSizeMake(0, 0);
    self.registView.layer.shadowOpacity = 0.12;
    
    
    // 子控件
    self.phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_phone"]];
    self.phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.registView addSubview:self.phoneImage];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = [UIFont systemFontOfSize:13];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.registView addSubview:self.phoneTextField];
    
    
    self.pwdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_password"]];
    self.pwdImg.contentMode = UIViewContentModeScaleAspectFit;

    [self.registView addSubview:self.pwdImg];
    
    self.pwdTextField = [[UITextField alloc] init];
    self.pwdTextField.placeholder = @"请输入密码";
    self.pwdTextField.borderStyle = UITextBorderStyleNone;
    self.pwdTextField.font = [UIFont systemFontOfSize:13];
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.registView addSubview:self.pwdTextField];
    
    self.codeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_yzm"]];
    self.codeImg.contentMode = UIViewContentModeScaleAspectFit;

    [self.registView addSubview:self.codeImg];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.font = [UIFont systemFontOfSize:13];
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.registView addSubview:self.codeTextField];
    
    self.registBUtton = [[UIButton alloc] init];
    self.registBUtton.backgroundColor = kMainRedColor;
    self.registBUtton.layer.cornerRadius = 22;
    self.registBUtton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.registBUtton setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.registBUtton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.registView addSubview:self.registBUtton];
    
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.loginButton setTitle:@"已有账号,立即登录" forState:(UIControlStateNormal)];
    [self.loginButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registView addSubview:self.loginButton];

    self.codeButton  = [[UIButton alloc] init];
    [self.codeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.codeButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    [self.codeButton setTitleColor:UIColorHex(808080) forState:(UIControlStateSelected)];
    self.codeButton.layer.cornerRadius = 12.5;
    self.codeButton.layer.borderColor = kMainRedColor.CGColor;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.registView addSubview:self.codeButton];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.text = @"注册表示您已经同意尤物圈";
    self.desLabel.font = [UIFont systemFontOfSize:10];
    self.desLabel.textColor = [UIColor blackColor];
    [self.registView addSubview:self.desLabel];
    
    self.userCodeButton = [[UIButton alloc] init];
    [self.userCodeButton setTitle:@"《用户服务协议》" forState:(UIControlStateNormal)];
    [self.userCodeButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.userCodeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.registView addSubview:self.userCodeButton];
    
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = UIColorHex(e0e0e0);
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = UIColorHex(e0e0e0);
    self.line3 = [[UIView alloc] init];
    self.line3.backgroundColor = UIColorHex(e0e0e0);
//    self.line4 = [[UIView alloc] init];
//    self.line4.backgroundColor = UIColorHex(e0e0e0);
    [self.registView addSubview:self.line1];
    [self.registView addSubview:self.line2];
    [self.registView addSubview:self.line3];
//    [self.registView addSubview:self.line4];
    
    // 事件
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registBUtton addTarget:self action:@selector(clickRegistButton) forControlEvents:(UIControlEventTouchUpInside)];

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
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.line2.mas_bottom).mas_offset(57.5);
    }];
    


    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_equalTo(self.line1.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];

    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-22.5);
        make.centerY.mas_equalTo(self.phoneImage);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(100);
        
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.phoneImage.mas_right).offset(18);
        make.centerY.mas_equalTo(self.phoneImage);
        make.right.mas_equalTo(self.codeButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);

    }];
    
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line2.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.codeImg.mas_right).offset(18);
        make.centerY.mas_equalTo(self.codeImg);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    

    [self.pwdImg mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_equalTo(self.line3.mas_top).offset(-10);
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
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.line3);
        make.top.mas_equalTo(self.line3.mas_bottom).offset(10);
        
    }];
    
    [self.userCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.desLabel.mas_right);
        make.centerY.mas_equalTo(self.desLabel);
        
    }];

    [self.registBUtton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.line3.mas_bottom).offset(50);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(44);

    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.registBUtton.mas_bottom).offset(12.5);

    }];
    
    [super updateViewConstraints];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
