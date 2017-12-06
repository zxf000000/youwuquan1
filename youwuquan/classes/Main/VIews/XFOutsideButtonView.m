//
//  XFOutsideButtonView.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOutsideButtonView.h"

@implementation XFOutsideButtonView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围父视图
        
        CGPoint stationPoint = [self.outsideButton convertPoint:point fromView:self];
        
        if (CGRectContainsPoint(self.outsideButton.bounds, stationPoint))
        {
            view = self.outsideButton;
        }
        
    }
    return view;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//
//    NSLog(@"%@---%@---%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.outsideButton.frame),NSStringFromCGPoint(point));
//
//    CGRect frame = self.frame;
//
//    frame.origin.x = -20;
//
//    if (CGRectContainsPoint(self.frame, point) && CGRectContainsPoint(frame, point)) {
//
//        return YES;
//
//    }
//
//    return NO;
//
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
