//
//  XFYueViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

typedef NS_ENUM (NSInteger,XFYueVCType) {
    
    LikeComment,
    System,
    Activity,
};

@interface XFYueViewController : XFOtherMainViewController

@property (nonatomic,copy) NSArray *msgs;

@property (nonatomic,assign) BOOL hasSeprator;

@property (nonatomic,assign) XFYueVCType type;


@end
