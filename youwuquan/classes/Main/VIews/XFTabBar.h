//
//  XFTabBar.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFTabBar;

@protocol XFTabBarDelegate <UITabBarDelegate>

- (void)tabbarDidClickPlusButton:(XFTabBar *)tabbar;

@end

@interface XFTabBar : UITabBar

@property (nonatomic,assign) CGFloat tabBarItemWidth;


@property (nonatomic,weak) UIButton *plusButton;

@property (nonatomic,weak) id <XFTabBarDelegate> delegate;

@end
