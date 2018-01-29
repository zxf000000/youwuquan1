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

@property (nonatomic,copy) void(^refreshMsgBlock)(NSArray *systemMsgs);

@property (nonatomic,assign) CGFloat headerHeight;

@property (nonatomic,copy) NSArray *likeDatas;
@property (nonatomic,copy) NSArray *otherDatas;

- (void)reloadData;
@end
