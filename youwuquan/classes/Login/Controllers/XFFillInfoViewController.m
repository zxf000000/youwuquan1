//
//  XFFillInfoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFillInfoViewController.h"

@interface XFFillInfoViewController ()

@property (nonatomic,strong) UIView *fillView;

@property (nonatomic,strong) UIImageView *phoneImage;

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UIView *line1;

@property (nonatomic,strong) UIImageView *code;

@property (nonatomic,strong) UITextField *codeTextField;

@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) UIButton *registBUtton;

@end

@implementation XFFillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    
    [backButton setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(10, 30, 60, 30);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupFillView];
    
    [self.view setNeedsUpdateConstraints];

}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupFillView {
    self.fillView = [[UIView alloc] init];
    self.fillView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fillView];
    
    // 登录界面高度
    CGFloat totalHeight = 515/2.0;
    // 上方高度
    CGFloat topHeight = (kScreenHeight - totalHeight)/2;
    
    self.fillView.frame = CGRectMake(15, topHeight, kScreenWidth - 30, totalHeight);
    
    self.fillView.layer.cornerRadius = 5;
    self.fillView.layer.shadowColor = UIColorHex(f80378).CGColor;
    self.fillView.layer.shadowOffset = CGSizeMake(0, 0);
    self.fillView.layer.shadowOpacity = 0.12;
    
    // 子控件
    self.phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_phone"]];
    [self.fillView addSubview:self.phoneImage];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.font = [UIFont systemFontOfSize:13];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.fillView addSubview:self.phoneTextField];
    
    
    self.code = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_password"]];
    self.code.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.fillView addSubview:self.code];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = @"请输入密码";
    self.codeTextField.borderStyle = UITextBorderStyleNone;
    self.codeTextField.font = [UIFont systemFontOfSize:13];
    self.codeTextField.secureTextEntry = YES;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.fillView addSubview:self.codeTextField];
    
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.backgroundColor = kMainRedColor;
    self.doneButton.layer.cornerRadius = 22;
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.doneButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.fillView addSubview:self.doneButton];
    
    self.registBUtton = [[UIButton alloc] init];
    self.registBUtton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.registBUtton setTitle:@"注册账号" forState:(UIControlStateNormal)];
    [self.registBUtton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    [self.registBUtton addTarget:self action:@selector(clickRegistButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.fillView addSubview:self.registBUtton];
    
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = UIColorHex(e0e0e0);
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = UIColorHex(e0e0e0);

    [self.fillView addSubview:self.line1];
    [self.fillView addSubview:self.line2];

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
    
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line2.mas_top).offset(-10);
        make.left.mas_offset(32.5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(17);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.code.mas_right).offset(18);
        make.centerY.mas_equalTo(self.code);
        make.height.mas_equalTo(21);
        make.right.mas_offset(-33);
        
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.line2.mas_bottom).offset(30);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_equalTo(44);
        
    }];
    
    [super updateViewConstraints];
}


@end
