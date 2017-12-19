//
//  XFChargeTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFChargeTableViewCell;

@protocol XChargeTableViewCellDelegate <NSObject>

- (void)chargeTableViewCell:(XFChargeTableViewCell *)cell didClickPayButton:(UIButton *)payButton;

@end

@interface XFChargeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;

@property (weak, nonatomic) IBOutlet UIButton *weButton;
@property (weak, nonatomic) IBOutlet UIButton *aliButton;

@property (nonatomic,strong) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic,strong) id <XChargeTableViewCellDelegate> delegate;


@end
