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

- (void)setInfo:(NSDictionary *)info {
    
    _info = info;
    
    _totalInLabel.text = [NSString stringWithFormat:@"%@",_info[@"totalIncome"]];
    _canCashLabel.text = [NSString stringWithFormat:@"%@",_info[@"canBePresented"]];
    _cashedLabel.text = [NSString stringWithFormat:@"%@",_info[@"alreadyPresented"]];
    _diamondLabel.text = [NSString stringWithFormat:@"%@",_info[@"diamonds"]];
    _goadNumLabel.text = [NSString stringWithFormat:@"%@",_info[@"gold"]];
    
}
- (IBAction)clickPayButton:(id)sender {
    
    if (self.clickPayButtonBlock) {
        
        self.clickPayButtonBlock();
    }
    
}

- (IBAction)clickCashButton:(id)sender {
    
    if (self.clickCashButtonBlock) {
        
        self.clickCashButtonBlock();
    }
    
}

@end
