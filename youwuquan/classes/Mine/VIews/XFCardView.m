//
//  XFCardView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCardView.h"

@implementation XFCardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _canEdit = NO;
        
        [self setMyShadowWithColor:UIColorHex(808080)];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        
        _cardView = [[XFActorCardNode alloc] initWithFrame:(CGRectMake(0, 0, frame.size.width, frame.size.width * 68/73.f))];
        [self addSubview:_cardView];
        _cardView.userInteractionEnabled = NO;
        
        _button = [[UIButton alloc] init];
        _button.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width);
        [_button setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
        [_button setTitle:@"使用这个模板" forState:(UIControlStateNormal)];
        [self addSubview:_button];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font  =[UIFont systemFontOfSize:15];
        [self addSubview:_numberLabel];
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font  =[UIFont systemFontOfSize:12];
        _totalLabel.text = @"/3";
        [self addSubview:_totalLabel];
        
        [_button addTarget:self action:@selector(clickButton) forControlEvents:(UIControlEventTouchUpInside)];
        

        
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(0);
            make.top.mas_equalTo(_cardView.mas_bottom);
        }];
        
        [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_offset(-10);
            make.bottom.mas_offset(-10);
            
        }];
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(_totalLabel.mas_left);
            make.bottom.mas_offset(-10);
            
        }];
    }
    return self;
}

- (void)setLayoutWithFrame:(NSArray *)frame {
    
    [self.cardView setLayoutWith:frame];
    
}

- (void)setCanEdit:(BOOL)canEdit {
    
    _canEdit = canEdit;
    
    if (_canEdit) {
        
        _cardView.userInteractionEnabled = YES;
        
    } else {
        
        _cardView.userInteractionEnabled = NO;
    }
    
}

- (void)clickButton {
    
    if ([self.delegate respondsToSelector:@selector(cardView:didSelectedCardWithindex:)]) {
        
        [self.delegate cardView:self didSelectedCardWithindex:self.index];
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
