//
//  XFAddAddressViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/25.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFAddAddressViewController.h"
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
#import "XFMineNetworkManager.h"
@interface XFAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
- (IBAction)clickProvinceButton:(id)sender;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;


@end

@implementation XFAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 30))];
    [rightButton setTitle:@"保存" forState:(UIControlStateNormal)];
    [rightButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [rightButton addTarget:self action:@selector(clickSaveButton) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if (self.model) {
        self.nameTf.text = self.model.name;
        self.phoneTf.text = self.model.phone;
        [self.provinceButton setTitle:[NSString stringWithFormat:@"%@%@",_model.province,_model.city] forState:(UIControlStateNormal)];
        self.detailTextView.text = self.model.detail;
        self.province = _model.province;
        self.city = _model.city;
        
    }

}

- (void)clickSaveButton {
    
    if (![self.nameTf.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入收货人"];
        
        return;
        
    }
    
    if (![self.phoneTf.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的电话"];
        
        return;
        
    }
    
    if ([self.provinceButton.currentTitle isEqualToString:@"点击选择省市"]) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择省市"];
        
        return;
        
    }
    
    if (![self.detailTextView.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入详细地址"];
        
        return;
        
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    if (self.model) {
        
        [XFMineNetworkManager addAddressWithName:self.nameTf.text province:self.province city:self.city detail:self.detailTextView.text postcode:@"12345" phone:self.phoneTf.text successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
        }];
    } else {
        
        [XFMineNetworkManager updateAddressWithId:[_model.id longValue] name:self.nameTf.text province:self.province city:self.city detail:self.detailTextView.text postcode:@"1234" phone:self.phoneTf.text successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"更新成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
        }];
    }
    

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (IBAction)clickProvinceButton:(UIButton *)sender {
    
    [CZHAddressPickerView cityPickerViewWithCityBlock:^(NSString *province, NSString *city) {
        [sender setTitle:[NSString stringWithFormat:@"%@%@",province,city] forState:UIControlStateNormal];
        
        self.province = province;
        self.city = city;
        
        [sender setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }];
    
}
@end
