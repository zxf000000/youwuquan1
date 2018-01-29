//
//  XFBindPhoneViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/21.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFBindPhoneViewController.h"
#import "XFLoginNetworkManager.h"
#import "XFRegistInfoViewController.h"

@interface XFBindPhoneViewController ()

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIImageView *phoneImg;
@property (nonatomic,strong) UIImageView *codeImg;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *codeTextfield;
@property (nonatomic,strong) UIButton *codeButton;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UIButton *doneButton;

@end

@implementation XFBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self updateViewConstraints];
}

- (void)clickCodeButton {
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号码"];
        return;
    }
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view];
    [XFLoginNetworkManager getCodeWithPhoneNumber:self.phoneTextField.text progress:^(CGFloat progress) {
        
    } successBlock:^(id responseObj) {
       // 获取成功
        [XFToolManager changeHUD:HUD successWithText:@"发送成功"];
        [XFToolManager countdownbutton:self.codeButton];
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
    }];
    
}

- (void)clickDoneButton {
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号码"];
        return;
    }
    
    if (![self.codeTextfield.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入验证码"];
        return;
    }
    
    NSString *username;
    NSString *token;
    
    if ([self.type isEqualToString:@"WeChat"]) {
        
        username = self.openId;
        token = self.token;
        
    } else if ([self.type isEqualToString:@"Weibo"]) {
        username = self.openId;
        token = self.token;
    } else {
        
        username = self.openId;
        token = self.token;
    }
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view];

    [XFLoginNetworkManager signUpWithType:self.type username:username token:token phone:self.phoneTextField.text code:self.codeTextfield.text progress:^(CGFloat progress) {
        
    } successBlock:^(id responseObj) {
       
        // 登录融云
        
        [XFLoginNetworkManager getMyTokenWithsuccessBlock:^(id responseObj) {
            
            [[XFUserInfoManager sharedManager] updateToken:((NSDictionary *)responseObj)[@"token"]];
            [[XFUserInfoManager sharedManager] updateTokenDate:[NSDate date]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [XFToolManager changeHUD:HUD successWithText:@"绑定成功"];
                // 完善信息界面
                XFRegistInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"XFRegistInfoViewController"];
                
                [self.navigationController pushViewController:infoVC animated:YES];
            });
            

            
        } failedBlock:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
                
            });
        }];
        

        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
    }];
    
}

- (void)clickCancelButton {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupViews {
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:self.bgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"欢迎加入尤物圈";
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.text = @"绑定手机号";
    self.subTitleLabel.font = [UIFont systemFontOfSize:17];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.subTitleLabel];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setImage:[UIImage imageNamed:@"bind_cancel"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.cancelButton];
    
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.line1];
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.line2];
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.layer.cornerRadius = 45.f;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.iconView];
    
    self.phoneImg = [[UIImageView alloc] init];
    self.phoneImg.image = [UIImage imageNamed:@"Verification_Phone"];
    self.phoneImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.phoneImg];
    
    self.codeImg = [[UIImageView alloc] init];
    self.codeImg.image = [UIImage imageNamed:@"Verification_Code"];
    self.codeImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.codeImg];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.textColor = [UIColor whiteColor];
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;

    [self.view addSubview:self.phoneTextField];
    
    self.codeTextfield = [[UITextField alloc] init];
    self.codeTextfield.placeholder = @"短信验证码";
    self.codeTextfield.textColor = [UIColor whiteColor];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:self.codeTextfield];
    
    self.codeButton = [[UIButton alloc] init];
    [self.codeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.codeButton.layer.cornerRadius = 13;
    self.codeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeButton.layer.borderWidth = 1;
    [self.view addSubview:self.codeButton];
    

    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.textColor = [UIColor whiteColor];
    self.desLabel.font = [UIFont systemFontOfSize:12];
    self.desLabel.numberOfLines = 0;
    self.desLabel.text = @"根据国家法律要求,您需要绑定手机才能进行发帖,回复,私信等互动操作.尤物圈会保护您的信息安全,请放心填写";
    [self.view addSubview:self.desLabel];
    
    self.doneButton = [[UIButton alloc] init];
    [self.doneButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.doneButton.layer.cornerRadius = 10;
    self.doneButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneButton.layer.borderWidth = 1;
    [self.view addSubview:self.doneButton];
    
    [self.codeButton addTarget:self action:@selector(clickCodeButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)updateViewConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_offset(15);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(55);
        
    }];
     
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.cancelButton);
        make.centerX.mas_offset(0);
        
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.centerX.mas_offset(0);
        
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_offset(0);
        make.width.mas_equalTo(kScreenWidth-90);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.line1.mas_bottom).offset(64);
        make.left.width.height.right.mas_equalTo(self.line1);
    }];
    
    [self.phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.line1.mas_top).offset(-5);
        make.left.mas_equalTo(self.line1.mas_left);
        make.width.height.mas_equalTo(26);
        
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.phoneImg.mas_right).offset(10);
        make.right.mas_equalTo(self.line1);
        make.centerY.mas_equalTo(self.phoneImg);
        make.height.mas_equalTo(26);
        
        
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.line1.mas_top).offset(-60);
        make.width.height.mas_equalTo(90);
        make.centerX.mas_offset(0);
        
    }];
    
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.line2.mas_top).offset(-5);
        make.left.mas_equalTo(self.line2);
        make.width.height.mas_equalTo(26);
        
    }];
    
    [self.codeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.codeImg.mas_right).offset(10);
        make.right.mas_equalTo(self.codeButton.mas_left);
        make.centerY.mas_equalTo(self.codeImg);
        make.height.mas_equalTo(26);
        
        
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.line1);
        make.centerY.mas_equalTo(_phoneImg);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(90);
        
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(self.line2);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(15);
        
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(70);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(44);
        make.centerX.mas_offset(0);
    }];
    
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

@end
