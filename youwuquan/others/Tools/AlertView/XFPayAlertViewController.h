//
//  XFPayAlertViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/27.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFPayAlertViewController : UIViewController

@property (nonatomic,copy) void(^clickWxPayButtonBlock)(void);
@property (nonatomic,copy) void(^clickAliPaybuttonBlock)(void);

@property (nonatomic,strong) UIView *shadowView;

- (void)addButtonWithImage:(UIImage *)image title:(NSString *)title handle:(void(^)(void))clickHandle;

@property (nonatomic,strong) NSMutableArray *blocks;
@property (nonatomic,strong) NSMutableArray *buttons;

@end
