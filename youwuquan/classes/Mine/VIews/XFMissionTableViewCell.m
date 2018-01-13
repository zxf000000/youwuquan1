//
//  XFMissionTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMissionTableViewCell.h"

@implementation XFMissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XFMissionModel *)model {
    
    _model = model;
    
    _coinLabel.text = [NSString stringWithFormat:@"%@金币",_model.category[@"coin"]];
    _numberLabel.text = [NSString stringWithFormat:@"已完成(%@/%@)",_model.currentProgress,_model.totalProgress];
    _titleLabel.text = _model.category[@"title"];
    _desLabel.text = _model.category[@"subTitle"];
    
    if ([_model.currentProgress isEqualToString:_model.totalProgress]) {
        
        _numberLabel.text = @"√ 已完成该任务";
        
    }
    
}

@end
