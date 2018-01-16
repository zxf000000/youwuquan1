//
//  XFTabBarControllerConfig.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/16.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"
#import "XFTabBar.h"
#import "XFMineViewController.h"
#import "XFHomeViewController.h"
#import "XFFindViewController.h"
#import "XFMessageViewController.h"
#import "XFFindTextureViewController.h"
#import "XFPublishViewController.h"
#import "XFLoginVCViewController.h"
#import "XFPublishNaviViewController.h"
#import "XFLoginManager.h"
#import "XFMessageListViewController.h"
#import <UShareUI/UShareUI.h>




@interface XFTabBarControllerConfig : NSObject

@property (nonatomic, strong) CYLTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;

@end
