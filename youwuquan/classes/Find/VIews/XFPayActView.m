//
//  XFPayView.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/27.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPayActView.h"

@implementation XFPayActView

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"XFPayActView" owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.wxButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(808080)] forState:(UIControlStateHighlighted)];
    [self.alipButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(808080)] forState:(UIControlStateHighlighted)];

}
- (IBAction)clickCancelButton:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
- (IBAction)clickWxbutton:(id)sender {
    
    if (self.wxpayBlock) {
        self.wxpayBlock();
    }
    
}
- (IBAction)clickAliButton:(id)sender {
    
    if (self.alipayBlock) {
        
        self.alipayBlock();
        
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
