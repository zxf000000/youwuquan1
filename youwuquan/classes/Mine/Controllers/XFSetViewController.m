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
#import "XFUserAgreementViewController.h"
#import "XFHelpViewController.h"
#import "XFAboutViewController.h"
#import "XFUserxieyiViewController.h"

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
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path2 = NSTemporaryDirectory();
    
    unsigned long long size = 0;

    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if (![fileName hasPrefix:@"userInfo"]) {
                
                NSDictionary *attrs = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil];
                size += attrs.fileSize;
            }
            //            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    
    if ([fileManager fileExistsAtPath:path1]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path1];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            
            NSString *fileAbsolutePath = [path1 stringByAppendingPathComponent:fileName];
            if (![fileName hasPrefix:@"userInfo"]) {
                
                NSDictionary *attrs = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil];
                size += attrs.fileSize;
            }
            
        }
    }
    
    if ([fileManager fileExistsAtPath:path2]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path2];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            NSString *fileAbsolutePath = [path2 stringByAppendingPathComponent:fileName];
            if (![fileName hasPrefix:@"userInfo"]) {
                
                NSDictionary *attrs = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil];
                size += attrs.fileSize;
            }
            
        }
    }
    NSString *sizeText = @"";
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    
    self.totalCostLabel.text = [NSString stringWithFormat:@"%@",sizeText];
    
}

- (void)deleteDatas {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在清除缓存"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path2 = NSTemporaryDirectory();
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
        
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            
            if (![fileName hasPrefix:@"userInfo"]) {
                
                [fileManager removeItemAtPath:fileAbsolutePath error:nil];

            }

        }
    }
    
    if ([fileManager fileExistsAtPath:path1]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path1];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            
            NSString *fileAbsolutePath = [path1 stringByAppendingPathComponent:fileName];
            if (![fileName hasPrefix:@"userInfo"]) {
                
                [fileManager removeItemAtPath:fileAbsolutePath error:nil];
                
            }
            
        }
    }
    
    if ([fileManager fileExistsAtPath:path2]) {
        NSArray *childerFiles= [fileManager subpathsAtPath:path2];
        
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            
            NSString *fileAbsolutePath = [path2 stringByAppendingPathComponent:fileName];
            if (![fileName hasPrefix:@"userInfo"]) {
                
                [fileManager removeItemAtPath:fileAbsolutePath error:nil];
                
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [XFToolManager changeHUD:HUD successWithText:@"清除成功"];
        [self getData];

    });
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
        {
            [self deleteDatas];
            
        }
            break;
        case 1:
        {
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
            // 检查更新
            [XFMineNetworkManager checkUpdateForAppWithsuccessBlock:^(id responseObj) {
                [HUD hideAnimated:YES];

//                NSArray *results = ((NSDictionary *)responseObj)[@"results"];
//
//                if (results.count == 0) {
//
//                    [XFToolManager showProgressInWindowWithString:@"已经是最新版本"];
//
//                }
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1335528589?mt=8"]];
                
                
            } failedBlock:^(NSError *error) {
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
            }];
        }
            break;
            
        case 2:
        {
            XFUserAgreementViewController *agreementVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFUserAgreementViewController"];
            
            [self.navigationController pushViewController:agreementVC animated:YES];
            
        }
            break;
        case 3:
        {
            XFAboutViewController *aboutVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAboutViewController"];
            
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
            break;
        case 4:
        {
            XFHelpViewController *helpVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFHelpViewController"];
            
            [self.navigationController pushViewController:helpVC animated:YES];
            
        }
            break;
        case 5:
        {
            XFUserxieyiViewController *xieyiVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFUserxieyiViewController"];
            [self.navigationController pushViewController:xieyiVC animated:YES];
            
        }
            break;
        default:
        {
//            UIViewController *webVC = [[UIViewController alloc] init];
//            webVC.title = @"用户隐私协议";
//            CHWebView *webView = [[CHWebView alloc]initWithFrame:webVC.view.bounds];
//
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/mikemikezzz/p/8444299.html"]];
//
//            [webView loadRequest:request];
//            //    webView.delegate = self;
//            [webVC.view addSubview:webView];
//
//            [self.navigationController pushViewController:webVC animated:YES];


            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否拨打投诉电话" message:@"4000-560-128" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-560-128"];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:actionDone];
            [alert addAction:actionCancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
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


- (NSString *)fileSizeWithPath:(NSString *)path
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    if (attrs == nil) return 0;
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
            
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            
        }
        return sizeText;
    } else { // 如果是文件
        size = attrs.fileSize;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        
    }
    return sizeText;
}

@end
