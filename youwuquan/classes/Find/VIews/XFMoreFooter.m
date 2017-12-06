//
//  XFMoreFooter.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMoreFooter.h"

@implementation XFMoreFooter


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *moreButton = [[UIButton alloc] init];
        
        [moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
        
        [moreButton setTitleColor:kMainColor forState:(UIControlStateNormal)];
        
        [moreButton setImage:[UIImage imageNamed:@"actor_down"] forState:(UIControlStateNormal)];
        
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:moreButton];
        
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
        
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_offset(0);
            
        }];
        
        [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(UIControlEventTouchUpInside)];

        
    }
    return self;
    
}

- (void)clickMoreButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickMoreButtonWithFooter:section:)]) {
        
        [self.delegate didClickMoreButtonWithFooter:self section:self.section];
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
