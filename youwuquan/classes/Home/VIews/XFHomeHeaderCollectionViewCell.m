//
//  XFHomeHeaderCollectionViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeHeaderCollectionViewCell.h"

@implementation XFHomeHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconVIew.layer.cornerRadius = 44;
    self.iconVIew.layer.masksToBounds = YES;
    self.vipImage.layer.cornerRadius = 7;
    self.vipImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.vipImage.layer.borderWidth = 2;
    
    self.layer.cornerRadius = 4;
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.9;
    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;

    
}
- (IBAction)clickDelegateButton:(id)sender {
    
    
}

@end
