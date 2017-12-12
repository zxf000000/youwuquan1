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
#import "XFPreviewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDK/AliyunVideoSDK.h>
#else
#import "AliyunMediator.h"
#import "AliyunMediaConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoCropParam.h"
#endif


@interface XFPublishViewController () <UINavigationControllerDelegate,AliyunVideoBaseDelegate>

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
    
    
    
    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
    
    config.backgroundColor = UIColorHex(707070);
    config.timelineBackgroundCollor = [UIColor yellowColor];
    config.timelineDeleteColor = [UIColor redColor];
    config.timelineTintColor = [UIColor redColor];
    config.durationLabelTextColor = [UIColor redColor];
    config.cutTopLineColor = [UIColor redColor];
    config.cutBottomLineColor = [UIColor redColor];
    config.noneFilterText = @"无滤镜";
    config.hiddenDurationLabel = NO;
    config.hiddenFlashButton = NO;
    config.hiddenBeautyButton = NO;
    config.hiddenCameraButton = NO;
    config.hiddenImportButton = NO;
    config.hiddenDeleteButton = NO;
    config.hiddenFinishButton = NO;
    config.recordOnePart = NO;
    config.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳"];
    config.imageBundleName = @"QPSDK";
    config.filterBundleName = @"FilterResource";
    config.recordType = AliyunVideoRecordTypeCombination;
    config.showCameraButton = YES;
    
    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
    

//    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
//    config.timelineDeleteColor = [UIColor redColor];
//    config.hiddenFlashButton = NO;
//    config.imageBundleName = @"image";
//    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
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
        
        
        switch (button.tag) {
            case 3001:
            {
                // 文字
                [self pushOutAddImgVC];
            }
                break;
            case 3002:
            {
                // 拍摄
                [self pushOutPreviewVC];
            }
                break;
            case 3003:
            {
                // 相册
                [self pushOutAddImgVC];
                
            }
                break;
            case 3004:
            {
                // 小视频
                [self pushOutPreviewVC];
            }
                break;
            default:
                break;
        }
        

    }];
}

- (void)pushOutPreviewVC {
    
    AliyunVideoRecordParam *quVideo = [[AliyunVideoRecordParam alloc] init];
    quVideo.ratio = AliyunVideoVideoRatio3To4;
    quVideo.size = AliyunVideoVideoSize540P;
    quVideo.minDuration = 2;
    quVideo.maxDuration = 30;
    quVideo.position = AliyunCameraPositionFront;
    quVideo.beautifyStatus = YES;
    quVideo.beautifyValue = 100;
    quVideo.torchMode = AliyunCameraTorchModeOff;
    quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record_save.mp4"];
    
    UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:(AliyunVideoRecordParam*)quVideo];
    [AliyunVideoBase shared].delegate = (id)self;
    [self.navigationController pushViewController:recordViewController animated:YES];
    
    //获取到状态栏
    UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
    //设置透明度为0
    statusBar.alpha = 0;
    
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    
    [photoVC.navigationController popViewControllerAnimated:YES];
    
}

- (void)videoBaseRecordVideoExit {

    
    [self dismissViewControllerAnimated:YES completion:^{
        

    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //获取到状态栏
        UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
        //设置透明度为0
        statusBar.alpha = 1;
    }];

    
}

- (void)pushOutAddImgVC {
    
    XFAddImageViewController *addimgVC = [[XFAddImageViewController alloc] init];
    self.navigationController.delegate = addimgVC;
    
    [self.navigationController pushViewController:addimgVC animated:YES];
    
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
    
    self.view.userInteractionEnabled = NO;
    
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
    
    animation.springBounciness = 5;
    
    animation.springSpeed = 20;
    
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        if (self.buttonCount < 3) {
            self.buttonCount += 1;
            
            [self addbutton];
        } else {
            
            self.view.userInteractionEnabled = YES;
            return;
        }
    };
    
    [button pop_addAnimation:animation forKey:@""];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//
//    });
    
    
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
