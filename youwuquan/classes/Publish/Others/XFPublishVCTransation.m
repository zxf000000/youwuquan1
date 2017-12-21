//
//  XFPublishVCTransation.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPublishVCTransation.h"
#import "XFGiftViewController.h"

#define kGiftHeight (kScreenWidth * 44 / 35.f)

@implementation XFPublishVCTransation

+ (instancetype)transitionWithtype:(XFPresenttransationType)type {
    
    return [[XFPublishVCTransation alloc] initWithType:type];
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
            
        case Present:
        {
            [self presentAnimation:transitionContext];

        }
            break;
        case GiftPresent:
        {
            
            [self giftPresentAnimation:transitionContext];
            
        }
            break;
        case GiftDismiss:
        {
            
            [self giftDismissAnimation:transitionContext];
            
        }
            break;
            case Dismiss:
        {
            
            [self dismissAnimation:transitionContext];

        }
            break;
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

- (void)giftDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    XFGiftViewController *fromVC = (XFGiftViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
//    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
//    toVC.view.frame = containerView.bounds;
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    
//    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(10, (kScreenHeight - kGiftHeight),containerView.width - 20, kGiftHeight)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(10, containerView.height,containerView.width - 20, kGiftHeight)];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    

    POPBasicAnimation *alpani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alpani.toValue = @(0);
    alpani.duration = 0.3;
    
    [fromVC.view pop_addAnimation:animation forKey:@""];
    [fromVC.shadowView pop_addAnimation:alpani forKey:@""];
    
    alpani.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [fromVC.shadowView removeFromSuperview];
        [fromVC.view removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) {
            
        } else {
            
        }

    };
}

- (void)giftPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    XFGiftViewController *toVC = (XFGiftViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    toVC.shadowView = [[UIView alloc] init];
    toVC.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    toVC.shadowView.backgroundColor = [UIColor blackColor];
    toVC.shadowView.alpha = 0;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.shadowView];
    [containerView addSubview:toVC.view];
    
    toVC.view.frame = CGRectMake(10, containerView.height,containerView.width - 20, containerView.height - 80);

    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(10, (kScreenHeight - kGiftHeight)/2, containerView.width - 20, kGiftHeight)];
    
    [toVC.view pop_addAnimation:animation forKey:@""];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        toVC.shadowView.alpha = 0.7;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:finished];
        
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把vc1显示出来
            fromVC.view.hidden = NO;
        }
        
    }];
    
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
        
//        fromVC.view.hidden = YES;
        
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
