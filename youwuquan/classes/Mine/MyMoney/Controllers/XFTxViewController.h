//
//  XFTxViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFOtherMainViewController.h"

@interface XFTransModel : NSObject

@property (nonatomic,copy) NSString *createTime;

@property (nonatomic,copy) NSString *diamonds;

@property (nonatomic,copy) NSString *event;

@property (nonatomic,copy) NSString *orderId;

@property (nonatomic,copy) NSString *type;


@end

@interface XFTxViewController : XFOtherMainViewController



@end
