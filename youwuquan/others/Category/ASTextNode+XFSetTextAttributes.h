//
//  ASTextNode+XFSetTextAttributes.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASTextNode (XFSetTextAttributes)

- (void)setFont:(UIFont *)font alignment:(NSTextAlignment)textAlignment textColor:(UIColor *)color offset:(CGFloat)offset text:(NSString *)text lineSpace:(NSInteger)lineSpace kern:(NSInteger)kern;


@end
