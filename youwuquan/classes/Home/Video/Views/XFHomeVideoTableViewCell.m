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
    
//    self.bgView.layer.masksToBounds = NO;
//    self.bgView.layer.shadowColor = UIColorFromHex(0xe5e5e5).CGColor;
//    self.bgView.layer.shadowRadius = 4;
//    self.bgView.layer.shadowOpacity = 0.9;
//    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    self.picView.layer.masksToBounds = YES;
    self.nameLabel.textInsets = UIEdgeInsetsMake(6, 0, 0, 0);
    
    self.nameLabel.bounds = [self.nameLabel.text boundingRectWithSize:(CGSizeMake(MAXFLOAT, self.nameLabel.frame.size.height)) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil];
    
    // 设置圆角
    
    self.iconVIew.layer.cornerRadius = 20;
    self.iconVIew.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconView)];
    self.iconVIew.userInteractionEnabled = YES;
    [self.iconVIew addGestureRecognizer:tapIcon];

    self.typeButton.layer.cornerRadius = 9;
    self.numberButton.layer.cornerRadius = 9;
    self.typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    
    self.timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
}

- (void)setModel:(XFVideoModel *)model {
    
    _model = model;
    
    [_picView setImageWithURL:[NSURL URLWithString:_model.coverImage[@"thumbImage500pxUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    _nameLabel.text = model.title;
    [_iconVIew setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
    [_numberButton setTitle:[NSString stringWithFormat:@"播放%zd次",[_model.viewNum intValue]] forState:(UIControlStateNormal)];
    
    [_typeButton setTitle:_model.category forState:(UIControlStateNormal)];
    
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

- (IBAction)clickShareButton:(id)sender {
}
@end
