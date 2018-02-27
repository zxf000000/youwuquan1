//
//  XFYouWuCollectionViewCell.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFHomeDataModel.h"
#import "XFNetworkImageNode.h"
@interface XFYouWuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picVIew;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (nonatomic,strong) XFHomeDataModel *model;

@property (nonatomic,strong) NSMutableArray *iconsVIew;

@property (nonatomic,copy) NSArray *icons;

@property (nonatomic,strong) XFNetworkImageNode *imgNode;

@end
