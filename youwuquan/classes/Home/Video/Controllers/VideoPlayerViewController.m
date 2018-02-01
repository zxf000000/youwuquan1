//
//  VideoPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MDVRLibrary.h"

@interface CustomDirectorFactory : NSObject<MD360DirectorFactory>
@end

@implementation CustomDirectorFactory

- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    return director;
}

@end

@interface VideoPlayerViewController ()<VIMVideoPlayerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) VIMVideoPlayer *player;
@property (nonatomic, strong) AVPlayer* avplayer;




@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *beginButton;
@property (nonatomic,strong) UIButton *vrbutton;
//@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIView *controlView;
@property (nonatomic,strong) UILabel *currntTimeLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIView *topShadowView;

@property (nonatomic,assign) BOOL sliderCanMove;

@property (nonatomic,strong) MBProgressHUD *loadingProgressHUD;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.videoBack.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [self setupUIs];
    
    //获取到状态栏
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    //设置透明度为0
    statusBar.alpha = 0;
    
    UIGestureRecognizer *videoGes;
    UIGestureRecognizer *slideGes;
    
    for (UIGestureRecognizer *ges in self.videoBack.gestureRecognizers) {
        
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            
            videoGes = ges;
        }
        
    }
    
    for (UIGestureRecognizer *ges in self.slider.gestureRecognizers) {
        
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            
            slideGes = ges;
        }
        
    }
    
    [slideGes requireGestureRecognizerToFail:videoGes];
    
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    
    [self.videoBack addGestureRecognizer:tapBg];
}

#pragma mark - 显示/隐藏控制面板
- (void)tapBgView {
    
    if (self.topShadowView.alpha == 1) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.topShadowView.alpha = 0;
            self.controlView.alpha = 0;

        }];
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.topShadowView.alpha = 1;
            self.controlView.alpha = 1;
            
        }];
        
    }
    
    
}

#pragma mark - 播放器控制相关
- (void)clickBeginButton {
    
    self.beginButton.selected = !self.beginButton.selected;
    
    if (self.beginButton.selected) {
        
        [self.player play];
        
    } else {
        
        [self.player pause];

    }
    
}

// 进度条
- (void)sliderBegin {
    
    self.sliderCanMove = NO;

}

- (void)changeSlider:(UISlider *)slider {
    
    self.sliderCanMove = YES;

    [self.player seekToTime:slider.value];
}
// 返回
- (void)clickBackButton {
    
    [self.player pause];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //获取到状态栏
        UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
        //设置透明度为0
        statusBar.alpha = 1;
    }];
    
}

// 切换模式
- (void)clickVrButton {
    
    self.vrbutton.selected = !self.vrbutton.selected;
    
    if (self.vrbutton.selected) {
        
        [self.vrLibrary switchDisplayMode:MDModeDisplayGlass];
        
    } else {
        
        [self.vrLibrary switchDisplayMode:MDModeDisplayNormal];

        
    }
    
}


