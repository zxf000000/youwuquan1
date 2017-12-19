//
//  XFVideoDetailViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVideoDetailViewController.h"
//#import <UIView+WebVideoCache.h>
#import "XFVideoNameCell.h"
#import "XFVideoMoreCell.h"
#import "XFStatusDetailViewController.h"
#import "XFStatusCommentCellNode.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>

#import <MDVRLibrary.h>

#import "XFDanmuCell.h"
#import "XFDanmuModel.h"
#import <HJDanmakuView.h>

#import "VideoPlayerViewController.h"

#define kVideoVideHeight (9/16.f * kScreenWidth)

@interface XFVideoDetailViewController () <ASTableDelegate,ASTableDataSource,AliyunVodPlayerDelegate,HJDanmakuViewDateSource,HJDanmakuViewDelegate,MD360DirectorFactory>

@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) UIView *videoView;

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic, assign)BOOL isLock;

@property (nonatomic,strong) AliyunVodPlayerView *playerView;

@property (nonatomic,strong) AliyunVodPlayer *aliPlayer;

@property (nonatomic,strong) UIView *controlView;

@property (nonatomic,strong) UIButton *beginButton;

@property (nonatomic,strong) UILabel *currntTimeLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;

@property (nonatomic,strong) UIButton *fullScreenButton;

@property (nonatomic,strong) UIImageView *dotView;

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UIView *topShadowView;
@property (nonatomic,strong) UIButton *dmButton;

@property (nonatomic,strong) HJDanmakuView *danmuView;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic, strong) MDVRLibrary* vrLibrary;

@property (nonatomic,strong) AVPlayerLayer *playerlayer;

// vr
@property (nonatomic,strong) UIView *vrView;

@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,strong) UIImageView *littleImgView;

@property (nonatomic,strong) UIImageView *leftImgView;
@property (nonatomic,strong) UIImageView *rightImgView;
@property (nonatomic,strong) UIImageView *bgImgView;


@end

@implementation XFVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.type == Hightdefinition) {
        [self setupVideoView];
        [self setupDanmu];

        
    } else {
        
        [self setupVrView];
    }

    [self setupTableNode];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];

    self.count = 10;
    
    [self.view bringSubviewToFront:self.inputView];
    self.inputView.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
}
#pragma mark - 初始化VR占位区域
- (void)setupVrView {
    
    // 设置Vr播放器的占位图
    self.vrView = [[UIView alloc] init];
    self.vrView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16.f);
    [self.view addSubview:self.vrView];
    self.vrView.backgroundColor = [UIColor redColor];
    

    
    self.bgImgView = [[UIImageView alloc] init];
    self.bgImgView.image = [UIImage imageNamed:@"find_pic5"];
    //设置UIVisualEffectView
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    [self.bgImgView addSubview:visualView];
    [self.vrView addSubview:self.bgImgView];
    
    // 选择器
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"全景模式",@"眼镜模式"]];
//    self.segment.backgroundColor = [UIColor whiteColor];
    self.segment.tintColor = [UIColor whiteColor];
    self.segment.selectedSegmentIndex = 0;
    [self.vrView addSubview:self.segment];
    [self.segment addTarget:self action:@selector(clickSegmentControl) forControlEvents:(UIControlEventValueChanged)];
    
    // 缩略图
    self.littleImgView = [[UIImageView alloc] init];
    self.littleImgView.image = [UIImage imageNamed:@"find_pic5"];
    self.littleImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.littleImgView.layer.masksToBounds = YES;
    [self.vrView addSubview:self.littleImgView];
    
    self.leftImgView = [[UIImageView alloc] init];
    self.leftImgView.image = [UIImage imageNamed:@"find_pic5"];
    self.leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImgView.layer.masksToBounds = YES;
    [self.vrView addSubview:self.leftImgView];
    
    self.rightImgView = [[UIImageView alloc] init];
    self.rightImgView.image = [UIImage imageNamed:@"find_pic5"];
    self.rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImgView.layer.masksToBounds = YES;
    [self.vrView addSubview:self.rightImgView];
    
    UIButton *playbutton = [[UIButton alloc ]init];
    [playbutton setImage:[UIImage imageNamed:@"VR_play"] forState:(UIControlStateNormal)];
    [playbutton addTarget:self action:@selector(clickVrPlayer) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vrView addSubview:playbutton];
    

    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    [self.vrView addSubview:self.backButton];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [self.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(25);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.littleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(self.segment);
        make.top.mas_equalTo(self.segment.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self.segment);
        make.bottom.mas_offset(-34);
        
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(24);
        make.top.mas_equalTo(self.segment.mas_bottom).offset(8);
        make.bottom.mas_offset(-34);
        make.right.mas_equalTo(self.rightImgView.mas_left);
        
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.rightImgView.mas_right);
        make.top.mas_equalTo(self.segment.mas_bottom).offset(8);
        make.right.mas_offset(-24);
        make.width.mas_equalTo(self.leftImgView);
        make.bottom.mas_offset(-34);
        
    }];
    
    [playbutton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.height.mas_equalTo(100);
        make.centerX.mas_equalTo(self.littleImgView.mas_centerX);
        make.centerY.mas_equalTo(self.littleImgView.mas_centerY);

    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(20);
        make.left.mas_offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        
    }];
    
    self.leftImgView.hidden = YES;
    self.rightImgView.hidden = YES;

}

