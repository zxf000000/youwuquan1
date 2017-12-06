//
//  XFDownloadViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFDownloadPicCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *picView;

@end


@interface XFDownloadPicHeader : UICollectionReusableView
@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *daylabel;

@end

@interface XFDownloadViewController : XFOtherMainViewController



@end
