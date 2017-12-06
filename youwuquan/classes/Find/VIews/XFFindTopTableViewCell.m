//
//  XFFindTopTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindTopTableViewCell.h"

@implementation XFFindTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _picView.layer.cornerRadius = 4;
    _picView.layer.masksToBounds = YES;
    
    [self.bgView setMyShadowWithBounds:(CGRectZero)];
    self.bgView.layer.cornerRadius = 4;
}



@end
