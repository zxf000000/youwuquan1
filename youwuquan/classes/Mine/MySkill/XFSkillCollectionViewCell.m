//
//  XFSkillCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSkillCollectionViewCell.h"

@implementation XFSkillCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.editButton.layer.cornerRadius = 5;
    self.editButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editButton.layer.borderWidth = 1;
    
    
}

- (void)setModel:(XFSkillModel *)model {
    
    _model = model;
    
    _iconView.image = [UIImage imageNamed:_model.icon];
    _nameLabel.text = _model.name;
    
    if (_model.status == 0) {
        
        _bgView.image = [UIImage imageNamed:@"skill_nolight"];
        [_editButton setTitle:@"点亮该技能" forState:(UIControlStateNormal)];
        
    } else {
        
        _bgView.image = [UIImage imageNamed:@"skill_Light"];
        [_editButton setTitle:@"编辑" forState:(UIControlStateNormal)];
        
    }
    
}



- (IBAction)clickEditButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(skillCell:didClickEditButtonWithStatus:skillId:)]) {
        
        [self.delegate skillCell:self didClickEditButtonWithStatus:self.model.status skillId:@""];
        
    }
    
}
@end
