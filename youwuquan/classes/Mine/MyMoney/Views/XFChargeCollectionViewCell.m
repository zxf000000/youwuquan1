//
//  XFChargeCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/17.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFChargeCollectionViewCell.h"

@implementation XFChargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.giftLabel.layer.cornerRadius = 5;
    self.giftLabel.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.borderColor = UIColorHex(e0e0e0).CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)setModel:(XFChargeModel *)model {
    
    _model = model;

    _priceLabel.text = _model.price;
    _diamondsLabel.text = _model.diamonds;
    
    NSString *title = _model.title;
    if (title.length > 0) {

        _giftLabel.text = title;

    } else {
        
        _giftLabel.hidden = YES;
    }
    

    
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

- (void)setIsAuto:(BOOL)isAuto {
    
    _isAuto = isAuto;
    
    if (_isAuto) {
        
        _giftLabel.hidden = YES;
        _diamondsLabel.hidden = YES;
        _priceLabel.hidden = YES;
        _picView.hidden = YES;
        _label1.hidden = YES;
        _autoLabel.hidden = NO;
        
    } else {
        
        _giftLabel.hidden = NO;
        _diamondsLabel.hidden = NO;
        _priceLabel.hidden = NO;
        _picView.hidden = NO;
        _label1.hidden = NO;
        _autoLabel.hidden = YES;
    }
    
}

@end
