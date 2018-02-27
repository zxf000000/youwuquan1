//
//  XFHomeSectionFooter.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFHomeSectionFooter.h"

@implementation XFHomeSectionFooter

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kRGBColorWith(241, 241, 241);
        
        _moreButton = [[UIButton alloc] init];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"home_morebtn"] forState:(UIControlStateNormal)];
        [_moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_moreButton];
        
        _shadowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_moreshadow"]];
        [self addSubview:_shadowImage];
        
        [_moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)clickMoreButton {
    
    if (self.clickMoreButtonForSection) {
        
        self.clickMoreButtonForSection(self.section);
    }
}

- (void)updateConstraints {
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(20);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(26);
    }];
    
    [_shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.moreButton.mas_bottom);
        make.left.mas_equalTo(self.moreButton).offset(7);
        make.right.mas_equalTo(self.moreButton).offset(-7);
        make.height.mas_equalTo(21);
        
    }];
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
