//
//  XFHomeSecCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeSecCollectionViewCell.h"

@implementation XFHomeSecCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    for (NSInteger i = 0 ; i < self.images.count ; i ++ ) {
        
        UIImageView *imgView = self.images[i];
        
        imgView.image = [UIImage imageNamed:self.icons[i]];
        
    }
    
    self.spaceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    
    [XFToolManager setTopCornerwith:4 view:self.picVIew];
    self.picVIew.layer.masksToBounds = YES;

    self.layer.masksToBounds = NO;
    self.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}


- (NSArray *)icons {
    
    if (_icons == nil) {
        
        _icons = @[@"home_vip",@"home_super",@"home_many",@"home_ruby"];
        
    }
    return _icons;
}

@end
