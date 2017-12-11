//
//  XFDiamondCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/9.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XFDiamondCollectionViewCell : RCMessageCell

/**
 * 消息显示Label
 */
@property(strong, nonatomic) RCAttributedLabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;

@end
