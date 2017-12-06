//
//  XFVideoViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFVideoDetailViewController.h"

@interface XFVideoViewController : UIViewController

@property (nonatomic,copy) void(^selectedCellBlock)();

@property (nonatomic,assign) XFVideoVCType videoType;


@end
