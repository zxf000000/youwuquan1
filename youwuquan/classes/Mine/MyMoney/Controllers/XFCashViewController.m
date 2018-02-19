//
//  XFCashViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCashViewController.h"
#import "XFMineNetworkManager.h"

@interface XFCashViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *alipayTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
- (IBAction)clickTypeButton:(id)sender;

@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

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
        
        [XFToolManager showProgressInWindowWithString:@"请输入账户"];
        
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
    
    NSString *type;
    
    if ([self.typeButton.currentTitle isEqualToString:@"支付宝"] || [self.typeButton.currentTitle isEqualToString:@"支付宝(点击修改)"]) {
        
        type = @"ALIPAY";
    } else {
        
        type = @"WECHAT";
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    
    [XFMineNetworkManager getMoneyFortxWithNumber:[self.numberLabel.text intValue] successBlock:^(id responseObj) {
       
        NSDictionary *info = (NSDictionary *)responseObj;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"可提现人民币" message:[NSString stringWithFormat:@"%@元",info[@"from"]] preferredStyle:(UIAlertControllerStyleAlert)];
        [HUD hideAnimated:YES];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            [XFMineNetworkManager txWithNumber:[self.numberLabel.text intValue] method:type payId:self.alipayTextField.text name:self.nameTextField.text successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"申请成功,审核通过之后会将金额转账到您的支付宝账户"];
                
            } failedBlock:^(NSError *error) {
                //        [XFToolManager changeHUD:HUD successWithText:@"申请失败"];
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alert addAction:action];
        [alert addAction:actionCancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } failedBlock:^(NSError *error) {
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


- (IBAction)clickTypeButton:(id)sender {
    
    if (!self.picker) {
        
        self.picker = [[UIPickerView alloc] init];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self.view addSubview:self.picker];
        self.picker.backgroundColor = [UIColor whiteColor];
        self.picker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);

    }
    
    if (!self.toolBar) {
        
        self.toolBar = [[UIToolbar alloc] init];
        self.toolBar.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
        [self.view addSubview:self.toolBar];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.toolBar.frame = CGRectMake(0, kScreenHeight - 64 - 49 - 150, kScreenWidth, 49);
        self.picker.frame = CGRectMake(0, kScreenHeight - 64 - 150, kScreenWidth, 150);
        
    }];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.typeButton setTitle:row == 0 ? @"支付宝" : @"微信" forState:(UIControlStateNormal)];

    [UIView animateWithDuration:0.2 animations:^{
        
        self.toolBar.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
        self.picker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 150);

    }];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    switch (row) {
            
            case 0:
        {
            return @"支付宝";
        }
            break;
            case 1:
        {
            return @"微信";

        }
            break;
            
    }
    return @"";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end
