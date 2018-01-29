//
//  XFRefreshInfoViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/24.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFRefreshInfoViewController : XFOtherMainViewController

@property (nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic,copy) void(^refreshInfoBlock)(void);

@end
