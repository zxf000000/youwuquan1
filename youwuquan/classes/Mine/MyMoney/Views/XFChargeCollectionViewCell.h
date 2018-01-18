//
//  XFChargeCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/17.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFChargeModel.h"

@interface XFChargeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *autoLabel;

@property (nonatomic,strong) XFChargeModel *model;

@property (nonatomic,assign) BOOL isAuto;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,copy) void(^selectedBlock)(NSIndexPath *indexPath);

@end
