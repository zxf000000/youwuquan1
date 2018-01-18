//
//  XFVipCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/17.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFVipCollectionViewCell.h"

@implementation XFVipCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.giftLabel.layer.cornerRadius = 5;
    self.giftLabel.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.borderColor = UIColorHex(e0e0e0).CGColor;
    self.bgView.layer.borderWidth = 1;
    
}


- (void)setModel:(XFVipModel *)model {
    
    _model = model;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@天",_model.day];
    _priceLabel.text = [NSString stringWithFormat:@"%@.00",_model.price];
    
}


- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.bgView.backgroundColor = kRGBColorWith(254, 247, 241);
        self.bgView.layer.borderColor = kRGBColorWith(237, 116, 88).CGColor;
        
        if (self.selectedBlock) {
            self.selectedBlock(self.index);
        }
        
    } else {
        
        self.bgView.layer.borderColor = UIColorHex(e0e0e0).CGColor;
        self.bgView.backgroundColor = [UIColor whiteColor];

    }
    
}

@end
