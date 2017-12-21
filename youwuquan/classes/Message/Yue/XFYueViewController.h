//
//  XFYueViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"
typedef NS_ENUM(NSInteger,XFSystemMsgType) {
    
    XFSystemMsgTypeActivity,
    XFSystemMsgTypelikePic,
    XFSystemMsgTypeLikeNoPic,
    XFSystemMsgTypeCommentPic,
    XFSystemMsgTypeCommentNoPic,
    XFSystemMsgTypeSystem,
    
};

@interface XFYueViewController : XFOtherMainViewController

@property (nonatomic,strong) NSMutableArray *msgs;

@property (nonatomic,assign) BOOL hasSeprator;


@end
