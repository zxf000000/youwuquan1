//
//  XFYouWuCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFYouWuCollectionViewCell.h"

@implementation XFYouWuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icons = @[@"A",@"C",@"D",@"F",@"H",@"M",@"P",@"R",@"S",@"T",@"V"];
    self.iconsVIew = [NSMutableArray array];
    for (NSInteger i = 0;i < 4;i ++ ) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.icons[i]]];
        
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLable);
            make.right.mas_offset(-i*(12 + 3)-8);
            make.width.height.mas_equalTo(12);
            
        }];
        
        [self.iconsVIew addObject:imageView];
    }
    
    [self setMyShadowWithColor:UIColorHex(808080)];

    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    
    self.picVIew.contentMode = UIViewContentModeScaleAspectFill;
    self.picVIew.layer.masksToBounds = YES;
}


- (void)setModel:(XFHomeDataModel *)model {
    
    _model = model;
    
    [_picVIew setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
    _nameLable.text = _model.nickname;
    
}

@end
