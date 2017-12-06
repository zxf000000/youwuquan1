//
//  XFSlideView.h
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFSlideViewDelegate <NSObject>



@end

@interface XFSlideView : UIView

- (instancetype)initWithTitle:(NSArray *)titles;

@property (nonatomic,strong) id<XFSlideViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *titlesView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) void(^clickButtonBlock)(NSInteger tag);

@end
