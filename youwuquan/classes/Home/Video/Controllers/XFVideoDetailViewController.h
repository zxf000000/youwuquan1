//
//  XFVideoDetailViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"
#import "XFStatusCommentViewController.h"
#import "XFStatusModel.h"
#import "XFVideoModel.h"

typedef NS_ENUM(NSInteger,XFVideoVCType) {
    
    Hightdefinition,
    VRVideo,
    
};

@interface XFVideoDetailViewController : XFStatusCommentViewController

@property (nonatomic,assign) XFVideoVCType type;

@property (nonatomic,strong) XFVideoModel *model;

@end
