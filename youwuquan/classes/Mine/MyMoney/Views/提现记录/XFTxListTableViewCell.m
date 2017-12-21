//
//  XFTxListTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTxListTableViewCell.h"

@implementation XFTxListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_moneyLabel];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_offset(-20);
            make.centerY.mas_offset(0);
            
        }];
    }
    return self;
}

@end
