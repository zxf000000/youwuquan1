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

@property (nonatomic,copy) void(^wxpayBlock)(NSInteger number);
@property (nonatomic,copy) void(^alipayBlock)(NSInteger number);
@property (nonatomic,copy) void(^cancelBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)clickAddbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
- (IBAction)clickPayButton:(id)sender;
- (IBAction)clickMinusButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *wxSelectedButton;
@property (weak, nonatomic) IBOutlet UIButton *aliSelectedbutton;

@property (nonatomic,assign) NSInteger number;

@property (nonatomic,assign) NSInteger price;



@end
