//
//  XFVipTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVipTableViewCell.h"

@implementation XFVipTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.monthCardbutton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.jikaMonthCard.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.yearCardButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;

    self.weButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.aliButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.zuanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    self.payButton.layer.cornerRadius = 22;
    self.payButton.backgroundColor = kMainRedColor;
    
    self.card.layer.shadowColor = UIColorHex(808080).CGColor;
    self.card.layer.shadowOffset = CGSizeMake(0, 10);
    self.card.layer.shadowOpacity = 0.7;
    
    
}
- (IBAction)clickPayButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(vipTableViewCell:didClickPayButton:)]) {
        
        [self.delegate vipTableViewCell:self didClickPayButton:self.payButton];
        
    }
    
}

- (IBAction)clickCardButton:(UIButton *)sender {
    
    if (sender == self.monthCardbutton) {
        
        self.monthCardbutton.selected = YES;
        self.jikaMonthCard.selected = NO;
        self.yearCardButton.selected = NO;
        
    } else if (sender == self.jikaMonthCard) {
        self.monthCardbutton.selected = NO;
        self.jikaMonthCard.selected = YES;
        self.yearCardButton.selected = NO;
        
    } else {
        self.monthCardbutton.selected = NO;
        self.jikaMonthCard.selected = NO;
        self.yearCardButton.selected = YES;
        
    }
    
}
- (IBAction)clickPayTypeButton:(UIButton *)sender {
    
    if (sender == self.weButton) {
        
        self.weButton.selected = YES;
        self.aliButton.selected = NO;
        self.zuanButton.selected = NO;
        
    } else if (sender == self.aliButton) {
        self.weButton.selected = NO;
        self.aliButton.selected = YES;
        self.zuanButton.selected = NO;
        
    } else {
        self.weButton.selected = NO;
        self.aliButton.selected = NO;
        self.zuanButton.selected = YES;
        
    }
    
}

@end
