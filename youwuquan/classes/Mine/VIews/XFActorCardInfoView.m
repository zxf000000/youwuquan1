//
//  XFActorCardInfoView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActorCardInfoView.h"

@implementation XFActorCardInfoView

- (instancetype)initWithFrame:(CGRect)frame type:(XFInfoCardViewType)type {
    
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        
        _nameView = [[UIView alloc] init];
        _nameView.backgroundColor = [UIColor clearColor];
        
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = [UIColor whiteColor];
        [_nameView addSubview:_upLine];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"演员姓名";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [_nameView addSubview:_nameLabel];
        
        _downLine = [[UIView alloc] init];
        _downLine.backgroundColor = [UIColor whiteColor];
        
        [_nameView addSubview:_downLine];
        

        
        // 生日
        _birthdayLabel = [[UILabel alloc] init];
        _birthdayLabel = [[UILabel alloc] init];
        _birthdayLabel.textColor = [UIColor whiteColor];
        _birthdayLabel.font = [UIFont systemFontOfSize:11];
        _birthdayLabel.text = @"生日: 1987.09.09";
        
        // 身高
        _heightLabel = [[UILabel alloc] init];
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.textColor = [UIColor whiteColor];
        _heightLabel.font = [UIFont systemFontOfSize:11];
        _heightLabel.text = @"身高: 189cm";
        
        // 体重
        _wightLabel = [[UILabel alloc] init];
        _wightLabel = [[UILabel alloc] init];
        _wightLabel.textColor = [UIColor whiteColor];
        _wightLabel.font = [UIFont systemFontOfSize:11];
        _wightLabel.text = @"体重: 60kg";
        
        // 胸围
        _xwLabel = [[UILabel alloc] init];
        _xwLabel = [[UILabel alloc] init];
        _xwLabel.textColor = [UIColor whiteColor];
        _xwLabel.font = [UIFont systemFontOfSize:11];
        _xwLabel.text = @"胸围: 99";
        
        // 腰围
        _yyLabel = [[UILabel alloc] init];
        _yyLabel = [[UILabel alloc] init];
        _yyLabel.textColor = [UIColor whiteColor];
        _yyLabel.font = [UIFont systemFontOfSize:11];
        _yyLabel.text = @"腰围: 40";
        
        
        // 臀围
        _twLabel = [[UILabel alloc] init];
        _twLabel = [[UILabel alloc] init];
        _twLabel.textColor = [UIColor whiteColor];
        _twLabel.font = [UIFont systemFontOfSize:11];
        _twLabel.text = @"臀围: 100";
        
        [self addSubview:_nameView];
        [self addSubview:_birthdayLabel];
        [self addSubview:_heightLabel];
        [self addSubview:_wightLabel];
        [self addSubview:_xwLabel];
        [self addSubview:_yyLabel];
        [self addSubview:_twLabel];
        
        
        NSMutableAttributedString *attrStr;
        
        switch (_type) {
                
            case InfoCardTypeCompact:
            {
                NSString *str = @"生日: 1987.9.19\n身高: 173cm\n体重: 50kg\n胸围: 88\n腰围: 60 臀围: 98";
                //创建NSMutableAttributedString
                attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                
            }
                break;
            case InfoCardTypeStandard:
            {
                NSString *str = @"\t\t\t\t生日\t\t\t\t\t\t\t\t身高\t\t\t\t\t\t体重\t\t\t\t胸围\t\t\t\t腰围\t\t\t\t臀围\n1987.9.19\t 173cm\t\t\t\t50kg\t\t\t\t\t88\t\t\t\t\t\t60\t\t\t\t\t\t\t98";
                attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                
            }
                break;
            case InfoCardTypeVertical:
            {
                NSString *str = @"生日: 1987.9.19\n身高: 173cm \n体重: 50kg\n胸围: 88 \n腰围: 60 \n臀围: 98";
                attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                
                
            }
                break;
            case InfoCardTypeRectangle:
            {
                NSString *str = @"生日: 1987.9.19\n身高: 173cm 体重: 50kg\n胸围: 88 腰围: 60 臀围: 98";
                attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                
            }
                break;
        }
        attrStr.lineSpacing = 5;
        
        _birthdayLabel.attributedText = attrStr;
        
//        NSString *str = @"生日: 1987.9.19\n身高: 173cm\n体重: 50kg\n胸围: 88\n腰围: 60\n臀围: 98";
//        //创建NSMutableAttributedString
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
//
//        //设置字体和设置字体的范围
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, 3)];
//        //添加文字颜色
//        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(17, 7)];
//        //添加文字背景颜色
//        [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(17, 7)];
//        //添加下划线
//        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 7)];
//        attrStr.lineSpacing = 5;
//        //自动换行
        _birthdayLabel.numberOfLines = 0;
//        //设置label的富文本
//        _birthdayLabel.attributedText = attrStr;
        //label高度自适应
        [_birthdayLabel sizeToFit];
        
        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)updateConstraints {
    
    if (self.type == InfoCardTypeStandard) {
        
        [_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset(75);
            make.centerY.mas_offset(0);
            
        }];
        
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset(10);
            make.centerY.mas_offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(24);
            
        }];
        [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_offset(0);
            make.height.mas_equalTo(2);
            
        }];
        
        [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.mas_offset(0);
            make.height.mas_equalTo(2);
            
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_offset(0);
            make.top.mas_equalTo(_upLine.mas_bottom);
            make.bottom.mas_equalTo(_downLine.mas_top);
            
        }];
        
    } else {
        
        [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(10);
            make.centerX.mas_offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(24);
            
        }];
        [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_offset(0);
            make.height.mas_equalTo(2);
            
        }];
        
        [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.mas_offset(0);
            make.height.mas_equalTo(2);
            
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.mas_offset(0);
            make.top.mas_equalTo(_upLine.mas_bottom);
            make.bottom.mas_equalTo(_downLine.mas_top);
            
        }];
        [_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(15);
            
        }];
        
    }
    
    

    

    
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
