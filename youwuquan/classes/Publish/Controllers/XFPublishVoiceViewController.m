//
//  XFPublishVoiceViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/19.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPublishVoiceViewController.h"
#import "XFPublishTransation.h"
#import "XFLabelCollectionViewCell.h"
#import "XFHistoryViewRowsCaculator.h"
#import "XFPublishAddImageViewCollectionViewCell.h"
#import "XFImagePickerViewController.h"
#import "XFSelectLabelViewController.h"
#import "XFStatusNetworkManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XFFindNetworkManager.h"

#import "PLShortVideoKit/PLShortVideoKit.h"
#import "CustomeImagePicker.h"
#import "XFFindNetworkManager.h"
#import <QiniuSDK.h>


#define kImgInset 12
#define kImgPadding 2
#define kItemWidth (kScreenWidth - 20 - 6)/3
#define KImgBottom 15

@interface XFPublishVoiceViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,XFSelectTagVCDelegate>

@property (nonatomic,strong) UIButton *publishButton;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UICollectionView *centerView;

@property (nonatomic,strong) UILabel *placeHolderLabel;


@property (nonatomic,assign) CGFloat topHeight;

@property (nonatomic,assign) CGFloat centerHeight;


@property (nonatomic,copy) NSArray *titleArr;

@property (nonatomic,strong) NSMutableArray *labelsArr;

@property (nonatomic,strong) UIView *voiceView;
@property (nonatomic,strong) UIButton *voiceButton;
@property (nonatomic,strong) UIImageView *voiceImg;
@property (nonatomic,strong) UILabel *voiceTimeLabel;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

// 上传进度
@property (nonatomic,strong) MBProgressHUD *uploadProgressHUD;

@end


@implementation XFPublishVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorHex(e0e0e0);
    self.title = @"发布";
    
    [self setupnavigationButton];
    [self setupOtherView];
    
    [self setupVoiceView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.audioPlayer stop];
    
}

- (void)clickPublishButton {
    
    NSString *labels = @"";
    
    if (self.labelsArr.count > 1) {
        
        for (NSInteger i = 0 ; i < self.labelsArr.count - 1; i ++) {
            
            if (i == 0) {
                
                labels = [labels stringByAppendingString:self.labelsArr[i]];
                
            } else {
                labels = [labels stringByAppendingString:[NSString stringWithFormat:@",%@",self.labelsArr[i]]];
                
            }
        }
        
    } else {
        
        labels = nil;
        
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.progress = 0;
    
    // 获取token
    [XFFindNetworkManager getUploadTokenWithsuccessBlock:^(id responseObj) {
        
        NSDictionary *dic = (NSDictionary *)responseObj;
        
        NSString *token = dic[@"token"];
        
        NSLog(@"%@--token",token);
        
        NSLog(@"%f-----",[[NSDate date] timeIntervalSince1970]);
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
        NSString *uid = [XFUserInfoManager sharedManager].userName;
        NSString *dateStr = [formatter stringFromDate:date];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *data = [NSData dataWithContentsOfFile:_recordingFilePath];
        [upManager putData:data key:[NSString stringWithFormat:@"%@%@.mp3",dateStr,uid] token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            if (info.error) {
                
                [XFToolManager changeHUD:HUD successWithText:@"上传失败"];
                
                return;
            }
            
            [XFFindNetworkManager publishVoiceWithType:@"audio" title:@"asda" labels:labels text:self.textView.text audioPath:[NSString stringWithFormat:@"%@%@",kQiniuResourceHost,resp[@"key"]] audioSecond:self.totalSeconds successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } failBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];

            } progress:^(CGFloat progress) {
                
            }];

        } option:nil];
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
    } progress:^(CGFloat progress) {
        
    }];
    

}

- (void)setupOtherView {
    
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    // kvo监听
    [self.textView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    
    // 设置占位符
    self.textView.delegate = self;
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 21)];
    self.placeHolderLabel.text = @"分享这一刻...";
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    
    self.placeHolderLabel.textColor = UIColorHex(808080);
    self.placeHolderLabel.enabled = NO;
    [self.textView addSubview:self.placeHolderLabel];
    
    // 标签View
    //    UICollectionViewFlowLayout *
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 5;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 5;
    // 3.设置item块的大小 (可以用于自适应)
    layout.estimatedItemSize = CGSizeMake(20, 60);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.centerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.delegate = self;
    self.centerView.dataSource = self;
    [self.centerView registerClass:[XFLabelCollectionViewCell class] forCellWithReuseIdentifier:@"history"];
    [self.view addSubview:self.centerView];
    
}



#pragma mark - 标签选择器代理
- (void)selecteTagVC:(XFSelectLabelViewController *)selecteVC didSelectedTagsWith:(NSArray *)tags {
    
    self.labelsArr = [NSMutableArray arrayWithArray:tags];
    
    [self.labelsArr addObject:@""];
    
    [self.centerView reloadData];
    
    [self.centerView layoutIfNeeded];
    
    [self setScrollContent];
    
}

