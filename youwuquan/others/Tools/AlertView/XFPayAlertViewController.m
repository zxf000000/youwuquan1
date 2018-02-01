//
//  XFPayAlertViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/27.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPayAlertViewController.h"
#import "XFPublishVCTransation.h"

@interface XFPayAlertViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) UIView *payView;

@property (nonatomic,assign) NSInteger buttonCount;


@end

@implementation XFPayAlertViewController
- (instancetype)init {
    
    if (self = [super init]) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.transitioningDelegate = self;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.blocks = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
}

- (void)addButtonWithImage:(UIImage *)image title:(NSString *)title handle:(void(^)(void))clickHandle {
    
    UIButton *button = [[UIButton alloc] init];

    [button addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    button.backgroundColor = [UIColor whiteColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(e0e0e0)] forState:(UIControlStateHighlighted)];
    [self.view addSubview:button];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [button addSubview:imgView];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    [button addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.frame = CGRectMake((kScreenWidth - 100)/2, 0, 100, 49);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    imgView.frame = CGRectMake(kScreenWidth/2 - 50 - 25, 12.5, 25, 25);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorHex(f4f4f4);
    [self.view addSubview:line];
    self.buttonCount += 1;
    button.frame = CGRectMake(0, kScreenHeight - 50 * (self.buttonCount), kScreenWidth, 50);
    line.frame = CGRectMake(0, kScreenHeight - 50 * (self.buttonCount) + 49, kScreenWidth, 1);
    [_buttons addObject:button];
    [_blocks addObject:clickHandle];
}

- (void)clickButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSInteger index = [self.buttons indexOfObject:sender];
        
        void(^clickHandle)(void) = self.blocks[index];
        
        clickHandle();
        
    }];
    

    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [XFPublishVCTransation transitionWithtype:SheetPresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [XFPublishVCTransation transitionWithtype:GiftDismiss];
    
}

- (void)clickCancelButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
