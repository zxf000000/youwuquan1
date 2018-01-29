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
    // Do any additional setup after loading the view.
    self.blocks = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
//    [self setupPayView];
}

- (void)addButtonWithImage:(UIImage *)image title:(NSString *)title handle:(void(^)(void))clickHandle {
    
    UIButton *button = [[UIButton alloc] init];
    if (image) [button setImage:image forState:(UIControlStateNormal)];
    [button setTitle:[NSString stringWithFormat:@"%@",title] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(e0e0e0)] forState:(UIControlStateHighlighted)];
    [self.view addSubview:button];
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


//
//- (void)setupPayView {
//
//    self.payView = [[UIView alloc] init];
//    self.payView.frame = CGRectMake(0, kScreenHeight - 150, kScreenWidth, 150);
//    [self.view addSubview:self.payView];
//
//    self.payView.backgroundColor = [UIColor whiteColor];
//
//    self.wxButton = [[UIButton alloc] init];
//    [self.wxButton setTitle:@"微信支付" forState:(UIControlStateNormal)];
//    [self.wxButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    [self.payView addSubview:self.wxButton];
//
//    self.aliPaybutton = [[UIButton alloc] init];
//    [self.aliPaybutton setTitle:@"支付宝" forState:(UIControlStateNormal)];
//    [self.aliPaybutton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//
//    [self.payView addSubview:self.aliPaybutton];
//
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = UIColorHex(f4f4f4);
//    [self.payView addSubview:line];
//
//    self.wxButton.frame = CGRectMake(0, 0, kScreenWidth, 50);
//    self.aliPaybutton.frame = CGRectMake(0, 50, kScreenWidth, 50);
//    line.frame = CGRectMake(0, 49.5, kScreenWidth, 1);
//
//    _cancelButton = [[UIButton alloc] init];
//    [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
//    [self.payView addSubview:_cancelButton];
//    [_cancelButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    _cancelButton.frame = CGRectMake(0, 100, kScreenWidth, 50);
//
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = UIColorHex(f4f4f4);
//    [self.payView addSubview:line1];
//    line1.frame = CGRectMake(0, 99.5, kScreenWidth, 1);
//
//    [self.wxButton addTarget:self action:@selector(clickWxButton) forControlEvents:(UIControlEventTouchUpInside)];
//
//    [self.aliPaybutton addTarget:self action:@selector(clickAliButton) forControlEvents:(UIControlEventTouchUpInside)];
//
//    [self.cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
//
//}

- (void)clickCancelButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
