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
    
    [_iconView setImageWithURL:[NSURL URLWithString:_model.skillIcon] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    _nameLabel.text = _model.skillName;
    
}

- (void)setIsOpen:(BOOL)isOpen {
    
    _isOpen = isOpen;
    
    if (!isOpen) {
        _bgView.image = [UIImage imageNamed:@"skill_nolight"];
        [_editButton setTitle:@"点亮该技能" forState:(UIControlStateNormal)];
    } else {
        _bgView.image = [UIImage imageNamed:@"skill_Light"];
        [_editButton setTitle:@"编辑" forState:(UIControlStateNormal)];
        
        
    }
    
}


- (IBAction)clickEditButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(skillCell:didClickEditButtonWithStatus:skillId:)]) {
        
        [self.delegate skillCell:self didClickEditButtonWithStatus:self.isOpen skillId:@""];
        
    }
    
}
@end
