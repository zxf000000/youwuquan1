//
//  XFForgetViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/13.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFForgetViewController.h"
#import "XFLoginManager.h"

@interface XFForgetViewController ()
@property (nonatomic,strong) UIView *registView;
@property (nonatomic,strong) UIImageView *phoneImage;

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UIImageView *codeImg;

@property (nonatomic,strong) UITextField *codeTextField;

@property (nonatomic,strong) UIButton *codeButton;

@property (nonatomic,strong) UIView *line1;

@property (nonatomic,strong) UIImageView *pwdImg;

@property (nonatomic,strong) UITextField *pwdTextField;

@property (nonatomic,strong) UIImageView *confirmImg;

@property (nonatomic,strong) UITextField *confirmTextField;

@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *doneBUtton;

@property (nonatomic,strong) UIView *line3;

@property (nonatomic,strong) UIView *line4;

@property (nonatomic,strong) UILabel *desLabel;

@property (nonatomic,strong) UIButton *userCodeButton;
@end

@implementation XFForgetViewController

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

// 点击确认按钮
- (void)clickDoneButton {
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.codeTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入验证码"];
        return;
    }
    
    if (![self.pwdTextField.text isPasswordContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"密码格式不正确"];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.confirmTextField.text]) {
        
        [XFToolManager showProgressInWindowWithString:@"两次输入密码不一致"];
        return;
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [[XFLoginManager sharedInstance]  changePwdWithPhone:self.phoneTextField.text pwd:self.pwdTextField.text code:self.codeTextField.text  successBlock:^(NSDictionary *reponseDic) {
        
        if (reponseDic) {
            
            [XFToolManager changeHUD:HUD successWithText:@"修改成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [HUD hideAnimated:YES];
        }
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];
        
    }];
    
}

// 获取验证码
- (void)clickCodeButton:(UIButton *)sender {
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号"];
        
        return;
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [[XFLoginManager sharedInstance] getCodeWithPhone:self.phoneTextField.text regist:@"" successBlock:^(NSDictionary *reponseDic) {
        
        if (reponseDic) {
            
            [XFToolManager changeHUD:HUD successWithText:@"发送成功"];
            
            [XFToolManager countdownbutton:sender];
            
        } else {
            
            [HUD hideAnimated:YES];
        }
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];
        
    }];
    
}
- (void)setupregistView {
    
    self.registView = [[UIView alloc] init];
    self.registView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registView];
    
    // 登录界面高度
    CGFloat totalHeight = 758/2.f;
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
    self.pwdTextField.placeholder = @"请重新输入密码";
    self.pwdTextField.borderStyle = UITextBorderStyleNone;
    self.pwdTextField.font = [UIFont systemFontOfSize:13];
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.registView addSubview:self.pwdTextField];
    
    
    self.confirmImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_password"]];
    self.confirmImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.registView addSubview:self.confirmImg];
    
    self.confirmTextField = [[UITextField alloc] init];
    self.confirmTextField.placeholder = @"请再次确认密码";
    self.confirmTextField.borderStyle = UITextBorderStyleNone;
    self.confirmTextField.font = [UIFont systemFontOfSize:13];
    self.confirmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmTextField.secureTextEntry = YES;

    [self.registView addSubview:self.confirmTextField];
    
    self.codeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_yzm"]];
    self.codeImg.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.registView addSubview:self.codeImg];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.font = [UIFont systemFontOfSize:13];
    self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.registView addSubview:self.codeTextField];
    
    self.doneBUtton = [[UIButton alloc] init];
    self.doneBUtton.backgroundColor = kMainRedColor;
    self.doneBUtton.layer.cornerRadius = 22;
    self.doneBUtton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.doneBUtton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.doneBUtton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.registView addSubview:self.doneBUtton];
    
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.loginButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
//    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
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
    [self.userCodeButton setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.userCodeButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.userCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.registView addSubview:self.userCodeButton];
    
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = UIColorHex(e0e0e0);
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = UIColorHex(e0e0e0);
    self.line3 = [[UIView alloc] init];
    self.line3.backgroundColor = UIColorHex(e0e0e0);
    self.line4 = [[UIView alloc] init];
    self.line4.backgroundColor = UIColorHex(e0e0e0);
    [self.registView addSubview:self.line1];
    [self.registView addSubview:self.line2];
    [self.registView addSubview:self.line3];
    [self.registView addSubview:self.line4];
    
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.doneBUtton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
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
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(33);
        make.right.mas_offset(-33);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.line3.mas_bottom).mas_offset(57.5);
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
    //
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
    //
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.pwdImg.mas_right).offset(18);
        make.centerY.mas_equalTo(self.pwdImg);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    //
    [self.confirmImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line4.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];
    //
    [self.confirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.confirmImg.mas_right).offset(18);
        make.centerY.mas_equalTo(self.confirmImg);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.line4);
        make.top.mas_equalTo(self.line4.mas_bottom).offset(10);
        
    }];
    

    
    [self.doneBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.line4.mas_bottom).offset(50);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.doneBUtton.mas_bottom).offset(12.5);
        
    }];
    
    [self.userCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(15);
        make.top.mas_equalTo(self.doneBUtton.mas_bottom).offset(12.5);
        
    }];
    
    [super updateViewConstraints];
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
