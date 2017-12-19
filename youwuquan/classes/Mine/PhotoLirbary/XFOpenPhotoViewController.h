//
//  XFOpenPhotoViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"
@class XFmyPhotoModel;


@interface XFOpenPhotoCell : UICollectionViewCell

@property (nonatomic,strong) XFmyPhotoModel *model;

@property (nonatomic,strong) UIButton *iconButton;

@property (nonatomic,strong) UIImageView *picView;

@end


@interface XFOpenPhotoViewController : XFOtherMainViewController

@property (nonatomic,copy) NSString *albumId;

@property (nonatomic,assign) BOOL iswall;


@end
