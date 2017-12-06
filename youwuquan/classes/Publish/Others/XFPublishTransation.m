//
//  XFPublishVCTransation.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPublishTransation.h"

@implementation XFPublishTransation

+ (instancetype)transitionWithtype:(XFPresenttransationType)type {
    
    return [[XFPublishTransation alloc] initWithType:type];
}

- (instancetype)initWithType:(XFPresenttransationType)type {
    
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
            
//        case Present:
//        {
//            [self presentAnimation:transitionContext];
//
//        }
//            break;
//            case Dismiss:
//        {
//
//            [self dismissAnimation:transitionContext];
//
//        }
//            break;
        case Push:
        {
            
            [self pushAnimation:transitionContext];
        }
            break;
        case Pop:
        {
            [self popAnimation:transitionContext];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, containerView.height);

    [UIView animateWithDuration:0.2 animations:^{
        
        toVC.view.frame = CGRectMake(0, 0, containerView.width, containerView.height);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {

    
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    toVC.view.frame = CGRectMake(0, 0, containerView.width, containerView.height);
    toVC.view.alpha = 0;
//    fromVC.view.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
        }

    }];

}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //    fromVC.view.hidden = YES;
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    toVC.view.frame = containerView.bounds;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        fromVC.view.hidden = YES;

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) {
//            fromVC.view.hidden = NO;
        } else {
            
//            [fromVC.view removeFromSuperview];
        }
        
    }];
    
}


@end
