//
//  XFMyFansTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/31.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFMyFansTableViewCell.h"

@implementation XFMyFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;

    [self.careButton setBackgroundImage:[UIImage imageWithColor:kMainRedColor] forState:(UIControlStateNormal)];
    
    [self.careButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:(UIControlStateSelected)];
    
    [self.careButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    [self.careButton setTitle:@"互相关注" forState:(UIControlStateSelected)];
    [self.careButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.careButton setTitleColor:UIColorHex(808080) forState:(UIControlStateSelected)];
    _careButton.layer.borderWidth = 1;
    [_careButton addTarget:self action:@selector(clickCareButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)clickCareButton {
    
    if (self.clickCareButtonBlock) {
        
        self.clickCareButtonBlock(self);
    }
    
}

- (void)setModel:(XFMyCareModel *)model {
    
    _model = model;
    
    [_iconView setImageWithURL:[NSURL URLWithString:_model.headIconUrl] placeholder:[UIImage imageNamed:@"zhanweitu44"]];
    _nameLabel.text = _model.nickname;
    _detailLabel.text = _model.introduce;
    
    if ([_model.followEach isEqualToString:@"each"]) {
        
        _careButton.selected = YES;
        _careButton.layer.borderColor = UIColorHex(808080).CGColor;
    } else {
        
        _careButton.selected = NO;
        _careButton.layer.borderColor = UIColorHex(FFFFFF).CGColor;
    }
    
    
}


@end
