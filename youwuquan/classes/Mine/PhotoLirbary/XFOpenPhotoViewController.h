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

@property (nonatomic,strong) UIButton *deleteButton;

@end


typedef NS_ENUM(NSInteger, OPenPhotoVCType) {
    
    OPenPhotoVCTypeWall,
    OPenPhotoVCTypeOpen,
    OPenPhotoVCTypeClose,
    
    
};

@interface XFOpenPhotoViewController : XFOtherMainViewController

@property (nonatomic,copy) NSString *albumId;

@property (nonatomic,assign) BOOL iswall;

@property (nonatomic,assign)  OPenPhotoVCType type;


@end
