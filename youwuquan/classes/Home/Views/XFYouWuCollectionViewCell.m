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
    
    // 小图标们
    NSArray *identifications = _model.identifications;
    
    NSMutableArray *icons = [NSMutableArray array];
    for (NSInteger i= 0 ; i < identifications.count ; i ++ ) {
        
        if ([[XFAuthManager sharedManager].ids containsObject:[NSString stringWithFormat:@"%@",identifications[i]]]) {
            
            NSInteger index = [[XFAuthManager sharedManager].ids indexOfObject:[NSString stringWithFormat:@"%@",identifications[i]]];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImageWithURL:[NSURL URLWithString:[XFAuthManager sharedManager].icons[index]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
            
            [self.contentView addSubview:imgView];
            
            [icons addObject:imgView];
            
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_nameLable);
                make.right.mas_offset(-i*(12 + 3)-8);
                make.width.height.mas_equalTo(12);
                
            }];
        }
    }
    
    
}

@end
