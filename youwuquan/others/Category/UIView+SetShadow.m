//
//  UIView+SetShadow.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/31.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "UIView+SetShadow.h"

@implementation UIView (SetShadow)

- (void)setMyShadow {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
}

- (void)setMyShadowWithRound:(CGFloat)corner {
    
    UIBezierPath *bezierPah = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPah.CGPath;
    self.layer.mask = shapeLayer;
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.frame = self.bounds;
    [self.layer addSublayer:shadowLayer];
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowColor = UIColorHex(000000).CGColor;
    shadowLayer.shadowRadius = 0;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shadowOffset = CGSizeMake(1, 2);
}

- (void)setMyShadowWithBounds:(CGRect)bounds {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = UIColorFromHex(0x505050).CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
}

- (void)setMyShadowWithColor:(UIColor *)color {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
}

@end
