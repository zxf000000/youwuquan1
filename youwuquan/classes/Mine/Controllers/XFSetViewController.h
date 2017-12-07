//
//  XFSetViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMainTableViewController.h"
#import "XFMainTabbarViewController.h"

@interface XFSetViewController : XFMainTableViewController
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic,strong) XFMainTabbarViewController *tabbarVC;

@end
