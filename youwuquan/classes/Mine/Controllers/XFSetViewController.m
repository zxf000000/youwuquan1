//
//  XFSetViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSetViewController.h"
#import "XFLoginManager.h"
#import "XFMainTabbarViewController.h"

@interface XFSetViewController ()

@end

@implementation XFSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";

    self.logoutButton.layer.cornerRadius = 22;
    
    [self.logoutButton addTarget:self action:@selector(clickLogoutButton) forControlEvents:(UIControlEventTouchUpInside)];
}


- (void)clickLogoutButton {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在登出"];
        
        [[XFLoginManager sharedInstance] logoutWithsuccessBlock:^(id reponseDic) {
            
            if (reponseDic) {
                
                [XFToolManager changeHUD:HUD successWithText:@"退出成功"];
                
                // 删除所有信息
                [[XFUserInfoManager sharedManager] removeAllData];
                
                // 退出融云
                [[RCIM sharedRCIM] logout];
                
                
                // 主界面
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                self.tabbarVC.selectedIndex = 0;
                
                window.rootViewController = self.tabbarVC;
                [self.navigationController popViewControllerAnimated:NO];

                
            }
            
            [HUD hideAnimated:YES];
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];

        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:actionDone];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    

    
}


@end
