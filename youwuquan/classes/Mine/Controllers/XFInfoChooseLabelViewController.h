//
//  XFChooseLabelViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFInfoChooseLabelcell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@end

@interface XFInfoChooseLabelViewController : XFOtherMainViewController

@property (nonatomic,strong) NSMutableArray *selectedlabels;

@property (nonatomic,assign) NSInteger sex;

@property (nonatomic,copy) NSArray *tags;

@property (nonatomic,copy) void(^refreshTagsBlock)(NSArray *tags);

@end
