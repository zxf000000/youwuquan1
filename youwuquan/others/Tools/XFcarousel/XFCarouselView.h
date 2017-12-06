//
//  XFCarouselView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/11.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFCarouselView : UIView

-(void) setupWithArray:(NSArray *)array;
-(void) setupWithLocalArray:(NSArray *)array;

@property (strong, nonatomic) UIPageControl *wheelPageControl;

@end
