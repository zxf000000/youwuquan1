//
//  XFMyMoneyTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMyMoneyViewController.h"


@interface XFMyMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *payCoinButton;
@property (weak, nonatomic) IBOutlet UIButton *castButton;
@property (weak, nonatomic) IBOutlet UILabel *photoReciveNum;
@property (weak, nonatomic) IBOutlet UILabel *wechatReciveNum;
@property (weak, nonatomic) IBOutlet UILabel *personNUmLabel;
@property (weak, nonatomic) IBOutlet UILabel *tcNumLabel;

@property (nonatomic,copy) void(^clickCashButtonBlock)(void);
@property (nonatomic,copy) void(^clickPayButtonBlock)(void);
@property (nonatomic,copy) void(^clickChouJiangBlock)(void);
@property (nonatomic,copy) void(^clickShareButtonBlock)(void);
@property (nonatomic,copy) void(^clickCoinButtonBlock)(void);

@property (weak, nonatomic) IBOutlet UILabel *totalInLabel;
@property (weak, nonatomic) IBOutlet UILabel *canCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashedLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) IBOutlet UILabel *goadNumLabel;


@property (nonatomic,strong) XFMyMoneyModel *model;

@property (nonatomic,copy) NSDictionary *info;
- (IBAction)clickChoujiangButton:(UIButton *)sender;

@end
