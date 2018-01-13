//
//  XFAlertTransition.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAlertTransition.h"
#import "XFAlertViewController.h"

@implementation XFAlertTransition

+ (instancetype)transitionWithtype:(XFAlertPresenttransationType)type {
    
    return [[XFAlertTransition alloc] initWithType:type];
}

- (instancetype)initWithType:(XFAlertPresenttransationType)type {
    
    if (self = [super init]) {
        
        _type = type;
        
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.4;
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (_type) {
            
        case AlertPresent:
        {
            [self presentAnimation:transitionContext];
        }
            break;
        case AlertDismiss:
        {
            [self dismissAnimation:transitionContext];

        }
            break;
            
    }
    
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    XFAlertViewController *toVC = (XFAlertViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.shadowView];
    [containerView addSubview:toVC.view];
    
    toVC.shadowView.frame = CGRectMake(0, 0, containerView.width, containerView.height);
    toVC.view.frame = CGRectMake(0, 0, containerView.width, containerView.height);
    
    [UIView animateWithDuration:0.3 animations:^{
    
        toVC.shadowView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
        }
        
    }];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    XFAlertViewController *fromVC = (XFAlertViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    
    [UIView animateWithDuration:0.3 animations:^{
        
        fromVC.shadowView.alpha = 0;
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [fromVC.view removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.hidden = NO;
        } else {
            
        }
        
    }];
    
}



@end
