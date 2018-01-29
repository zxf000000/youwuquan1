//
//  XFCommentMessageTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCommentMessageTableViewCell.h"

@implementation XFCommentMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView.layer.cornerRadius = 22.5;
    _iconView.layer.masksToBounds = YES;

}



@end
