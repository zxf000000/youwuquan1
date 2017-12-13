//
//  XFHomeVideoTableViewCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeVideoTableViewCell.h"

@implementation XFHomeVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
    self.bgView.layer.shadowRadius = 4;
    self.bgView.layer.shadowOpacity = 0.9;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
//    self.playNumberButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    self.picView.layer.masksToBounds = YES;
    self.nameLabel.textInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    
    self.nameLabel.bounds = [self.nameLabel.text boundingRectWithSize:(CGSizeMake(MAXFLOAT, self.nameLabel.frame.size.height)) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil];
    
    // 设置圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth, self.picView.frame.size.height)     byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = CGRectMake(0, 0, kScreenWidth - 10, self.picView.frame.size.height);
//    maskLayer.path = maskPath.CGPath;
//    self.picView.layer.mask = maskLayer;
    
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconView)];
    self.iconVIew.userInteractionEnabled = YES;
    [self.iconVIew addGestureRecognizer:tapIcon];
    
    
    
}

- (void)tapIconView {
    
    if ([self.delegate respondsToSelector:@selector(videoCell:didClickIconWithjindexpath:)]) {
        
        [self.delegate videoCell:self didClickIconWithjindexpath:self.indexPath];
        
    }
    
}

- (IBAction)clickLikeButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [XFToolManager popanimationForLikeNode:sender.layer complate:^{
        
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
