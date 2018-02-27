//
//  XFLittleImageSlider.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLittleImageSlider.h"

@implementation XFLittleImageSlider

//这个方法用于改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    
    bounds = [super thumbRectForBounds:bounds trackRect:rect value:value]; // 这次如果不调用的父类的方法 Autolayout 倒是不会有问题，但是滑块根本就不动~
    
    CGFloat w = 13;
    CGFloat h = 13;
    
    return CGRectMake(bounds.origin.x, bounds.origin.y, w, h); // w 和 h 是滑块可触摸范围的大小，跟通过图片改变的滑块大小应当一致。

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