#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    XFSelectLabelViewController *selectLabelVC = [[XFSelectLabelViewController alloc] init];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.labelsArr];
    
    [arr removeLastObject];
    
    selectLabelVC.labelsArr = arr;
    
    selectLabelVC.delegate = self;
    
    [self.navigationController pushViewController:selectLabelVC animated:YES];
    
    return;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.labelsArr.count > 1) {
        
        return self.labelsArr.count;
        
    } else {
        
        return self.titleArr.count;
        
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XFLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    if (self.labelsArr.count > 1) {
        // 赋值
        cell.tagStr = self.labelsArr[indexPath.item];
        cell.textLabel.textColor = kMainRedColor;
        cell.deleteButton.hidden = NO;
        if (indexPath.item == self.labelsArr.count - 1) {
            cell.deleteButton.hidden = YES;
        }
        
    } else {
        // 赋值
        cell.tagStr = self.titleArr[indexPath.item];
        cell.textLabel.textColor = UIColorHex(808080);
        cell.deleteButton.hidden = YES;
        
    }
    
    cell.clickDeleteButtonForIndex = ^(NSIndexPath *indexpath) {
        
        // 删除相应的标
        [self.labelsArr removeObjectAtIndex:indexpath.item];
        
        [self.centerView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
        // 计算高度
        // 计算标签栏高度
        
        [self setScrollContent];
        
    };
    
    return cell;
    
    
    
    return nil;
}


- (void)setScrollContent {
    
    self.centerHeight = self.centerView.collectionViewLayout.collectionViewContentSize.height;
    
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.height.mas_equalTo(self.labelsArr.count > 1 ? self.centerHeight : 30);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    
}

- (void)updateViewConstraints {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.height.mas_equalTo(175);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    // 计算标签栏高度
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.height.mas_equalTo(self.centerHeight > 30 ? self.centerView.collectionViewLayout.collectionViewContentSize.height : 30);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.centerView.mas_bottom).offset(20);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(100);
        
    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(20);
        make.top.mas_offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(54);
        
    }];
    
    [self.voiceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.voiceButton.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.voiceButton.mas_centerY).offset(-5);
        
    }];
    
    self.topHeight = 175;
    
    [super updateViewConstraints];
}

#pragma mark - 监听textView
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        
        self.publishButton.enabled = YES;
        
    } else {
        
        self.publishButton.enabled = NO;
        
        
    }
    
}

#pragma mark - 占位符相关
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeHolderLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.placeHolderLabel.alpha = 1;
    }
    return YES;
}

#pragma mark - 语音View

- (void)clickVoiceButton {
    
    if (_audioPlayer == nil)
    {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_recordingFilePath] error:nil];
        _audioPlayer.meteringEnabled = YES;
    }
    
    if (_audioPlayer.isPlaying) {
        
        [_audioPlayer pause];
        
    } else {
        
        
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
    
    
}

- (void)setupVoiceView {
    
    self.voiceView = [[UIView alloc] init];
    //    self.voiceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.voiceView];
    
    self.voiceButton = [[UIButton alloc] init];
    [self.voiceButton setImage:[UIImage imageNamed:@"voice_bg"] forState:(UIControlStateNormal)];
    [self.voiceView addSubview:self.voiceButton];
    
    self.voiceTimeLabel = [[UILabel alloc] init];
    self.voiceTimeLabel.textColor = [UIColor whiteColor];
    self.voiceTimeLabel.font = [UIFont systemFontOfSize:8];
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%zd\"",self.totalSeconds];
    [self.voiceView addSubview:self.voiceTimeLabel];
    
    
    [self.voiceButton addTarget:self action:@selector(clickVoiceButton) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setupnavigationButton {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 21))];;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton setTitle:@"取消" forState:(UIControlStateNormal)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    _publishButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 40, 21))];;
    [_publishButton setTitle:@"发布" forState:(UIControlStateNormal)];
    [_publishButton setTitleColor:UIColorHex(808080) forState:(UIControlStateDisabled)];
    [_publishButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_publishButton];
    _publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _publishButton.enabled = NO;
    [_publishButton addTarget:self action:@selector(clickPublishButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    
    if (operation == UINavigationControllerOperationPush) {
        
        [XFPublishTransation transitionWithtype:Push];
    }
    
    if (operation == UINavigationControllerOperationPop) {
        
        
    }
    
    return nil;
    
}



- (NSArray *)titleArr {
    
    if (_titleArr == nil) {
        
        _titleArr = @[@"添加/编辑标签",@""];
    }
    return _titleArr;
}

- (NSMutableArray *)labelsArr {
    
    if (_labelsArr == nil) {
        
        _labelsArr = [NSMutableArray array];
    }
    return _labelsArr;
}

- (void)clickBackButton {
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
