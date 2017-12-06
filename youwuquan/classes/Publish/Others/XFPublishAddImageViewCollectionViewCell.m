//
//  XFPublishAddImageViewCollectionViewCell.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/19.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFPublishAddImageViewCollectionViewCell.h"

@implementation XFPublishAddImageViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picView.userInteractionEnabled = YES;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicView)];
    
    [self.picView addGestureRecognizer:_tap];
    // Initialization code
}

- (void)removeTap {
    
    [self.picView removeGestureRecognizer:self.tap];
    
}

- (IBAction)clickDeleteButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(publishCollectionCell:didClickDeleteButtonWithIndexPath:)]) {
    
        [self.delegate publishCollectionCell:self didClickDeleteButtonWithIndexPath:self.indexpath];
    
    }
    
}

- (void)tapPicView {

    if ([self.delegate respondsToSelector:@selector(publishCollectionCell:didClickItemWithIndexPath:)]) {
        [self.delegate publishCollectionCell:self didClickItemWithIndexPath:self.indexpath];
    }

}

@end
