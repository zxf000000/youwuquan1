//
//  XFMessageListTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMessageListTableViewCell.h"

@implementation XFMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    
}


@end
