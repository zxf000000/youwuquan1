//
//  XFMessageViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMainViewController.h"
@class XFMessageViewController;

@protocol XFMessageVCDelegate <NSObject>


@end

@interface XFMessageViewController : UIViewController

@property (nonatomic,copy) void(^changeHeaderHeightBlock)(CGFloat height);

@property (nonatomic,assign) CGFloat headerHeight;


@end
