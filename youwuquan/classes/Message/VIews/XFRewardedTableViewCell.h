//
//  XFRewardedTableViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/14.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMessageRewardedCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@interface XFRewardedTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
