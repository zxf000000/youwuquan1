//
//  XFSlideView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSlideView.h"

@implementation XFSlideView

- (instancetype)initWithTitle:(NSArray *)titles {
    
    if (self = [super init]) {
        
        _titlesView = [NSMutableArray array];

        _titles = titles;
        for (NSInteger i = 0 ; i < titles.count ; i ++ ) {
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:_titles[i] forState:(UIControlStateNormal)];
            button.tag = 1001 + i;
            [button setTitleColor:kMainRedColor forState:(UIControlStateSelected)];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

            [_titlesView addObject:button];
            [self addSubview:button];
            
            [button addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (i == 0) {
                
                button.selected = YES;
            }
        }
        
        _slideView = [[UIView alloc] init];
        _slideView.backgroundColor = kMainRedColor;
        [self addSubview:_slideView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)clickTopButton:(UIButton *)sender {
    
    self.clickButtonBlock(sender.tag);
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(2);
        make.bottom.mas_offset(0);
        make.centerX.mas_equalTo(sender);
        make.width.mas_equalTo(50);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self layoutIfNeeded];
        
    }];
    
    for (UIButton *button in _titlesView) {
        
        if (button == sender) {
            button.selected = YES;
        } else {
            
            button.selected = NO;
        }
        
    }
    
}

- (void)updateConstraints {
    
    for (NSInteger i = 0 ; i < self.titlesView.count; i ++ ) {
        
        UIButton *button = self.titlesView[i];
        
        UIButton *firstButton = self.titlesView[0];
        
        CGFloat spacing = (kScreenWidth - 100)/3.f;
        
        if (i == 0) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_offset(0);
                make.bottom.mas_offset(0);
                make.left.mas_offset(spacing);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(44);
                
            }];
        } else
        
        if (i == self.titlesView.count - 1) {

            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_offset(0);
                make.bottom.mas_offset(0);
                make.right.mas_offset(-spacing);
                make.left.mas_equalTo(firstButton.mas_right).offset(spacing);
                make.width.mas_equalTo(firstButton);
                make.height.mas_equalTo(44);

            }];
            
        } else {
            
            UIButton *beforbutton = self.titlesView[i-1];
            UIButton *afterbutton = self.titlesView[i+1];

            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_offset(0);
                make.bottom.mas_offset(0);
                make.right.mas_equalTo(afterbutton.mas_left);
                make.width.mas_equalTo(firstButton);
                make.left.mas_equalTo(beforbutton.mas_right);
                make.height.mas_equalTo(44);

            }];
            
        }
        

        
    }
    
    UIButton *firstbutton = self.titlesView[0];

    for (UIButton *button in self.titlesView) {
        
        if (button.selected) {
            
            firstbutton = button;
        }
        
    }
    

    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(2);
        make.bottom.mas_offset(0);
        make.centerX.mas_equalTo(firstbutton);
        make.width.mas_equalTo(50);
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
