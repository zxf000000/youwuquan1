//
//  XFMyFansTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/31.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMyCaresViewController.h"

@interface XFMyFansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *careButton;
@property (nonatomic,strong) XFMyCareModel *model;
@property (nonatomic,copy) void(^clickCareButtonBlock)(XFMyFansTableViewCell *cell);
@end