- (void)clickSegmentControl {
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        self.littleImgView.hidden = NO;
        self.leftImgView.hidden = YES;
        self.rightImgView.hidden = YES;
        
    } else {
        
        self.littleImgView.hidden = YES;

        self.leftImgView.hidden = NO;
        self.rightImgView.hidden = NO;
    }
    
}

- (void)clickVrPlayer {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayer" bundle:nil];
    PlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    
    [self presentViewController:vc animated:YES completion:^{
        [vc initParams:[NSURL URLWithString:@"http://cdn.hotcast.cn/import/201708161/hd/bijini.mp4"]];
    }];
}


- (void)setupVRView {
    
    
}

#pragma mark - 键盘监听
- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    /*
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 44}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 689}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 645}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 44}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 623}, {375, 44}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     **/
    CGRect frame = [info[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (frame.origin.y == kScreenHeight) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.inputView.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
            self.shadowView.alpha = 0;
            
        }];
        
        
    } else {
        
        [self.view bringSubviewToFront:self.shadowView];
        [self.view bringSubviewToFront:self.inputView];
        CGRect inputFrame = self.inputView.frame;
        inputFrame.origin.y = frame.origin.y - 44 ;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.inputView.frame = inputFrame;
            self.shadowView.alpha = 1;
            
        }];
        
    }
    
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */

    switch (device.orientation) {

        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;

        case UIDeviceOrientationLandscapeLeft:
        {
            NSLog(@"屏幕向左横置");
            [self setLadscapeVideoVideControlViewFrame];
        }
            break;

        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;

        case UIDeviceOrientationPortrait:
        {
            NSLog(@"屏幕直立");
            [self setPortraitVideoPlayerControlViewFrame];

        }
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;

        default:
            NSLog(@"无法辨识");
            break;
    }

}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];

    
}
// 返回按钮
- (void)clickBackButton {

    [self.aliPlayer stop];
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 隐藏展示导航栏
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 播放器按钮相关
// 开始/暂停
- (void)clickBeginButton {
    
    if (self.aliPlayer.playerState == AliyunVodPlayerStatePlay) {
        
        [self.aliPlayer pause];
        [self invalidateTimer];
        self.beginButton.selected = NO;

    } else {
        [self.aliPlayer start];
        [self setupTimer];
        self.beginButton.selected = YES;

    }
    
}

- (void)panDotView:(UIPanGestureRecognizer *)pan {
    
    // 记录progress的位置
    CGFloat beginProgress=0;
    CGFloat endProgress;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            beginProgress = self.progressView.progress;
            [self invalidateTimer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pan translationInView:self.controlView];
            CGFloat x = point.x;
            
            // x的移动转换为时间的移动
            CGFloat progress = x / kScreenWidth;
            
            if (x > 0) {
                
                self.progressView.progress = beginProgress + progress;

            } else {
                
                self.progressView.progress = beginProgress - progress;

            }
            
            
            endProgress = self.progressView.progress;
            
        
        }
            break;
        default:
            [self.aliPlayer seekToTime:self.aliPlayer.duration * self.progressView.progress];
//            [self setupTimer];
            break;
    }
    
    
}

// 全屏
- (void)clickFullButton {
    
    if (self.fullScreenButton.selected) {
        
        [self setPortraitVideoPlayerControlViewFrame];

    } else {
        
        [self setLadscapeVideoVideControlViewFrame];

    }
}

