//
//  XFPublishViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPublishViewController.h"
#import "XFAddImageViewController.h"
#import "XFPublishVCTransation.h"

@interface XFPublishViewController () <UINavigationControllerDelegate>

@property (nonatomic,weak) UIButton *cancelButton;

@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) NSArray *imgs;

@property (nonatomic,assign) NSInteger buttonCount;


@end

@implementation XFPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    
    if (operation == UINavigationControllerOperationPush) {
        
        [XFPublishVCTransation transitionWithtype:Push];
    }
    
    if (operation == UINavigationControllerOperationPop) {
        
        
    }
    
    return nil;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)clickButton:(UIButton *)button {

    [UIView animateWithDuration:0.3 animations:^{
       
        CGAffineTransform scale = CGAffineTransformMakeScale(3, 3);
        button.transform = scale;
        button.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        XFAddImageViewController *addimgVC = [[XFAddImageViewController alloc] init];
        self.navigationController.delegate = addimgVC;
        
        [self.navigationController pushViewController:addimgVC animated:YES];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(M_PI-0.1);
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.cancelButton.layer addAnimation:animation forKey:@""];

    self.buttonCount = 0;
    
    [self addbutton];

}

- (void)removeButton {
    
    NSInteger i = self.buttonCount;
    
    CGFloat padding = (kScreenWidth - 4* 60)/5.f;
    
    CGFloat height = 85;
    CGFloat width = 60;
    
    UIButton *button = self.buttons[i];

    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(padding + (width + padding) * i, kScreenHeight, width, height))];
    
    [button pop_addAnimation:animation forKey:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.buttonCount > 0) {
            self.buttonCount -= 1;
            
            [self removeButton];
        } else {
            
            return;
        }
        
        
        
    });
    
}

- (void)addbutton {
    
    NSInteger i = self.buttonCount;
    
    CGFloat bottom = 180* kScreenHeight/667.f;
    CGFloat padding = (kScreenWidth - 4* 60)/5.f;
    
    CGFloat height = 85;
    CGFloat width = 60;
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    button.frame = CGRectMake(padding + (width + padding) * i, kScreenHeight, width, height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgs[i]]];
    imageView.frame = CGRectMake(0, 0, width, width);
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.titles[i];
    label.frame = CGRectMake(0, 65, 60, 25);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [button addSubview:label];
    
    label.textColor = [UIColor blackColor];
    
    button.tag = 3001 + i;
    
    [self.buttons addObject:button];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(padding + (width + padding) * i, (kScreenHeight - height - bottom), width, height))];
    
    animation.springBounciness = 13;
    
    [button pop_addAnimation:animation forKey:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.buttonCount < 3) {
            self.buttonCount += 1;
            
            [self addbutton];
        } else {
            
            return;
        }
        
    });
    
    
}

- (void)clickCancelButton:(UIButton *)sender {
    
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(M_PI_2*2/3.f);
    animation.duration = 0.3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [self.cancelButton.layer addAnimation:animation forKey:@""];
    
    [self removeButton];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];

    });
    
    
    
}

- (void)setupViews {
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_beijing"]];
    bgView.frame = self.view.frame;
    [self.view addSubview:bgView];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mengceng"]];
    shadowView.frame = self.view.bounds;
    [self.view addSubview:shadowView];
    
    UIButton *cancelButtn = [[UIButton alloc] init];
    [cancelButtn setImage:[UIImage imageNamed:@"publish_back"] forState:(UIControlStateNormal)];
    cancelButtn.frame = CGRectMake((kScreenWidth - 30)/2, (kScreenHeight - 40), 30, 30);
    [self.view addSubview:cancelButtn];
    
    [cancelButtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.cancelButton = cancelButtn;
    
}




- (NSArray *)titles {
    
    if (_titles == nil) {
        _titles =@[@"文字",@"拍摄",@"相册",@"小视频"];
    }
    return _titles;
}

- (NSArray *)imgs {
    
    
    if (_imgs == nil) {
        
        _imgs = @[@"publish_words",@"publish_photograph",@"publish_photo",@"publish_video"];
    }
    return _imgs;
    
}

- (NSMutableArray *)buttons {
    
    if (_buttons == nil) {
        
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
