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
#import "XFLoginNetworkManager.h"
#import "CHWebView.h"
#import "XFMineNetworkManager.h"

@interface XFSetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;

@end

@implementation XFSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";

    self.logoutButton.layer.cornerRadius = 22;
    
    [self.logoutButton addTarget:self action:@selector(clickLogoutButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self getData];
}

- (void)getData {
    
    
    YYCache *netCache = kNetworkCache;
    // 清除缓存
    YYCache *cache = [YYCache cacheWithName:kTagsHistoryKey];
    YYCache *cache1 = [YYCache cacheWithName:kSearchHistoryKey];
    
    NSLog(@"%zd",cache.diskCache.totalCost + cache1.diskCache.totalCost);
    
    NSInteger total = cache.diskCache.totalCost + cache1.diskCache.totalCost + netCache.diskCache.totalCost;
    
    if (total < 1000 * 1000) {
        
        self.totalCostLabel.text = [NSString stringWithFormat:@"%.1fK",total/1000.f];
        
    } else if (total > 1000 * 1000) {
        
        self.totalCostLabel.text = [NSString stringWithFormat:@"%.1fM",total/1000000.f];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
        {

            
        }
            break;
        case 1:
        {
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
            // 检查更新
            [XFMineNetworkManager checkUpdateForAppWithsuccessBlock:^(id responseObj) {
                [HUD hideAnimated:YES];

                NSArray *results = ((NSDictionary *)responseObj)[@"results"];
                
                if (results.count == 0) {
                    
                    [XFToolManager showProgressInWindowWithString:@"已经是最新版本"];
                    
                }
                
                
            } failedBlock:^(NSError *error) {
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
        default:
        {
            //
            UIViewController *webVC = [[UIViewController alloc] init];
            
            CHWebView *webView = [[CHWebView alloc]initWithFrame:webVC.view.bounds];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.uuuooo.net"]];
            
            [webView loadRequest:request];
            //    webView.delegate = self;
            [webVC.view addSubview:webView];
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
    }
    

    
}


- (void)clickLogoutButton {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在登出"];
        
        [XFLoginNetworkManager logoutWithprogress:^(CGFloat progress) {
            
            
        } successBlock:^(id responseObj) {
            
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
            
        } failBlock:^(NSError *error) {
            
                [HUD hideAnimated:YES];

        }];
        
//        [[XFLoginManager sharedInstance] logoutWithsuccessBlock:^(id reponseDic) {
//
//            if (reponseDic) {
//

//
//
//            }
//
//            [HUD hideAnimated:YES];
//        } failedBlock:^(NSError *error) {
//
//
//        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:actionDone];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    

    
}


@end
