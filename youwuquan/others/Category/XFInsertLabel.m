//
//  XFInsertLabel.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/26.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFInsertLabel.h"

@implementation XFInsertLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}


@end
