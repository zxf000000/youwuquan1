//
//  UIView+SetShadow.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SetShadow)

- (void)setMyShadow;

- (void)setMyShadowWithBounds:(CGRect)bounds;
- (void)setMyShadowWithColor:(UIColor *)color;
- (void)setMyShadowWithRound:(CGFloat)corner;
@end
