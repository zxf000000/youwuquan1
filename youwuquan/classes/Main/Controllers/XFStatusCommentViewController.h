//
//  XFStatusCommentViewController.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFStatusCommentViewController : UIViewController

@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UITextField *inputTextField;

- (void)clickSendButton;

- (void)hide;

@end
