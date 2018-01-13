//
//  XFAlertTransition.h
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,XFAlertPresenttransationType) {
  
    AlertPresent,
    AlertDismiss,
};

@interface XFAlertTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithtype:(XFAlertPresenttransationType)type;

@property (nonatomic,assign) XFAlertPresenttransationType type;



@end
