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
- (IBAction)clickShareButton:(id)sender {
    
    if (self.clickShareButtonBlock) {
        self.clickShareButtonBlock();
    }
    
}

- (void)setModel:(XFMyMoneyModel *)model {
    
    _model = model;
    
    _totalInLabel.text = [NSString stringWithFormat:@"%zd",[_model.phoneReceive integerValue] + [_model.publishReceive integerValue] + [_model.rewardReceive integerValue] + [_model.sharedReceive integerValue] + [_model.wechatReceive integerValue]];
    _tcNumLabel.text = [NSString stringWithFormat:@"%zd",[_model.sharedReceive integerValue]];
    _photoReciveNum.text = [NSString stringWithFormat:@"%zd",[_model.publishReceive integerValue]];
    _wechatReciveNum.text = [NSString stringWithFormat:@"%zd",[_model.phoneReceive integerValue] + [_model.wechatReceive integerValue]];
    _canCashLabel.text = _diamondLabel.text = [NSString stringWithFormat:@"%zd",[_model.balance integerValue]];;
    _cashedLabel.text = [NSString stringWithFormat:@"%zd",[_model.withdraw integerValue]];
    _goadNumLabel.text = [NSString stringWithFormat:@"%zd",[_model.coin integerValue]];
    _personNUmLabel.text = [NSString stringWithFormat:@"%@",_model.tuiguangNum];

}

- (IBAction)clickCoinButton:(id)sender {
    
    if (self.clickCoinButtonBlock) {
        
        self.clickCoinButtonBlock();
        
    }
    
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

- (IBAction)clickChoujiangButton:(UIButton *)sender {
    
    if (self.clickChouJiangBlock) {
        self.clickChouJiangBlock();
    }
    
}
@end
