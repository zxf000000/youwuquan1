//
//  UIButton+NaviBackButton.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/18.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "UIButton+NaviBackButton.h"

@implementation UIButton (NaviBackButton)

+ (instancetype)naviBackButton {
    
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 30))];
    [button setImage:[UIImage imageNamed:@"login_back"] forState:(UIControlStateNormal)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);

    return button;
}

+ (instancetype)noneNaviWhiteBackButton {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    
    [backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    backButton.frame = CGRectMake(10, 30, 40, 30);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    return backButton;
    
}

@end
