//
//  XFVipCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/17.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFVipModel.h"

@interface XFVipCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,copy) void(^selectedBlock)(NSIndexPath *indexPath);

@property (nonatomic,strong) XFVipModel *model;


@end
