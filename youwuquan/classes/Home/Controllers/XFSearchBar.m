//
//  XFSearchBar.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSearchBar.h"

@implementation XFSearchBar

- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    _contentInset = contentInset;
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // view是searchBar中的唯一的直接子控件
    for (UIView *view in self.subviews) {
        // UISearchBarBackground与UISearchBarTextField是searchBar的简介子控件
        for (UIView *subview in view.subviews) {
            
            // 找到UISearchBarTextField
            if ([subview isKindOfClass:[UITextField class]]) {
                
                if (!UIEdgeInsetsEqualToEdgeInsets(_contentInset, UIEdgeInsetsZero)) { // 若contentInset被赋值
                    // 根据contentInset改变UISearchBarTextField的布局
                    
                    subview.frame = CGRectMake(_contentInset.left, _contentInset.top, self.bounds.size.width - _contentInset.left - _contentInset.right, self.bounds.size.height - _contentInset.top - _contentInset.bottom);
                    
                } else { // 若contentSet未被赋值
                    // 设置UISearchBar中UISearchBarTextField的默认边距
                    CGFloat top  = (self.bounds.size.height - 28.0) / 2.0;
                    CGFloat bottom = top;
                    CGFloat left = 8.0;
                    CGFloat right = left;
                    _contentInset = UIEdgeInsetsMake(top, left, bottom, right);
                }
            }
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
