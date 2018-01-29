//
//  XFYouwuViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XFYouwuVCType) {
  
    Nethot,
    Youwu,
    
};

@interface XFYouwuViewController : UIViewController

@property (nonatomic,assign) XFYouwuVCType type;

- (void)loadData;

@end
