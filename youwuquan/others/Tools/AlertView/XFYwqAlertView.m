//
//  XFYwqAlertView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFYwqAlertView.h"

// 传统
#define kTopHeight 55.0
#define kBottomHeight 42.0
#define kDetailTopSpace 20.0
#define kDetailBottomSpace 50.0
#define kAlertViewWidth 235.0
#define kLeftPadding 16
#define kRightPadding 10
#define kAlertViewX ((kScreenWidth - kAlertViewWidth)/2.f)

// 打赏
#define kIconTop 34.5
#define kIconheight 44
#define kdetailTop 8
#define kdetailheight 15
#define kNumberTop 37
#define kNumberHeight 28
#define kLineTop 6.5
#define kDsButtonTop 31
#define kDsbuttonHeight 44
#define kRemainTop 11.5
#define kRemainHeight 11.5
#define kBottomSpacing 17
#define kDsAlertViewWidth 300
#define kDsAlertX ((kScreenWidth - kDsAlertViewWidth)/2.f)
#define kDsTotalHeight (kIconTop + kIconheight + kdetailTop + kdetailheight + kNumberTop + kNumberHeight + kLineTop + kDsButtonTop + kDsbuttonHeight + kRemainTop + kRemainHeight + kBottomSpacing)

@implementation XFYwqAlertView

+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)title detail:(NSString *)detail doneButtonTitle:(NSString *)done {
    
    XFYwqAlertView *alertView = [[self alloc] initWithTitle:title detail:detail done:done];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:alertView.shadowView];
    [window addSubview:alertView];
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    return alertView;
    
}


+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)title detail:(NSString *)detail {
    
    XFYwqAlertView *alertView = [[self alloc] initWithTitle:title detail:detail];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:alertView.shadowView];
    [window addSubview:alertView];
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    return alertView;
}

+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)detail icon:(NSString *)icon remainNUmber:(NSString *)remain {
    
    XFYwqAlertView *alertView = [[self alloc] initWithTitle:detail icon:icon remainNUmber:remain];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:alertView.shadowView];
    [window addSubview:alertView];
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);

    
    return alertView;
    
}

+ (instancetype)showToView:(UIView *)view withTitle:(NSString *)detail icon:(NSString *)icon needNUmber:(NSString *)remain {
    
    
    XFYwqAlertView *alertView = [[self alloc] initWithTitle:detail icon:icon needNUmber:remain];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:alertView.shadowView];
    [window addSubview:alertView];
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    return alertView;

}

+ (instancetype)showDiamond {
    
    XFYwqAlertView *alertView = [[self alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:alertView.shadowView];
    [window addSubview:alertView];
    
    alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    return alertView;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
    
}

- (void)diaShowanimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.shadowView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.shadowView removeFromSuperview];
            [self removeFromSuperview];
            
        });
    }];
}

