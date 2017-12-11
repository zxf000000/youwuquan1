//
//  UIView+GetBounes.m
//  HuiShang
//
//  Created by lai_mac on 2017/8/28.
//  Copyright © 2017年 lhn. All rights reserved.

#import "UIView+GetBounes.h"

@implementation UIView (GetBounes)


@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;
@dynamic width;
@dynamic height;

- (void)setTop:(CGFloat)top
{
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}
- (void)setLeft:(CGFloat)left
{
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}
- (void)setBottom:(CGFloat)bottom
{
    CGRect rect  = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}
- (void)setRight:(CGFloat)right
{
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}
- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}


- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)top
{
    return self.frame.origin.y;
}
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)left
{
    return self.frame.origin.x;
}
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

@end