#pragma mark - 设置弹幕
- (void)setupDanmu {
    
    HJDanmakuConfiguration *config = [[HJDanmakuConfiguration alloc] initWithDanmakuMode:(HJDanmakuModeVideo)];
    
    self.danmuView = [[HJDanmakuView alloc] initWithFrame:(CGRectZero) configuration:config];
    
    self.danmuView.delegate = self;
    self.danmuView.dataSource = self;
    
    [self.danmuView registerClass:[XFDanmuCell class] forCellReuseIdentifier:@"danmu"];
    
//    [self.videoView insertSubview:self.danmuView belowSubview:self.controlView];
    
//
//    [self.danmuView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_offset(0);
//
//    }];
    
    
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
    NSArray *danmakus = [NSArray arrayWithContentsOfFile:danmakufile];
    NSMutableArray *danmakuModels = [NSMutableArray arrayWithCapacity:danmakus.count];
    for (NSDictionary *danmaku in danmakus) {
        NSArray *pArray = [danmaku[@"p"] componentsSeparatedByString:@","];
        HJDanmakuType type = [pArray[1] integerValue] % 3;
        XFDanmuModel *danmakuModel = [[XFDanmuModel alloc] initWithType:type];
        danmakuModel.time = [pArray[0] floatValue] / 1000.0f;
        danmakuModel.text = danmaku[@"m"];
        danmakuModel.textFont = [pArray[2] integerValue] == 1 ? [UIFont systemFontOfSize:20]: [UIFont systemFontOfSize:18];
        danmakuModel.textColor = [UIColor redColor];
        [danmakuModels addObject:danmakuModel];
    }
    [self.danmuView prepareDanmakus:danmakuModels];
    
    self.danmuView.hidden = YES;

}

#pragma mark - 点击弹幕按钮
- (void)clickDmButton {
    
    self.dmButton.selected = !self.dmButton.selected;
    
    if (self.dmButton.selected == YES) {
        
        [self.danmuView pause];
        self.danmuView.hidden = YES;
    } else {
        
        [self.danmuView pause];
        self.danmuView.hidden = YES;
    }
    
}

#pragma mark - delegate

- (void)prepareCompletedWithDanmakuView:(HJDanmakuView *)danmakuView {
    
    [self.danmuView play];

}
//
//#pragma mark - dataSource
//
//- (BOOL)bufferingWithDanmakuView:(HJDanmakuView *)danmakuView {
//    return self.bufferBtn.isSelected;
//}
//
//- (float)playTimeWithDanmakuView:(HJDanmakuView *)danmakuView {
//    return self.progressSlider.value * 120.0;
//}


- (CGFloat)danmakuView:(HJDanmakuView *)danmakuView widthForDanmaku:(HJDanmakuModel *)danmaku {
    XFDanmuModel *model = (XFDanmuModel *)danmaku;
    
    return [model.text sizeWithAttributes:@{NSFontAttributeName: model.textFont}].width + 1.0f;
}

- (HJDanmakuCell *)danmakuView:(HJDanmakuView *)danmakuView cellForDanmaku:(HJDanmakuModel *)danmaku {
    XFDanmuModel *model = (XFDanmuModel *)danmaku;
    XFDanmuCell *cell = [danmakuView dequeueReusableCellWithIdentifier:@"danmu"];
    if (model.selfFlag) {
        cell.zIndex = 30;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor redColor].CGColor;
    }
    cell.textLabel.font = model.textFont;
    cell.textLabel.textColor = model.textColor;
    cell.textLabel.text = model.text;
    return cell;
}


