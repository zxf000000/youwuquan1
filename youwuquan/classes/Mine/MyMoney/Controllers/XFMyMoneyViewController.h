//
//  XFMyMoneyViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFMyMoneyModel : NSObject

@property (nonatomic,copy) NSString *balance;

@property (nonatomic,copy) NSString *publishExpense;
@property (nonatomic,copy) NSString *publishReceive;

@property (nonatomic,copy) NSString *recharge;

@property (nonatomic,copy) NSString *rewardReceive;
@property (nonatomic,copy) NSString *rewardExpense;

@property (nonatomic,copy) NSString *sharedReceive;
@property (nonatomic,copy) NSString *sharedExpense;

@property (nonatomic,copy) NSString *updateTime;

@property (nonatomic,copy) NSString *wechatReceive;
@property (nonatomic,copy) NSString *wechatExpense;

@property (nonatomic,copy) NSString *withdraw;

@property (nonatomic,copy) NSString *coin;

@property (nonatomic,copy) NSString *phoneExpense;
@property (nonatomic,copy) NSString *phoneReceive;



@end


@interface XFMyMoneyViewController : XFOtherMainViewController

@end
