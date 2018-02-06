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
       
        self.number = 1;
        
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

    self.numberLabel.layer.borderColor = UIColorHex(808080).CGColor;
    self.numberLabel.layer.borderWidth = 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%zd",self.number];

}

- (void)setPrice:(NSInteger)price {
    _price = price;
    [self.priceButton setTitle:[NSString stringWithFormat:@"合计 ¥ %zd 元",self.number * self.price] forState:(UIControlStateNormal)];

    
}

- (IBAction)clickCancelButton:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
- (IBAction)clickWxbutton:(id)sender {
    
    self.wxSelectedButton.selected = YES;
    self.aliSelectedbutton.selected = NO;
    
    
}
- (IBAction)clickAliButton:(id)sender {
    
    self.wxSelectedButton.selected = NO;
    self.aliSelectedbutton.selected = YES;
}


- (IBAction)clickAddbutton:(id)sender {
    
    self.number += 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%zd",self.number];
    [self.priceButton setTitle:[NSString stringWithFormat:@"合计 ¥ %zd 元",self.number * self.price] forState:(UIControlStateNormal)];

    
}

- (IBAction)clickMinusButton:(id)sender {
    
    if (self.number >= 2) {
        self.number -= 1;
        self.numberLabel.text = [NSString stringWithFormat:@"%zd",self.number];
        [self.priceButton setTitle:[NSString stringWithFormat:@"合计 ¥ %zd 元",self.number * self.price] forState:(UIControlStateNormal)];
    }
    
}

- (IBAction)clickPayButton:(id)sender {
    
    if (self.aliSelectedbutton.selected) {
        
        if (self.alipayBlock) {
            self.alipayBlock(self.number);
        }
        
    } else if (self.wxSelectedButton.selected){
        if (self.wxpayBlock) {
            self.wxpayBlock(self.number);
        }
    } else {
        
        [XFToolManager showProgressInWindowWithString:@"请选择支付方式"];
    }
    
}


@end
