//
//  XFLeaderboardTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFLeaderboardModel.h"
#import "XFLeaderboardViewController.h"

@interface XFLeaderboardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic,strong) XFRichlistModel *model;

@end
