//
//  XFChargeSmallTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFChargeSmallTableViewCell.h"

@implementation XFChargeSmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_monneyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_monneyButton setTitleColor:kMainRedColor forState:(UIControlStateSelected)];
    
    _monneyButton.layer.borderColor = UIColorHex(808080).CGColor;
    _monneyButton.layer.borderWidth = 1;
    _monneyButton.layer.cornerRadius = 5;
    
}

- (void)setInfo:(NSDictionary *)info {
    
    _info = info;
    
    _diamondsCountLabel.text = info[@"diamonds"];
    [_monneyButton setTitle:info[@"money"] forState:(UIControlStateNormal)];
    [_monneyButton setTitle:info[@"money"] forState:(UIControlStateSelected)];

}

- (IBAction)clickMOneyButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        _monneyButton.layer.borderColor = kMainRedColor.CGColor;
        
    } else {
        
        _monneyButton.layer.borderColor = UIColorHex(808080).CGColor;

    }
    
    if (self.clickButtonBlock) {
        
        self.clickButtonBlock(self.indexPath, sender);
    }
    
}
@end
