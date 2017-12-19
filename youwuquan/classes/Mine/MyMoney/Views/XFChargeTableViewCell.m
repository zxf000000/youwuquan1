//
//  XFChargeTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFChargeTableViewCell.h"


@implementation XFChargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    for (UIButton *button in self.numberButtons) {
        
        button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    
    
    self.payButton.layer.cornerRadius = 22;
    self.payButton.backgroundColor = kMainRedColor;

}

- (IBAction)clickPayButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chargeTableViewCell:didClickPayButton:)]) {
        [self.delegate chargeTableViewCell:self didClickPayButton:self.payButton];
    }
    
}




- (IBAction)clickNumberbutton:(UIButton *)sender {
    
    if (self.selectedButton) {
        self.selectedButton.selected = NO;

    }
    sender.selected = YES;
    self.selectedButton = sender;
    
}
- (IBAction)clickPayTypeButton:(UIButton *)sender {
    
    if (sender == self.weButton) {
        self.weButton.selected = YES;
        self.aliButton.selected = NO;
    } else {
        
        self.weButton.selected = NO;
        self.aliButton.selected = YES;
    }
    
}

@end
