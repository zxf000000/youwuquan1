//
//  XFMissionTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFMissionModel.h"

@interface XFMissionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (nonatomic,strong) XFMissionModel *model;

@end
