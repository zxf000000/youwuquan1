//
//  XFCashViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCashViewController.h"
#import "XFMineNetworkManager.h"

@interface XFCashViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *alipayTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;

@end

@implementation XFCashViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"提现";
    
    [self setupViews];
    
    self.totalLabel.text = self.canCashMoney;
    
    
}
- (IBAction)clickCashButton:(id)sender {
    
    if (![self.alipayTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入支付宝账户"];
        
        return;
    }
    
    if (![self.nameTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入姓名"];
        
        return;
    }
    
    if (![self.numberLabel.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入提现金额"];
        
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [XFMineNetworkManager txWithNumber:self.numberLabel.text method:@"" payId:self.alipayTextField.text name:self.nameTextField.text successBlock:^(id responseObj) {
        
        [XFToolManager changeHUD:HUD successWithText:@"申请成功,审核通过之后会将金额转账到您的支付宝账户"];
        
    } failedBlock:^(NSError *error) {
//        [XFToolManager changeHUD:HUD successWithText:@"申请失败"];
        [HUD hideAnimated:YES];
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}


- (void)setupViews {
    
    self.cashButton.layer.cornerRadius = 22;
    
    self.nameView.layer.cornerRadius = self.alipayView.layer.cornerRadius = self.numberView.layer.cornerRadius = 5;
    
    self.nameView.layer.borderWidth = self.alipayView.layer.borderWidth = self.numberView.layer.borderWidth = 1;
    self.nameView.layer.borderColor = self.alipayView.layer.borderColor = self.numberView.layer.borderColor = UIColorHex(808080).CGColor;

    
}


@end
