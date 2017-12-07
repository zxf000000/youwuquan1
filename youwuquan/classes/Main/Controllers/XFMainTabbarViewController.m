//
//  XFMainTabbarViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMainTabbarViewController.h"
#import "XFTabBar.h"
#import "XFMineViewController.h"
#import "XFHomeViewController.h"
#import "XFFindViewController.h"
#import "XFMessageViewController.h"
#import "XFFindTextureViewController.h"
#import "XFPublishViewController.h"
#import "XFLoginVCViewController.h"
#import "XFPublishNaviViewController.h"
#import "XFMessageListViewController.h"

@interface XFMainTabbarViewController () <XFTabBarDelegate>

@property (nonatomic,assign) NSInteger index;


@end

@implementation XFMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    XFTabBar *tabbar = [[XFTabBar alloc] init];

    tabbar.delegate = self;

    [self setValue:tabbar forKey:@"tabBar"];
    
    XFHomeViewController *homeVC = [[XFHomeViewController alloc] init];
    
    UINavigationController *naviHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
//    XFFindViewController *findVC = [[XFFindViewController alloc] init];
    XFFindTextureViewController *findVC  =[[XFFindTextureViewController alloc] init];
    UINavigationController *naviFInd = [[UINavigationController alloc] initWithRootViewController:findVC];
    
    XFMessageListViewController *msgVC = [[XFMessageListViewController alloc] init];
//    XFMessageViewController *msgVC = [[XFMessageViewController alloc] init];
    
    UINavigationController *naviMsg = [[UINavigationController alloc] initWithRootViewController:msgVC];
    
    XFMineViewController *mineVC = [[XFMineViewController alloc] init];
    
    UINavigationController *naviMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    

    naviHome.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    [naviHome.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_homeSelected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    naviHome.tabBarItem.title = @"主页";
    
    naviFInd.tabBarItem.image = [UIImage imageNamed:@"tabbar_find"];
    [naviFInd.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_findSelected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    naviFInd.tabBarItem.title = @"发现";
    
    naviMsg.tabBarItem.image = [UIImage imageNamed:@"tabbar_message"];
    [naviMsg.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_messageSelected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];

    naviMsg.tabBarItem.title = @"消息";
    
    naviMine.tabBarItem.image = [UIImage imageNamed:@"tabbar_mine"];
    [naviMine.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_mineSelected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];

    naviMine.tabBarItem.title = @"我的";
    
    self.viewControllers = @[naviHome,naviFInd,naviMsg,naviMine];
    
    self.tabBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    // 黑线
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 1))];
    
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.tabBar addSubview:lineView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoginVC) name:@"dismissLoginVCNotification" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginVC) name:@"presentLoginVCNotification" object:nil];

    
}

- (void)presentLoginVC {
    
    XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
    
    UINavigationController *naviLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:naviLogin animated:YES completion:nil];
    
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissLoginVCNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"presentLoginVCNotification" object:nil];

    
}
// 退出登录页面的时候自动跳到首页
- (void)dismissLoginVC {
    
//    self.selectedIndex = 0;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if ([item.title isEqualToString:@"首页"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHomePAgeVisiable" object:nil];
        
    }
    
}

- (void)tabbarDidClickPlusButton:(XFTabBar *)tabbar {
    
    if ([XFUserInfoManager sharedManager].token) {
        
        XFPublishViewController *publishVC = [[XFPublishViewController alloc] init];
        XFPublishNaviViewController *navi = [[XFPublishNaviViewController alloc] initWithRootViewController:publishVC];
        [self presentViewController:navi animated:YES completion:nil];
        
    } else {
        
        XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
        
        UINavigationController *naviLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:naviLogin animated:YES completion:nil];

    }
    

}


@end