- (instancetype)initWithTitle:(NSString *)detail icon:(NSString *)icon needNUmber:(NSString *)remain {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.frame = CGRectMake(kDsAlertX, (kScreenHeight - kDsTotalHeight)/2, kDsAlertViewWidth, kDsTotalHeight);
        
        self.layer.cornerRadius = 10;
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _shadowView.alpha = 0;
        _shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_pic8"]];
        //        [_iconView setImageWithURL:[NSURL URLWithString:icon] options:(YYWebImageOptionSetImageWithFadeAnimation)];
        [self addSubview:_iconView];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.text = [NSString stringWithFormat:@"查看%@的微信号",@"萱萱"];
        [self addSubview:_detailLabel];
        
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setImage:[UIImage imageNamed:@"dashang_cancel"] forState:(UIControlStateNormal)];
        [self addSubview:_cancelButton];
        
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        _numberTextField.font = [UIFont systemFontOfSize:36];
        _numberTextField.borderStyle = UITextBorderStyleNone;
        _numberTextField.text = @"100";
        [self addSubview:_numberTextField];
        _numberTextField.userInteractionEnabled = NO;
        
        _rewardButton = [[UIButton alloc] init];
        [_rewardButton setTitle:@"支付钻石" forState:(UIControlStateNormal)];
        _rewardButton.backgroundColor = kMainRedColor;
        _rewardButton.layer.cornerRadius = 22;
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_rewardButton];
        
        _remainNum = [[UILabel alloc] init];
        _remainNum.font = [UIFont systemFontOfSize:12];
        _remainNum.textColor = UIColorHex(808080);
        _remainNum.text = @"支付后,ta的微信号会以短信的形式发送您的手机";
        [self addSubview:_remainNum];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(kIconTop);
            make.centerX.mas_offset(0);
            make.width.height.mas_equalTo(44);
            
        }];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(13);
            make.right.mas_offset(-13);
            make.height.width.mas_equalTo(15);
            
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_iconView.mas_bottom).offset(kdetailTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kdetailheight);
            
        }];
        
        [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_detailLabel.mas_bottom).offset(kNumberTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kNumberHeight);
            
        }];
        
        [_rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_numberTextField.mas_bottom).offset(kDsButtonTop + kLineTop);
            make.left.mas_offset(35);
            make.right.mas_offset(-35);
            make.height.mas_equalTo(44);
            
        }];
        
        [_remainNum mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_rewardButton.mas_bottom).offset(kRemainTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kRemainHeight);
            
        }];
        
        [_rewardButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail done:(NSString *)done {
    
    if (self = [super init]) {
        
        _title = title;
        _detail = detail;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat detailHeight = [XFToolManager getHeightFortext:_detail width:kAlertViewWidth - kLeftPadding - kRightPadding font:[UIFont systemFontOfSize:14]];
        CGFloat height = kTopHeight + kBottomHeight + 1 + kDetailTopSpace + kDetailBottomSpace + detailHeight;
        self.frame = CGRectMake(kAlertViewX, (kScreenHeight - height)/2, kAlertViewWidth, height);
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _shadowView.alpha = 0;
        _shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = UIColorHex(f5f5f5);
        [self addSubview:_upLine];
        
        _downLine = [[UIView alloc] init];
        _downLine.backgroundColor = UIColorHex(f5f5f5);
        [self addSubview:_downLine];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = _detail;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.numberOfLines = 0;
        [self addSubview:_detailLabel];
        
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:done forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
        _doneButton .titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_doneButton];
        
        // 计算布局
        _titleLabel.frame = CGRectMake(0, 0, kAlertViewWidth, kTopHeight);
        _upLine.frame = CGRectMake(0, kTopHeight, kAlertViewWidth, 1);
        _detailLabel.frame = CGRectMake(16, kTopHeight + 1 + 20, kAlertViewWidth - 26, detailHeight);
        _downLine.frame = CGRectMake(0, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 1, kAlertViewWidth, 1);
        _doneButton.frame = CGRectMake(0, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 2, kAlertViewWidth , kBottomHeight);
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [_doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail {
    
    if (self = [super init]) {
        
        _title = title;
        _detail = detail;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat detailHeight = [XFToolManager getHeightFortext:_detail width:kAlertViewWidth - kLeftPadding - kRightPadding font:[UIFont systemFontOfSize:14]];
        CGFloat height = kTopHeight + kBottomHeight + 1 + kDetailTopSpace + kDetailBottomSpace + detailHeight;
        self.frame = CGRectMake(kAlertViewX, (kScreenHeight - height)/2, kAlertViewWidth, height);
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _shadowView.alpha = 0;
        _shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        _upLine = [[UIView alloc] init];
        _upLine.backgroundColor = UIColorHex(f5f5f5);
        [self addSubview:_upLine];
        
        _downLine = [[UIView alloc] init];
        _downLine.backgroundColor = UIColorHex(f5f5f5);
        [self addSubview:_downLine];
        
        _buttonLine = [[UIView alloc] init];
        _buttonLine.backgroundColor = UIColorHex(f5f5f5);
        [self addSubview:_buttonLine];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = _detail;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.numberOfLines = 0;
        [self addSubview:_detailLabel];
        
        _doneButton = [[UIButton alloc] init];
        [_doneButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [_doneButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
        _doneButton .titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_doneButton];
        
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:UIColorHex(808080) forState:(UIControlStateNormal)];
        _cancelButton .titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_cancelButton];
        
        // 计算布局
        _titleLabel.frame = CGRectMake(0, 0, kAlertViewWidth, kTopHeight);
        _upLine.frame = CGRectMake(0, kTopHeight, kAlertViewWidth, 1);
        _detailLabel.frame = CGRectMake(16, kTopHeight + 1 + 20, kAlertViewWidth - 26, detailHeight);
        _downLine.frame = CGRectMake(0, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 1, kAlertViewWidth, 1);
        _buttonLine.frame = CGRectMake((kAlertViewWidth - 1)/2.0, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 2, 1, kBottomHeight);
        _doneButton.frame = CGRectMake(0, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 2, (kAlertViewWidth - 1)/2.0, kBottomHeight);
        _cancelButton.frame = CGRectMake((kAlertViewWidth - 1)/2.0 + 1, kTopHeight + kDetailBottomSpace + kDetailTopSpace + detailHeight + 2, (kAlertViewWidth - 1)/2.0, kBottomHeight);
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        [_doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)detail icon:(NSString *)icon remainNUmber:(NSString *)remain {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.frame = CGRectMake(kDsAlertX, (kScreenHeight - kDsTotalHeight)/2, kDsAlertViewWidth, kDsTotalHeight);
        
        self.layer.cornerRadius = 10;
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _shadowView.alpha = 0;
        _shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_pic8"]];
        //        [_iconView setImageWithURL:[NSURL URLWithString:icon] options:(YYWebImageOptionSetImageWithFadeAnimation)];
        [self addSubview:_iconView];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.text = [NSString stringWithFormat:@"向%@打赏钻石",@"萱萱"];
        [self addSubview:_detailLabel];
        
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setImage:[UIImage imageNamed:@"dashang_cancel"] forState:(UIControlStateNormal)];
        [self addSubview:_cancelButton];
        
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.textAlignment = NSTextAlignmentCenter;
        _numberTextField.font = [UIFont systemFontOfSize:36];
        _numberTextField.borderStyle = UITextBorderStyleNone;
        _numberTextField.text = @"100";
        [self addSubview:_numberTextField];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorHex(e6e6e6);
        [self addSubview:lineView];
        
        _rewardButton = [[UIButton alloc] init];
        [_rewardButton setTitle:@"打赏" forState:(UIControlStateNormal)];
        _rewardButton.backgroundColor = kMainRedColor;
        _rewardButton.layer.cornerRadius = 22;
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_rewardButton];
        
        _remainNum = [[UILabel alloc] init];
        _remainNum.font = [UIFont systemFontOfSize:12];
        _remainNum.textColor = UIColorHex(808080);
        _remainNum.text = @"您目前钻石余额:  1000";
        [self addSubview:_remainNum];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(kIconTop);
            make.centerX.mas_offset(0);
            make.width.height.mas_equalTo(44);
            
        }];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(13);
            make.right.mas_offset(-13);
            make.height.width.mas_equalTo(15);
            
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_iconView.mas_bottom).offset(kdetailTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kdetailheight);
            
        }];
        
        [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_detailLabel.mas_bottom).offset(kNumberTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kNumberHeight);
            
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_numberTextField.mas_bottom).offset(kLineTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(110);
            
        }];
        [_rewardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(lineView.mas_bottom).offset(kDsButtonTop);
            make.left.mas_offset(35);
            make.right.mas_offset(-35);
            make.height.mas_equalTo(44);
            
        }];
        
        [_remainNum mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_rewardButton.mas_bottom).offset(kRemainTop);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(kRemainHeight);
            
        }];
        
        [_rewardButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        CGFloat width = 115;
        CGFloat height = 146;
        
        self.frame = CGRectMake((kScreenWidth - width)/2, (kScreenHeight - 146)/2, width, height);
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _shadowView.alpha = 0;
        _shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"diamond"];
        [self addSubview:_iconView];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:20];
        _detailLabel.textColor = kMainRedColor;
        _detailLabel.text = @"打赏成功";
        [self addSubview:_detailLabel];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_offset(0);
            make.centerX.mas_offset(0);
            
        }];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.mas_offset(0);
            make.centerX.mas_offset(0);
            
        }];
    }
    return self;
}

