//
//  XFHomeSectionHeader.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeSectionHeader.h"

@implementation XFHomeSectionHeader

- (instancetype)init {
    
    if (self = [super init]) {
        
        _leftImage = [[UIImageView alloc] init];
        
        _leftImage.image = [UIImage imageNamed:@"home_rline"];
        
        [self addSubview:_leftImage];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.text = @"新晋网红";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_titleLabel];
        
        _moreButton = [[UIButton alloc] init];
        
        [_moreButton setImage:[UIImage imageNamed:@"home_more"] forState:(UIControlStateNormal)];
        
        [_moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
        
        [_moreButton setTitleColor:UIColorFromHex(0xf72f5e) forState:(UIControlStateNormal)];

        _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        _moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        [self addSubview:_moreButton];
        
        [_moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)clickMoreButton {
    
    if ([self.delegate respondsToSelector:@selector(homeSectionHeader:didClickButton:atSection:)]) {
        
        [self.delegate homeSectionHeader:self didClickButton:self.moreButton atSection:self.section];
    }
}

- (void)updateConstraints {
    
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(0);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(3);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.leftImage.mas_right).offset(10);
        make.centerY.mas_offset(0);
        
        
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-12);
        make.width.mas_equalTo(70);
        make.centerY.mas_offset(0);
        
    }];
    
    [super updateConstraints];
}


@end