#pragma mark - 播放器
- (void)setupVideoView {
    
    #pragma mark - 阿里云播放器
//    //创建播放器对象，AliyunVodPlayerView继承自UIView，可以创建多实例，提供4套皮肤可设置
//    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 9/16.f * kScreenWidth) andSkin:AliyunVodPlayerViewSkinOrange];
//    //    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) andSkin:AliyunVodPlayerViewSkinOrange];
//
//    //设置播放器代理
//    [self.playerView setDelegate:self];
//    //将播放器添加到需要展示的界面上
//    [self.view addSubview:self.playerView];
//    [self.playerView setAutoPlay:YES];
//
//        //旋转锁屏
//    self.playerView.isLockScreen = NO;
//    self.playerView.isLockPortrait = NO;
//    self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
    
    
    
    //创建播放器对象，可以创建多个示例
    self.aliPlayer = [[AliyunVodPlayer alloc] init];
    //设置播放器代理
    self.aliPlayer.delegate = self;
    self.aliPlayer.autoPlay = YES;
    //获取播放器视图
    self.videoView = self.aliPlayer.playerView;
    self.videoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16.f);
    //添加播放器视图到需要展示的界面上
    [self.view addSubview:self.videoView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:kRandomVideo ofType:@"mp4"];

    NSURL *url = [NSURL fileURLWithPath:path];//网络视频，填写网络url地址
    
    [self.aliPlayer prepareWithURL:url];

    // 添加点按事件
    
    UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideoView)];
    [self.videoView addGestureRecognizer:tapVideo];
    
    //设置缓存目录路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [pathArray objectAtIndex:0];
    //在创建播放器类,并在调用prepare方法之前设置。比如：maxSize设置500M时缓存文件超过500M后会优先覆盖最早缓存的文件。maxDuration设置为300秒时表示超过300秒的视频不会启用缓存功能。
    [self.aliPlayer setPlayingCache:YES saveDir:docDir maxSize:500 maxDuration:300];
    
    // 返回按钮
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    [self.videoView addSubview:self.backButton];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [self.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];

    // 播放控制view
    self.controlView = [[UIView alloc] init];
    self.controlView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.videoView addSubview:self.controlView];

    // 开始
    self.beginButton = [[UIButton alloc] init];
    [self.beginButton setImage:[UIImage imageNamed:@"video_begin"] forState:(UIControlStateNormal)];
    [self.beginButton setImage:[UIImage imageNamed:@"video_suspend"] forState:(UIControlStateSelected)];
    [self.controlView addSubview:self.beginButton];
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
    [self.slider setThumbImage:[UIImage imageNamed:@"video_dotwhite"] forState:(UIControlStateNormal)];
    [self.controlView addSubview:self.slider];
    
    [self.slider addTarget:self action:@selector(changeSlider:) forControlEvents:(UIControlEventValueChanged)];
    // 全屏按钮
    self.fullScreenButton = [[UIButton alloc] init];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"video_full"] forState:(UIControlStateNormal)];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"video_noFull"] forState:(UIControlStateSelected)];
    [self.controlView addSubview:self.fullScreenButton];
    
    [self.fullScreenButton addTarget:self action:@selector(clickFullButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 顶部遮罩
    self.topShadowView = [[UIView alloc] init];
    self.topShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.videoView addSubview:self.topShadowView];
    self.topShadowView.frame = CGRectMake(0, 0, kScreenWidth, 43);
    self.topShadowView.hidden = YES;
    
    self.dmButton = [[UIButton alloc] init];
    [self.dmButton setImage:[UIImage imageNamed:@"video_conceal"] forState:(UIControlStateNormal)];
    [self.dmButton setImage:[UIImage imageNamed:@"video_show"] forState:(UIControlStateSelected)];
    [self.topShadowView addSubview:self.dmButton];
    
    [self.dmButton addTarget:self action:@selector(clickDmButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(20);
        make.left.mas_offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        
    }];
    
    if (@available (iOS 11 , * )) {
        
        [self.topShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.mas_offset(0);
            make.height.mas_equalTo(35);
            
        }];
        
    }
    

    [self.dmButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-43);
        make.height.width.mas_equalTo(35);
        make.centerY.mas_offset(0);
        
    }];
    
    if (@available (iOS 11 , *)) {
        
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_offset(0);
            make.height.mas_equalTo(35);
            
        }];

    } else {
        
        self.controlView.frame = CGRectMake(0, kScreenWidth * 9 / 16.f - 35, kScreenWidth, 35);

    }

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
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(43);
        make.width.mas_equalTo(35);

    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-46);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(30);
        
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(3);
        make.right.mas_equalTo(self.totalTimeLabel.mas_left).offset(-5);
        make.left.mas_equalTo(self.currntTimeLabel.mas_right).offset(5);
        make.centerY.mas_offset(0);
        
    }];
    
    
    //    self.videoView = [[UIView alloc] init];
    //    self.videoView.backgroundColor = [UIColor redColor];
    //
    //    self.videoView.frame = CGRectMake(0, 0, kScreenWidth, kVideoVideHeight);
    //
    //    [self.view addSubview:self.videoView];
    //    [self.view insertSubview:self.videoView belowSubview:self.backButton];
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
    //
    //    NSURL *url = [NSURL fileURLWithPath:path];//网络视频，填写网络url地址
    
    //    [self.videoView jp_playVideoWithURL:url];
    //    [self.videoView jp_perfersDownloadProgressViewColor: [UIColor grayColor]];
    //    [self.videoView jp_playerIsMute];
    //
    //    self.videoView.jp_videoPlayerDelegate = self;

}