- (void)dsShowanimation {

    POPSpringAnimation *dropAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    //    dropAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, (kScreenHeight - self.frame.size.height)/2, self.frame.size.width, self.frame.size.height))];
    dropAnimation.toValue = [NSValue valueWithCGPoint:(CGPointMake(1, 1))];
    dropAnimation.springSpeed = 20;
    dropAnimation.springBounciness = 10;
    
    [self pop_addAnimation:dropAnimation forKey:@""];
    
    [UIView animateWithDuration:0.2 animations:^{
        
//        self.transform = CGAffineTransformMakeScale(1, 1);
        self.shadowView.alpha = 1;
        
    }];
}
- (void)dsHideAnimatedWithComplete:(animationCompleteBlock)complete {

    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.shadowView.alpha = 0;
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
        
        complete();
    }];
    
//    POPBasicAnimation *dropAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    dropAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, (kScreenHeight - self.frame.size.height)/2 + 30, self.frame.size.width, self.frame.size.height))];;
//    dropAnimation.duration = 0.1;
//    [self pop_addAnimation:dropAnimation forKey:@""];
//
//    dropAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//
//        POPBasicAnimation *upAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//        upAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, -self.bounds.size.height, self.frame.size.width, self.frame.size.height))];
//        upAnimation.duration = 0.1;
//        [self pop_addAnimation:upAnimation forKey:@""];
//
//        upAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//
//            [self removeFromSuperview];
//            [self.shadowView removeFromSuperview];
//
//            complete();
//
//        };
//    };
    
}


