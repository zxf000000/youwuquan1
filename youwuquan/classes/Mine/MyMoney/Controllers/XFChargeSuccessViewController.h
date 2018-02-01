//
//  XFChargeSuccessViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOtherMainViewController.h"

typedef NS_ENUM(NSInteger,XFSuccessViewType) {
    
    XFSuccessViewTypeVipSuccess,
    XFSuccessViewTypeChargeSuccess,
    XFSuccessViewTypeVipFailed,
    XFSuccessViewTypeChargeFailed,
    
};

@interface XFChargeSuccessViewController : XFOtherMainViewController

@property (nonatomic,assign) XFSuccessViewType type;


@end