#pragma mark - videoVide的单击事件
- (void)tapVideoView {
    
    if (self.fullScreenButton.selected) {
        
        CGFloat alpha = 0;
        // 全屏,隐藏两个
        if (self.controlView.alpha == 1) {
            
            alpha = 0;
            
        } else {
            
            alpha = 1;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
           
            self.topShadowView.alpha = self.controlView.alpha = alpha;
            
        }];
        
    } else {
        
        CGFloat alpha = 0;
        // 全屏,隐藏两个
        if (self.controlView.alpha == 1) {
            
            alpha = 0;
            
        } else {
            
            alpha = 1;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.controlView.alpha = alpha;
            
        }];
        
    }
    
}

#pragma mark - 拖动滑块
- (void)changeSlider:(UISlider *)slider {
    
    [self.aliPlayer seekToTime:slider.value];
    
}


- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            [self setupTimer];
            
            self.totalTimeLabel.text = [self timeStringWithTime:self.aliPlayer.duration];
            self.beginButton.selected = YES;
            
            self.slider.minimumValue = 0;
            self.slider.maximumValue = self.aliPlayer.duration;
            
            
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发

            break;
        case AliyunVodPlayerEventFirstFrame:
            //播放视频首帧显示出来时触发

            break;
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            break;
        case AliyunVodPlayerEventStop:
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            
            break;
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(ALPlayerVideoErrorModel *)errorModel{
    //播放出错时触发，通过errorModel可以查看错误码、错误信息、视频ID、视频地址和requestId。
}

- (void)invalidateTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)timerChange {
    
    //获取播放的当前时间，单位为秒
    NSTimeInterval currentTime = self.aliPlayer.currentTime;
    //获取视频的总时长，单位为秒
    NSTimeInterval duration = self.aliPlayer.duration;
    // 设置当前时间
    self.currntTimeLabel.text = [self timeStringWithTime:currentTime];
    
    self.slider.value = self.aliPlayer.currentTime;
    
    [self.dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(self.progressView.mas_left).offset((kScreenWidth - 160) * self.progressView.progress);
        make.width.height.mas_equalTo(8);
        
    }];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        [self.controlView setNeedsDisplay];
        
    }];
    
}

- (void)setupTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (NSString *)timeStringWithTime:(NSTimeInterval)time {
    
    NSInteger currentSec = (NSInteger)time % 60;
    NSInteger currentMin = (NSInteger)time / 60;
    
    NSString *secString = currentSec <= 9 ? [NSString stringWithFormat:@"0%zd",currentSec]:[NSString stringWithFormat:@"%zd",currentSec];
    NSString *minString = currentMin <= 9 ? [NSString stringWithFormat:@"0%zd",currentMin]:[NSString stringWithFormat:@"%zd",currentMin];
    
    return [NSString stringWithFormat:@"%@:%@",minString,secString];

}

#pragma mark - 设置播放器横屏的元素位置
- (void)setPortraitVideoPlayerControlViewFrame {
    //获取到状态栏
    UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
    //设置透明度为0
    statusBar.alpha = 1;
    
    [self.view addSubview:self.videoView];
    self.fullScreenButton.selected = NO;
    self.backButton.hidden = NO;
    
    // 隐藏顶部
    self.topShadowView.hidden = YES;

    // 先隐藏操作栏
    self.controlView.hidden = YES;
    
    // 变换全屏按钮的位置
    [self.controlView addSubview:self.fullScreenButton];
    
    [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.right.mas_offset(0);
        make.width.mas_equalTo(43);
        
    }];
    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-46);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(30);
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.videoView.transform = CGAffineTransformIdentity;
        self.videoView.frame = CGRectMake(0, 0, kScreenWidth, kVideoVideHeight);

    } completion:^(BOOL finished) {
        
        
        self.topShadowView.hidden = YES;
        self.controlView.hidden = NO;
        
        self.controlView.frame = CGRectMake(0, kScreenWidth * 9 / 16.f - 35, kScreenWidth, 35);
        self.topShadowView.frame = CGRectMake(0, 0, kScreenWidth, 43);
        
        [self.topShadowView layoutIfNeeded];
        
        [self.controlView layoutIfNeeded];
    }];
    
    //    self.controlView.frame = CGRectMake(0, 0, kScreenHeight, 35);
    
    if (@available (iOS 11, *)) {
        
        [self.controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_offset(0);
            make.height.mas_equalTo(35);
            
        }];
    }

    
    // 弹幕库关闭

}

