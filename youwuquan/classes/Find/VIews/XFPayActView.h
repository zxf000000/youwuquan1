//
//  XFPayView.h
//  youwuquan
//
//  Created by mr.zhou on 2018/1/27.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFPayActView : UIView
@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (weak, nonatomic) IBOutlet UIButton *alipButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,copy) void(^wxpayBlock)(void);
@property (nonatomic,copy) void(^alipayBlock)(void);
@property (nonatomic,copy) void(^cancelBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
