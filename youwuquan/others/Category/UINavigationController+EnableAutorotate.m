//
//  UINavigationController+EnableAutorotate.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "UINavigationController+EnableAutorotate.h"

@implementation UINavigationController (EnableAutorotate)

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}
-(NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
