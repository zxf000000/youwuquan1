//
//  XFAlertViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAlertViewController.h"
#import "XFAlertTransition.h"
#import "XFMineNetworkManager.h"

#define kAlertViewWidth 300.f
#define kAlertViewHeight 287.f

@interface XFAlertViewController () <UIViewControllerTransitioningDelegate,UITextFieldDelegate>

@end


@implementation XFAlertViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.transitioningDelegate = self;
        

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.alertView = [[UIView alloc] init];
    self.alertView.frame = CGRectMake((kScreenWidth - kAlertViewWidth)/2, (kScreenHeight - kAlertViewHeight)/2, kAlertViewWidth, kAlertViewHeight);
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 15;
    [self.view addSubview:self.alertView];
    
    self.alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setImage:[UIImage imageNamed:@"dashang_cancel"] forState:(UIControlStateNormal)];
    [_alertView addSubview:_cancelButton];
    
    _cancelButton.frame = CGRectMake(kAlertViewWidth - 40, 0, 40, 40);
    
    [_cancelButton addTarget:self action:@selector(clickCencelbutton) forControlEvents:(UIControlEventTouchUpInside)];
    
    switch (self.type) {
        case XFAlertViewTypeChangeCoin:
            [self setupCoinAlertView];
            break;
        case XFAlertViewTypeUnlockStatus:
        {
            
            [self setupUnlockAlertView];
        }
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger number = [textField.text integerValue];
    
    if (number < 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确金额"];
        
        return;
        
    }
    
    [self getCoinsForDiamondsNum:number];
    
}

- (void)clickCencelbutton {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)clickDoneButton {
    
//    [self exchangeCoinsForDiamondsNum:[self.numberTextField.text integerValue]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.clickDoneButtonBlock) {
            self.clickDoneButtonBlock(self);
        }
    }];
    
}

- (void)clickOtherButton {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.clickOtherButtonBlock) {

            self.clickOtherButtonBlock(self);

        }
    }];

}

- (void)clickAddbutton:(UIButton *)button {
    
    if (button == self.addButton) {
        
        self.numberTextField.text = [NSString stringWithFormat:@"%zd",[self.numberTextField.text intValue] + 10];
        
        
    } else {
        
        if ([self.numberTextField.text intValue] > 0) {
            
            self.numberTextField.text = [NSString stringWithFormat:@"%zd",[self.numberTextField.text intValue] - 10];

        }

    }
    
    // 获取兑换数量
    
    if ([self.numberTextField.text intValue] < 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确金额"];
        
        return;
        
    }
    
    [self getCoinsForDiamondsNum:[self.numberTextField.text intValue]];
    
    [self.doneButton setTitle:[NSString stringWithFormat:@"支付%zd",[self.numberTextField.text intValue]] forState:(UIControlStateNormal)];

}

- (void)getCoinsForDiamondsNum:(NSInteger)num {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view];
    
    [XFMineNetworkManager getCoinsNumForDiamonds:num successBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];
        [_diamondsButton setTitle:[NSString stringWithFormat:@"%zd",[((NSDictionary *)responseObj)[@"from"] integerValue]] forState:(UIControlStateNormal)];
        [_coinButton setTitle:[NSString stringWithFormat:@"%zd",[((NSDictionary *)responseObj)[@"to"] integerValue]] forState:(UIControlStateNormal)];
        
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)exchangeCoinsForDiamondsNum:(NSInteger)diamonds {
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    animation.toValue = [NSValue valueWithCGPoint:(CGPointMake(1, 1))];
    
    animation.springSpeed = 20;
    animation.springBounciness = 10;
    
    [self.alertView pop_addAnimation:animation forKey:@""];
    
}

