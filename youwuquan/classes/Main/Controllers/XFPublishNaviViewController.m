//
//  XFPublishNaviViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPublishNaviViewController.h"
#import "XFPublishVCTransation.h"

@interface XFPublishNaviViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation XFPublishNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.transitioningDelegate = self;

    self.modalPresentationStyle = UIModalPresentationCustom;


}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [XFPublishVCTransation transitionWithtype:Present];
}

@end
