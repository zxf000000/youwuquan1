//
//  XFNearbyTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNearbyTableViewCell.h"

@implementation XFNearbyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icons = @[@"A",@"C",@"D",@"F",@"H",@"M",@"P",@"R",@"S",@"T",@"V"];
    
    for (NSInteger i = 0;i < 4;i ++ ) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.icons[i]]];
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.mas_offset(i*(12 + 3)+8);
            make.width.height.mas_equalTo(12);
            
        }];
    }
    
    [self setMyShadowWithRound:4];
}

- (void)setModel:(XFNearModel *)model {
    
    _model = model;
    _nameLabel.text = _model.nickname;
    [_picView setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];

    [_distanceButton setTitle:[NSString stringWithFormat:@"%@km",_model.distance] forState:(UIControlStateNormal)];
}


@end
