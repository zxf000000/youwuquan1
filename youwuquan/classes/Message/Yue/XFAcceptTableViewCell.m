//
//  XFAcceptTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAcceptTableViewCell.h"

@implementation XFAcceptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentBg.image = [[UIImage imageNamed:@"chat_qipao1"] stretchableImageWithLeftCapWidth:10 topCapHeight:15];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
