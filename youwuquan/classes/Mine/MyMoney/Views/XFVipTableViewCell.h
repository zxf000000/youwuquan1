//
//  XFVipTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFVipTableViewCell;

@protocol XFVipTableViewCellDelegate <NSObject>

- (void)vipTableViewCell:(XFVipTableViewCell *)cell didClickPayButton:(UIButton *)payButton;

@end

@interface XFVipTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *monthCardbutton;
@property (weak, nonatomic) IBOutlet UIButton *jikaMonthCard;
@property (weak, nonatomic) IBOutlet UIButton *yearCardButton;
@property (weak, nonatomic) IBOutlet UIButton *weButton;
@property (weak, nonatomic) IBOutlet UIButton *aliButton;
@property (weak, nonatomic) IBOutlet UIButton *zuanButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIImageView *card;

@property (nonatomic,strong) id <XFVipTableViewCellDelegate> delegate;

@end
