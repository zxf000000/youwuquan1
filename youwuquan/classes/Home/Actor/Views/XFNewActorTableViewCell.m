//
//  XFNewActorTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNewActorTableViewCell.h"

@implementation XFNewActorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bgView setMyShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
