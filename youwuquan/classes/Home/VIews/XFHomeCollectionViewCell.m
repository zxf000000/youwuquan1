//
//  XFHomeCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeCollectionViewCell.h"

@implementation XFHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置部分圆角
    [XFToolManager setTopCornerwith:4 view:self.picView];
    
    self.picView.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 0);

    for (NSInteger i = 0 ; i < self.images.count ; i ++ ) {
        
        UIImageView *imgView = self.images[i];
        
        imgView.image = [UIImage imageNamed:self.icons[i]];
        
    }
    
    
}

- (NSArray *)icons {
    
    if (_icons == nil) {
        
        _icons = @[@"home_vip",@"home_super",@"home_many",@"home_ruby"];
        
    }
    return _icons;
}

@end
