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
#import <Photos/Photos.h>
#import "XFShortVideoViewController.h"
#import "IQAudioRecorderViewController.h"
#import "XFPublishPicViewController.h"
//#if SDK_VERSION == SDK_VERSION_BASE
//#import <AliyunVideoSDK/AliyunVideoSDK.h>
//#else
//#import "AliyunMediator.h"
//#import "AliyunMediaConfig.h"
//#import "AliyunVideoBase.h"
//#import "AliyunVideoUIConfig.h"
//#import "AliyunVideoCropParam.h"
//#endif


@interface XFPublishViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,weak) UIButton *cancelButton;

@property (nonatomic,strong) NSMutableArray *buttons;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) NSArray *imgs;

@property (nonatomic,assign) NSInteger buttonCount;

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (nonatomic,strong) UIView *viewContainer;

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
        
        
        switch (button.tag) {
            case 3001:
            {
                // 文字
                [self pushOutAddImgVC];
            }
                break;
            case 3002:
            {
                [self pushVoiceVC];
            }
                break;
            case 3003:
            {
                // 相册
                [self pushOutPreviewVC];

            }
                break;
            case 3004:
            {
                // 小视频
//                [self pushOutPreviewVC];
                [self pushOutAddImgVC];

            }
                break;
            default:
                break;
        }
        

    }];
}

- (void)pushVoiceVC {
    
//    XFRecordVoiceViewController *voiceVC = [[XFRecordVoiceViewController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:voiceVC];
//    [self.navigationController pushViewController:voiceVC animated:YES];
    
    IQAudioRecorderViewController *audioVC = [[IQAudioRecorderViewController alloc] init];

    [self.navigationController pushViewController:audioVC animated:YES];
}

- (void)pushOutPreviewVC {
    
    // 请求用户授权
    
    switch (PHPhotoLibrary.authorizationStatus) {
           /*
            PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
            PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
            // The user cannot change this application’s status, possibly due to active restrictions
            //   such as parental controls being in place.
            PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
            PHAuthorizationStatusAuthorized
            */
            
        case PHAuthorizationStatusNotDetermined:
        {
            // 请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == AVQueuedSampleBufferRenderingStatusRendering) {
                    
                    // 成功
                } else {
                    
//                    UIAlertController *alert = [UIAlertController xfalertControllerWithMsg:@"请进入 设置 -> 隐私 -> 相册 开启相册使用权限" doneBlock:^{
//
//
//                        return;
//                    }];
//
//                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            
        }
            break;
        case PHAuthorizationStatusDenied:
        {
            UIAlertController *alert = [UIAlertController xfalertControllerWithMsg:@"请进入 设置 -> 隐私 -> 相册 开启相册使用权限" doneBlock:^{
               
                
                return;
            }];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            // 可以使用
        }
            break;
            
            
    }
    

    XFShortVideoViewController *recordViewController = [[XFShortVideoViewController alloc] init];;
   
    [self.navigationController pushViewController:recordViewController animated:YES];

//    //获取到状态栏
//    UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
//    //设置透明度为0
//    statusBar.alpha = 0;
    
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    
    [photoVC.navigationController popViewControllerAnimated:YES];
    
}

- (void)videoBaseRecordVideoExit {

    
    [self dismissViewControllerAnimated:YES completion:^{
        

    }];
    
    [self showStatusbar];

    
}

- (void)showStatusbar {
    
    [UIView animateWithDuration:0.2 animations:^{
        //获取到状态栏
        UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
        //设置透明度为0
        statusBar.alpha = 1;
    }];
}


//- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
//
//
//    // 保存到相册
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//
//    [library performChanges:^{
//        // 根据路径创建一个资源-- 直接保存到相册
//        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:videoPath]];
//
//
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//
//        // 保存到相册失败
//    }];
//
//    // 截图
//    XFAddImageViewController *addImgVC = [[XFAddImageViewController alloc] init];
//    addImgVC.videoImage = [XFToolManager getImage:videoPath];
//    addImgVC.videoPath = videoPath;
//    addImgVC.type = XFAddImgVCTypeVideo;
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"视频是否加密" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"私密" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//        addImgVC.isOpenVideo = NO;
//        [self.navigationController pushViewController:addImgVC animated:YES];
//
//        [self showStatusbar];
//    }];
//
//    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"公开" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//
//        addImgVC.isOpenVideo = YES;
//
//        [self.navigationController pushViewController:addImgVC animated:YES];
//
//        [self showStatusbar];
//
//    }];
//
//    // 跳转到发布
//
//    [alertController addAction:actionYES];
//    [alertController addAction:actionNo];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//
//
//
//}

