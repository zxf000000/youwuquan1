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
    
    [self setMyShadowWithRound:4];
}

- (void)setHomeModel:(XFHomeDataModel *)homeModel {
    
    _homeModel = homeModel;
    _nameLabel.text = _homeModel.nickname;
    [_picView setImageWithURL:[NSURL URLWithString:_homeModel.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
//    [_distanceButton setTitle:[NSString stringWithFormat:@"%@km",_model.distance] forState:(UIControlStateNormal)];
    
    _distanceButton.hidden = YES;
    
    // 小图标们
    NSArray *identifications = _model.identifications;
    
    NSMutableArray *icons = [NSMutableArray array];
    for (NSInteger i= 0 ; i < identifications.count ; i ++ ) {
        
        if ([[XFAuthManager sharedManager].ids containsObject:[NSString stringWithFormat:@"%@",identifications[i]]]) {
            
            NSInteger index = [[XFAuthManager sharedManager].ids indexOfObject:[NSString stringWithFormat:@"%@",identifications[i]]];
            
            XFNetworkImageNode *imgNode = [[XFNetworkImageNode alloc] init];
            imgNode.url = [NSURL URLWithString:[XFAuthManager sharedManager].icons[index]];
            [self addSubnode:imgNode];
            
            [icons addObject:imgNode];
        }
    }
    
    _authenticationIcons = icons.copy;
    
    for (NSInteger i = 0;i < _authenticationIcons.count;i ++ ) {
        
        XFNetworkImageNode *imageView = _authenticationIcons[i];
        
        [self.contentView addSubnode:imageView];
        
        [imageView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
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
    // 小图标们
    NSArray *identifications = _model.identifications;
    
    NSMutableArray *icons = [NSMutableArray array];
    for (NSInteger i= 0 ; i < identifications.count ; i ++ ) {
        
        if ([[XFAuthManager sharedManager].ids containsObject:[NSString stringWithFormat:@"%@",identifications[i]]]) {
            
            NSInteger index = [[XFAuthManager sharedManager].ids indexOfObject:[NSString stringWithFormat:@"%@",identifications[i]]];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImageWithURL:[NSURL URLWithString:[XFAuthManager sharedManager].icons[index]] options:(YYWebImageOptionSetImageWithFadeAnimation)];

            [self.contentView addSubview:imgView];
            
            [icons addObject:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(self.nameLabel);
                make.right.mas_offset(-i*(12 + 3)+8);
                make.width.height.mas_equalTo(12);
                
            }];
        }
    }
    
    _authenticationIcons = icons.copy;
}


@end