- (void)setLadscapeVideoVideControlViewFrame {
    
    //获取到状态栏
    UIView *statusBar = [[UIApplication sharedApplication]valueForKey:@"statusBar"];
    //设置透明度为0
    statusBar.alpha = 0.0f;
    
    [self.view.window addSubview:self.videoView];
    self.fullScreenButton.selected = YES;
    self.backButton.hidden = YES;

    // 先隐藏操作栏
    self.controlView.hidden = YES;
    
    // 变换全屏按钮的位置
    [self.topShadowView addSubview:self.fullScreenButton];
    
    [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.right.mas_offset(-8);
        make.width.height.mas_equalTo(35);
        
    }];
    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-15);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(40);
        
    }];

    [UIView animateWithDuration:0.3 animations:^{
        
        self.videoView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.videoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    } completion:^(BOOL finished) {
        // 显示顶部操
        
        self.topShadowView.hidden = NO;
        self.controlView.hidden = NO;

        // 弹幕界面
//        self.danmuView.hidden = NO;
//        [self.danmuView play];
        
//        self.controlView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.controlView.frame = CGRectMake(0, kScreenWidth - 35, kScreenHeight, 35);
        self.topShadowView.frame = CGRectMake(0, 0, kScreenHeight, 43);
        [self.topShadowView layoutIfNeeded];

        [self.controlView layoutIfNeeded];
    }];
    
//    self.controlView.frame = CGRectMake(0, 0, kScreenHeight, 35);
    
    if (@available (iOS 11, *)) {
        
        [self.controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.mas_offset(0);
            make.height.mas_equalTo(35);
            
        }];
    }

    
}

#pragma mark - tableNodedelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 3;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 10;
            break;
        default:
            break;
    }
    
    return 1;
    
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return ^ASCellNode *() {
                
                XFVideoNameCell *cell = [[XFVideoNameCell alloc] init];
                
                return cell;
                
            };
        }
            break;
        case 1:
        {
            return ^ASCellNode *() {
                
                XFVideoMoreCell *cell = [[XFVideoMoreCell alloc] init];
                
                return cell;
                
            };
            
        }
            break;
        case 2:
            
            switch (indexPath.row) {
                case 0:
                    {
                        return ^ASCellNode *() {
                            
                            XFStatusCenterNode *cell = [[XFStatusCenterNode alloc] init];
                            
                            return cell;
                            
                        };
                        
                        
                    }
                    break;
                case 9:
                {
                    
                    if (!self.isOpen) {
                        
                        return ^ASCellNode *{
                            
                            XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                            
                            // 加载更多评论
                            node.clickMoreButtonBlock = ^{
                                
                                self.count = 20;
                                self.isOpen = YES;
                                [self.tableNode reloadData];
                                
                                
                            };
                            
                            return node;
                            
                            
                        };
                        
                    } else {
                        
                        return ^ASCellNode *{
                            
                            XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:nil];
                            
                            return node;
                            
                        };
                    }


                }
                default:
                {
                    
                    return ^ASCellNode *() {
                        
                        XFStatusCommentCellNode *cell = [[XFStatusCommentCellNode alloc] initWithMode:nil];
                        
                        return cell;
                        
                    };

                }
                    break;
            }
    }
            
            return ^ASCellNode *() {
                
                XFVideoNameCell *cell = [[XFVideoNameCell alloc] init];
                
                return cell;
                
            };

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = UIColorHex(f4f4f4);
    
    return view;
    
}

- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:(UITableViewStyleGrouped)];
    self.tableNode.backgroundColor = [UIColor whiteColor];
    self.tableNode.delegate = self;
    
    self.tableNode.dataSource = self;
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubnode:self.tableNode];
    self.tableNode.frame = CGRectMake(0, kScreenWidth * 9 / 16.f, kScreenWidth, kScreenHeight - kScreenWidth * 9 / 16.f - 44);
    
    
    
}


@end