- (void)setupUnlockAlertView {
    
    self.titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_huiyuanka1"]];
    self.titleIcon.frame = CGRectMake((kAlertViewWidth - 120)/2,27, 120, 72);
    [self.alertView addSubview:self.titleIcon];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"成为会员或支付钻石解锁本条动态会员更优惠哦~";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.alertView addSubview:self.titleLabel];
    
    self.titleLabel.left = 38;
    self.titleLabel.top = self.titleIcon.bottom + 15;
    self.titleLabel.width = kAlertViewWidth - 76;
    self.titleLabel.height = 45;
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.backgroundColor = kMainRedColor;
    [self.doneButton setTitle:@"支付66" forState:(UIControlStateNormal)];
    [self.doneButton setImage:[UIImage imageNamed:@"zuanshi"] forState:(UIControlStateNormal)];
    [self.alertView addSubview:self.doneButton];
    
    self.doneButton.layer.cornerRadius = 22;
    
    self.doneButton.frame = CGRectMake(36, _titleLabel.bottom + 15, kAlertViewWidth - 72, 44);
    
    self.anotherButton = [[UIButton alloc] init];
    self.anotherButton.backgroundColor = kMainRedColor;
    [self.anotherButton setTitle:@"成为会员" forState:(UIControlStateNormal)];
    self.anotherButton.layer.cornerRadius = 22;

    [self.alertView addSubview:self.anotherButton];
    
    self.anotherButton.frame = CGRectMake(36, self.doneButton.bottom + 12, kAlertViewWidth - 72, 44);
    
    self.alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.anotherButton addTarget:self action:@selector(clickOtherButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setupCoinAlertView {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"请输入兑换钻石数量";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.alertView addSubview:self.titleLabel];

    self.titleLabel.left = 38;
    self.titleLabel.top =  45;
    self.titleLabel.width = kAlertViewWidth - 76;
    self.titleLabel.height = 15;
    

    
    self.numberTextField = [[UITextField alloc] init];
    self.numberTextField.textAlignment = NSTextAlignmentCenter;
    self.numberTextField.font = [UIFont systemFontOfSize:36];
    self.numberTextField.text = @"100";
    self.numberTextField.delegate = self;
    [self.alertView addSubview:self.numberTextField];
    
    self.numberTextField.frame = CGRectMake((kAlertViewWidth - 110)/2, self.titleLabel.bottom + 47, 110, 30);
    
    _minusButton = [[UIButton alloc] init];
    [_minusButton setImage:[UIImage imageNamed:@"gift_minus"] forState:(UIControlStateNormal)];
    [self.alertView addSubview:_minusButton];
    
    _addButton = [[UIButton alloc] init];
    [_addButton setImage:[UIImage imageNamed:@"gift_add"] forState:(UIControlStateNormal)];
    [self.alertView addSubview:_addButton];
    
    _minusButton.left = (kAlertViewWidth - 110 - 100)/2;
    _minusButton.top = self.titleLabel.bottom + 47;
    _minusButton.width = 50;
    _minusButton.height = 30;
    
    _addButton.left =  _minusButton.right + 110;
    _addButton.top = self.titleLabel.bottom + 47;
    _addButton.width = 50;
    _addButton.height = 30;
    
    _diamondsButton = [[UIButton alloc] init];
    [_diamondsButton setImage:[UIImage imageNamed:@"zuanshi"] forState:(UIControlStateNormal)];
    [_diamondsButton setTitle:@"10" forState:(UIControlStateNormal)];
    _diamondsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_diamondsButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.alertView addSubview:_diamondsButton];
    
    _coinButton = [[UIButton alloc] init];
    [_coinButton setImage:[UIImage imageNamed:@"money_jinbi"] forState:(UIControlStateNormal)];
    [_coinButton setTitle:@"100" forState:(UIControlStateNormal)];
    [_coinButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _coinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.alertView addSubview:_coinButton];
    
    _equalsLabel = [[UILabel alloc] init];
    _equalsLabel.text = @"=";
    _equalsLabel.textColor = [UIColor blackColor];
    [self.alertView addSubview:_equalsLabel];
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.backgroundColor = kMainRedColor;
    [self.doneButton setTitle:@"支付66" forState:(UIControlStateNormal)];
    [self.doneButton setImage:[UIImage imageNamed:@"zuanshi"] forState:(UIControlStateNormal)];
    [self.alertView addSubview:self.doneButton];
    
    self.doneButton.layer.cornerRadius = 22;
    
    _equalsLabel.top = _numberTextField.bottom + 34;
    _equalsLabel.left = 145;
    _equalsLabel.width = 10;
    _equalsLabel.height = 20;
    
    _diamondsButton.left = (kAlertViewWidth - 10 - 200)/2;
    _diamondsButton.top = _numberTextField.bottom + 34;
    _diamondsButton.width = 100;
    _diamondsButton.height = 20;
    
    _coinButton.left = _equalsLabel.right;
    _coinButton.height = 20;
    _coinButton.width = 100;
    _coinButton.top = _numberTextField.bottom + 34;
    
    _doneButton.frame = CGRectMake((kAlertViewWidth - 230)/2, _equalsLabel.bottom + 20, 230, 44);
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_addButton addTarget:self action:@selector(clickAddbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    [_minusButton addTarget:self action:@selector(clickAddbutton:) forControlEvents:(UIControlEventTouchUpInside)];
    
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [XFAlertTransition transitionWithtype:AlertPresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [XFAlertTransition transitionWithtype:AlertDismiss];
    
}
@end
