//
//  XFActivityViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActivityViewController.h"

@interface XFActivityViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *bmButton;

@end

@implementation XFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动详情";
    
    [self initViews];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)clickBmButton {
    
    [XFToolManager showJiaHUDToView:self.navigationController.view string:@"报名成功"];

}

- (void)initViews {
    
    self.bmButton = [[UIButton alloc] init];
    self.bmButton.backgroundColor = kMainRedColor;
    [self.bmButton setTitle:@"报名" forState:(UIControlStateNormal)];
    [self.bmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.bmButton];
    
    
    UIImage *img = [UIImage imageNamed:@"huodong"];
    CGSize imggSize = img.size;
    
//    CGFloat width = kScreenWidth;
    CGFloat height = kScreenWidth / imggSize.width * imggSize.height;
    
    self.scrollView = [[UIScrollView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.scrollView addSubview:imgView];
    self.scrollView.contentSize = CGSizeMake(0, height);
    [self.view addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.bmButton addTarget:self action:@selector(clickBmButton) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)updateViewConstraints {
    
    [self.bmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_offset(0);
        make.bottom.mas_equalTo(self.bmButton.mas_top);
        
    }];
    [super updateViewConstraints];
}

@end