- (void)showAnimation {
    
    POPSpringAnimation *dropAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    dropAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, (kScreenHeight - self.frame.size.height)/2, self.frame.size.width, self.frame.size.height))];
    dropAnimation.toValue = [NSValue valueWithCGPoint:(CGPointMake(1, 1))];
    dropAnimation.springSpeed = 20;
    dropAnimation.springBounciness = 10;

    [self pop_addAnimation:dropAnimation forKey:@""];
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
       
//        self.transform = CGAffineTransformMakeScale(1, 1);
        self.shadowView.alpha = 1;
        
    }];
    
}



- (void)hideAnimatedWithComplete:(animationCompleteBlock)complete {
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.shadowView.alpha = 0;
        
    }];
    
    POPBasicAnimation *dropAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    dropAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, (kScreenHeight - self.frame.size.height)/2 + 30, self.frame.size.width, self.frame.size.height))];;
    dropAnimation.duration = 0.1;
    [self pop_addAnimation:dropAnimation forKey:@""];
    
    dropAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        POPBasicAnimation *upAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        upAnimation.toValue = [NSValue valueWithCGRect:(CGRectMake(kAlertViewX, -self.bounds.size.height, self.frame.size.width, self.frame.size.height))];
        upAnimation.duration = 0.1;
        [self pop_addAnimation:upAnimation forKey:@""];
        
        upAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
          
            [self removeFromSuperview];
            [self.shadowView removeFromSuperview];
            
            complete();
            
        };
    };
    
}

- (void)clickDoneButton:(UIButton *)button {
    
    [self dsHideAnimatedWithComplete:^{
        
        if (self.doneBlock) {
            
            self.doneBlock();
        }
    }];
}

- (void)clickCancelButton {

    [self dsHideAnimatedWithComplete:^{
        if (self.cancelBlock) {
            
            self.cancelBlock();
        }
    }];

    
}

- (void)dealloc {
    
    NSLog(@"%@",self.shadowView);
    
}

@end
