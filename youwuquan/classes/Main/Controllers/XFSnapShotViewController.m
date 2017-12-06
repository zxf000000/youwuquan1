//
//  XFSnapShotViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFSnapShotViewController.h"
#import "XFCreatShareImgManager.h"
#import <AliyunVodPlayerViewSDK/AliyunVodPlayerViewSDK.h>

@interface XFSnapShotViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *bgVIew;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *idLabel;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UIImageView *codeView;

@property (nonatomic,strong) AliyunVodPlayerView *playerView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *fonts;

@end

@implementation XFSnapShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.iconView = [[UIImageView alloc] init];
//
//    self.iconView.frame = CGRectMake(0, 20, kScreenWidth, 550);
//
//    [self.view addSubview:self.iconView];
//
//    self.iconView.image = [XFCreatShareImgManager shareImgWithBgImage:[UIImage imageNamed:@"backgroundimage"] iconImage:[UIImage imageNamed:@"actor_pic4"] name:@"孙胜童鞋" userId:@"ID:2333244" address:@"广东深圳 福田区"];
    
//    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 9/16.f * kScreenWidth) andSkin:AliyunVodPlayerViewSkinOrange];
//    //    self.playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight) andSkin:AliyunVodPlayerViewSkinOrange];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
//
//
//    NSURL *url = [NSURL fileURLWithPath:path];//网络视频，填写网络url地址
//
//    [self.playerView playViewPrepareWithURL:url];
//    //设置播放器代理
//    [self.playerView setDelegate:self];
//    //将播放器添加到需要展示的界面上
//    [self.view addSubview:self.playerView];
//    [self.playerView setAutoPlay:YES];
//
//    //旋转锁屏
//    self.playerView.isLockScreen = NO;
//    self.playerView.isLockPortrait = NO;
//    self.isLock = self.playerView.isLockScreen||self.playerView.isLockPortrait?YES:NO;
    
    self.fonts = [UIFont familyNames];
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fonts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"font"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:self.fonts[indexPath.row] size:20];
    
    cell.textLabel.text = [NSString stringWithFormat:@"自定义字体----%@",self.fonts[indexPath.row]];
    
    return cell;
}




@end
