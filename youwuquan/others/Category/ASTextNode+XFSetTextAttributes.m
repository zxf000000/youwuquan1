//
//  ASTextNode+XFSetTextAttributes.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "ASTextNode+XFSetTextAttributes.h"

@implementation ASTextNode (XFSetTextAttributes)

- (void)setFont:(UIFont *)font alignment:(NSTextAlignment)textAlignment textColor:(UIColor *)color offset:(CGFloat)offset text:(NSString *)text lineSpace:(NSInteger)lineSpace kern:(NSInteger)kern {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineSpacing = lineSpace;
    
    str.attributes = @{NSFontAttributeName: font,
                
                       NSForegroundColorAttributeName: color,
                       
                       NSParagraphStyleAttributeName: paragraphStyle,
                       NSBaselineOffsetAttributeName: @(offset),// 基线偏移,保持垂直居中
                       NSKernAttributeName : @(kern), // 字间距
                       };
    
    self.attributedText = str;
    
}

@end
