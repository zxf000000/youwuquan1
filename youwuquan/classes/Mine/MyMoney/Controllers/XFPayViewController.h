//
//  XFPayViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

typedef NS_ENUM (NSInteger,XFPayVCType) {

    XFPayVCTypeVIP,
    XFPayVCTypeCharge

};

@interface XFPayViewController : XFOtherMainViewController

@property (nonatomic,assign) XFPayVCType type;

@property (nonatomic,copy) NSString *diamondsNum;

@end
