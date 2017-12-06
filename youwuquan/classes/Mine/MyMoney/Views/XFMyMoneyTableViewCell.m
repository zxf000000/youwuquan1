//
//  XFMyMoneyTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyMoneyTableViewCell.h"

@implementation XFMyMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.payButton.layer.cornerRadius = 4;
    self.payCoinButton.layer.cornerRadius = 4;
    self.castButton.layer.cornerRadius = 22;
}
- (IBAction)clickCashButton:(id)sender {
    
    if (self.clickCashButtonBlock) {
        
        self.clickCashButtonBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