#pragma mark - playerDelegate
- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer {
    
    [self.loadingProgressHUD hideAnimated:YES];
    
    CMTime time = videoPlayer.player.currentItem.duration;
    Float64 seconds = CMTimeGetSeconds(time);
    self.totalTimeLabel.text = [XFToolManager timeStringWithTime:seconds];
    self.slider.maximumValue = (float)seconds;
    
}
- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer {
    
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime {
    Float64 seconds = CMTimeGetSeconds(cmTime);

    self.currntTimeLabel.text = [XFToolManager timeStringWithTime:seconds];
    
    if (self.sliderCanMove) {
        
        self.slider.value = (float)seconds;

    }
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration {
    
    
}
- (void)videoPlayerPlaybackBufferEmpty:(VIMVideoPlayer *)videoPlayer {
    
    [self.loadingProgressHUD hideAnimated:YES];

}
- (void)videoPlayerPlaybackLikelyToKeepUp:(VIMVideoPlayer *)videoPlayer {
    
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer didFailWithError:(NSError *)error {
    [self.loadingProgressHUD hideAnimated:YES];

    
}

- (void)setupUIs {
    
    // 播放控制view
    self.controlView = [[UIView alloc] init];
    self.controlView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:self.controlView];
    
    // 开始
    self.beginButton = [[UIButton alloc] init];
    [self.beginButton setImage:[UIImage imageNamed:@"video_begin"] forState:(UIControlStateNormal)];
    [self.beginButton setImage:[UIImage imageNamed:@"video_suspend"] forState:(UIControlStateSelected)];
    [self.controlView addSubview:self.beginButton];
    self.beginButton.selected = YES;
    [self.beginButton addTarget:self action:@selector(clickBeginButton) forControlEvents:(UIControlEventTouchUpInside)];
    // 时间label
    self.currntTimeLabel = [[UILabel alloc] init];
    [self.currntTimeLabel setFont:[UIFont systemFontOfSize:10] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentCenter)];
    [self.controlView addSubview:self.currntTimeLabel];
    self.currntTimeLabel.text  =@"00:00";
    
    self.totalTimeLabel = [[UILabel alloc] init];
    [self.totalTimeLabel setFont:[UIFont systemFontOfSize:10] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentCenter)];
    [self.controlView addSubview:self.totalTimeLabel];
    self.totalTimeLabel.text  =@"00:00";
    
    // 进度条
    
    self.slider = [[UISlider alloc] init];
//    [self.slider setThumbImage:[UIImage imageNamed:@"video_dotwhite"] forState:(UIControlStateNormal)];
    [self.controlView addSubview:self.slider];
    self.sliderCanMove = YES;
    [self.slider addTarget:self action:@selector(changeSlider:) forControlEvents:(UIControlEventValueChanged)];
    [self.slider addTarget:self action:@selector(sliderBegin) forControlEvents:(UIControlEventPrimaryActionTriggered)];
    
    // 设置frame
    //    [self.controlView addSubview:self.videoView.jp_indicatorView];
    
    
    // 顶部遮罩
    self.topShadowView = [[UIView alloc] init];
    self.topShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.videoBack addSubview:self.topShadowView];
    
    
    // 返回按钮
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    [self.topShadowView addSubview:self.backButton];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [self.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 全屏按钮
    self.vrbutton = [[UIButton alloc] init];
    [self.vrbutton setImage:[UIImage imageNamed:@"video_vr"] forState:(UIControlStateNormal)];
    [self.vrbutton setImage:[UIImage imageNamed:@"video_vrs"] forState:(UIControlStateSelected)];
    [self.topShadowView addSubview:self.vrbutton];
    
    [self.vrbutton addTarget:self action:@selector(clickVrButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.topShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.vrbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.right.mas_offset(0);
        make.width.height.mas_equalTo(43);
        
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
        
    }];
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-46);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(30);
        
    }];
    
    [self.beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(35);
        
    }];
    
    [self.currntTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.beginButton.mas_right).offset(10);
        //        make.width.mas_equalTo(30);
        make.centerY.mas_offset(0);
        
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.height.mas_equalTo(3);
        make.right.mas_equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.left.mas_equalTo(self.currntTimeLabel.mas_right).offset(5);
        make.centerY.mas_offset(0);
        
    }];
    
}

//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (void) onClosed{
    [self.player reset];
}

- (void) initPlayer{
    // video player
    
    
    self.player = [[VIMVideoPlayer alloc] init];

    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
    [self.player setPlayerItem:playerItem];
    self.player.delegate = self;
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.videoBack];
    
    // optional
    [config projectionMode:MDModeProjectionSphere];
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    [config pinchEnabled:true];
    [config setDirectorFactory:[[CustomDirectorFactory alloc]init]];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    [self.player play];
    
    self.loadingProgressHUD = [XFToolManager showProgressHUDtoView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
