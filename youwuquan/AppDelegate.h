//
//  AppDelegate.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XFMainTabbarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic,strong) XFMainTabbarViewController *mainTabbar;

- (void)saveContext;

@property (nonatomic,assign) BOOL isLogin;


// 检查订单
@property (nonatomic,assign) BOOL isAlreadChecked;



@end

