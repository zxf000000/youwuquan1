//
//  XFCashViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFCashViewController.h"

@interface XFCashViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *alipayTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;

@end

@implementation XFCashViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"提现";
    
    [self setupViews];
    
}


- (void)setupViews {
    
    self.cashButton.layer.cornerRadius = 22;
    
    self.nameView.layer.cornerRadius = self.alipayView.layer.cornerRadius = self.numberView.layer.cornerRadius = 5;
    
    self.nameView.layer.borderWidth = self.alipayView.layer.borderWidth = self.numberView.layer.borderWidth = 1;
    self.nameView.layer.borderColor = self.alipayView.layer.borderColor = self.numberView.layer.borderColor = UIColorHex(808080).CGColor;

    
}


@end
