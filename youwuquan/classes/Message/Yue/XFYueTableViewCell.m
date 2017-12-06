//
//  XFYueTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFYueTableViewCell.h"

@implementation XFYueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView.layer.cornerRadius = 22;
    _iconView.layer.masksToBounds = YES;
    
    self.bgView.image = [[UIImage imageNamed:@"chat_qipao1"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    
    self.acceptButton.layer.cornerRadius = 5;
    self.deButton.layer.cornerRadius = 5;
    
    self.deButton.layer.borderColor = UIColorHex(808080).CGColor;
    self.deButton.layer.borderWidth = 1;
}


@end
