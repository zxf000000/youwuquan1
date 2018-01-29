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
    self.iconsVIew = [NSMutableArray array];
    for (NSInteger i = 0;i < 4;i ++ ) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.icons[i]]];
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.mas_offset(i*(12 + 3)+8);
            make.width.height.mas_equalTo(12);
            
        }];
        
        [self.iconsVIew addObject:imageView];
    }
    
    [self setMyShadowWithRound:4];
}

- (void)setHomeModel:(XFHomeDataModel *)homeModel {
    
    _homeModel = homeModel;
    _nameLabel.text = _homeModel.nickname;
    [_picView setImageWithURL:[NSURL URLWithString:_homeModel.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
//    [_distanceButton setTitle:[NSString stringWithFormat:@"%@km",_model.distance] forState:(UIControlStateNormal)];
    
    _distanceButton.hidden = YES;
    
    for (NSInteger i = 0;i < 4;i ++ ) {
        
        UIImageView *imageView = self.iconsVIew[i];
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.nameLabel);
            make.right.mas_offset(-i*(12 + 3)+8);
            make.width.height.mas_equalTo(12);
            
        }];
    }
    
}

- (void)setModel:(XFNearModel *)model {
    
    _model = model;
    _nameLabel.text = _model.nickname;
    [_picView setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];

    [_distanceButton setTitle:[NSString stringWithFormat:@"%.2fkm",[_model.distance floatValue]] forState:(UIControlStateNormal)];
}


@end
