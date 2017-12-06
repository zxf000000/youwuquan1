//
//  XFMyMoneyTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMyMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *payCoinButton;
@property (weak, nonatomic) IBOutlet UIButton *castButton;

@property (nonatomic,copy) void(^clickCashButtonBlock)(void);

@end
