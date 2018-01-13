//
//  XFLeaderboardTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLeaderboardTableViewCell.h"

@implementation XFLeaderboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width/2;
    self.iconView.layer.masksToBounds = YES;
    

}

- (void)setModel:(XFRichlistModel *)model {
    
    _model = model;
    
    _nameLabel.text = _model.nickname;
    _countLabel.text = _model.balance;

    [_iconView setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
