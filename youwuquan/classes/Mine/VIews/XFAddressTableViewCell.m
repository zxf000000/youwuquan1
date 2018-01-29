//
//  XFAddressTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/24.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFAddressTableViewCell.h"

@implementation XFAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (self.selected) {
        
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        
        self.accessoryType = UITableViewCellAccessoryNone;

    }
    
    // Configure the view for the selected state
}

- (void)setModel:(XFAddressModel *)model {
    
    _model = model;
    _nameLabel.text = _model.name;
    _phoneLabel.text = _model.phone;
    _provenceLabel.text = _model.province;
    _cityLabel.text = _model.city;
    _detailLabel.text = _model.detail;
}

- (IBAction)clickEditbutton:(id)sender {
    
    if (self.clickEditButtonBlock) {
        
        self.clickEditButtonBlock(self.model);
        
    }
    
}

- (IBAction)clickDeleteButton:(id)sender {
    
    if (self.clickDeleteButtonBlock) {
        
        self.clickDeleteButtonBlock(self.model);
    }
    
}
@end