- (void)pushOutAddImgVC {
    
    XFPublishPicViewController *publichPicVC = [[XFPublishPicViewController alloc] init];
    self.navigationController.delegate = publichPicVC;
    [self.navigationController pushViewController:publichPicVC animated:YES];

    
//    XFAddImageViewController *addimgVC = [[XFAddImageViewController alloc] init];
//    self.navigationController.delegate = addimgVC;
//
//    [self.navigationController pushViewController:addimgVC animated:YES];
    
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

    if (self.buttonCount == 0) {
        

        self.buttonCount = 0;
        
        [self addbutton];
        
 
    } else {
        
        for (UIButton *button in self.buttons) {
            
            CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
            button.transform = scale;
            button.alpha = 1;
        }

    }

}


- (void)removeButton {
    
    NSInteger i = self.buttonCount;
    
    CGFloat padding = (kScreenWidth - 3* 60)/4.f;
    
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
    CGFloat padding = (kScreenWidth - 3* 60)/4.f;
    
    CGFloat height = 100;
    CGFloat width = 60;
    UIButton *button = [[UIButton alloc] init];
    button.enabled = NO;
    [self.view addSubview:button];
    button.frame = CGRectMake(padding + (width + padding) * i, kScreenHeight, width, height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgs[i]]];
    imageView.frame = CGRectMake(0, 0, width, width);
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.titles[i];
    label.frame = CGRectMake(0, 85, 60, 25);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = kRGBColorWith(172, 172, 172);
    [button addSubview:label];
    
    button.tag = 3001 + i;
    
    [self.buttons addObject:button];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    animation.toValue = [NSValue valueWithCGRect:(CGRectMake(padding + (width + padding) * i, (kScreenHeight - height - bottom), width, height))];
    
    animation.springBounciness = 5;
    
    animation.springSpeed = 20;
    
    if (self.buttonCount == 2) {
    
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            
            [self setupPreview];

        };

    }

    
    [button pop_addAnimation:animation forKey:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.07 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.buttonCount < 2) {
            
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
    
//    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pub_beijing"]];
//    bgView.frame = self.view.frame;
//    [self.view addSubview:bgView];
//
//    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mengceng"]];
//    shadowView.frame = self.view.bounds;
//    [self.view addSubview:shadowView];
    
    UIButton *cancelButtn = [[UIButton alloc] init];
    [cancelButtn setImage:[UIImage imageNamed:@"publish_back"] forState:(UIControlStateNormal)];
    cancelButtn.frame = CGRectMake((kScreenWidth - 30)/2, (kScreenHeight - 40), 30, 30);
    [self.view addSubview:cancelButtn];
    
    [cancelButtn addTarget:self action:@selector(clickCancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.cancelButton = cancelButtn;
    
}


- (void)setupPreview {
    
    self.viewContainer = [[UIView alloc] initWithFrame:(CGRectMake(0, 64, kScreenWidth, 220 * kScreenWidth / 375.f))];
    [self.view addSubview:self.viewContainer];
    
    
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_preview"]];
    [self.viewContainer addSubview:imgView];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"尤物圈双摄像机";
    label.font = [UIFont systemFontOfSize:13];
    [self.viewContainer addSubview:label];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(-20);
        make.width.height.mas_equalTo(40);
        make.centerX.mas_offset(0);
        
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.centerY.mas_equalTo(imgView.mas_bottom).offset(25);
        
    }];
    [self.captureSession startRunning];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPreviewView)];
    [self.viewContainer addGestureRecognizer:tap];
}

- (void)tapPreviewView {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    [self presentViewController:picker animated:YES completion:nil];

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (UIButton *button in self.buttons) {
        
        button.enabled = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}


-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}




- (NSArray *)titles {
    
    if (_titles == nil) {
        _titles =@[@"动态",@"语音",@"视频"];
    }
    return _titles;
}

- (NSArray *)imgs {
    
    
    if (_imgs == nil) {
        
        _imgs = @[@"publish_words",@"publish_voice",@"publish_photograph"];
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
