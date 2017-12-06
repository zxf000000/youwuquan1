//
//  XFNetHotViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/9.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XFNetHotVCType) {
    
    XFNetHotVCTypeYW,
    XFNetHotVCTypeWh,
    
};

@interface XFNetHotViewController : UIViewController

@property (nonatomic,assign) XFNetHotVCType type;


@end
