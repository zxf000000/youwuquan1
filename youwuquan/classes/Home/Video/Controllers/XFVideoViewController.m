//
//  XFVideoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVideoViewController.h"
#import "XFHomeVideoTableViewCell.h"
#import "XFFindDetailViewController.h"
#import "XFHomeDataModel.h"


@interface XFVideoViewController () <UITableViewDelegate,UITableViewDataSource,XFHomeVideoCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UITableView *VRView;


@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *headerPicView;

@property (nonatomic,strong) UIButton *gqButton;

@property (nonatomic,strong) UIButton *vrButton;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,copy) NSArray *pics1;
@property (nonatomic,copy) NSArray *pics2;

@property (nonatomic,copy) NSArray *videos;

@end

@implementation XFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupTableView];
    
    [self setupHeaderView];
    
    self.videoType = Hightdefinition;
    
    [self.view setNeedsUpdateConstraints];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.videos = self.hightVides;
    
    [self.tableView reloadData];
    
}

- (void)clickTopButton:(UIButton *)sender {
    
    if (sender == self.gqButton) {
        
        self.gqButton.selected = YES;
        self.vrButton.selected = NO;
        
        self.videos = self.hightVides;
        self.videoType = Hightdefinition;


    } else {
        
        self.gqButton.selected = NO;
        self.vrButton.selected = YES;
        self.videos = self.vrVideos;
        self.videoType = VRVideo;


    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
     
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
        make.centerX.mas_equalTo(sender);
        make.height.mas_equalTo(2);
        
    }];
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [HUD hideAnimated:YES afterDelay:0.5];
    
    [UIView animateWithDuration:0.25 animations:^{
       
        [self.view layoutIfNeeded];
        
    }];
    
    [self.tableView reloadData];

}

#pragma mark - videoCelldelegate

- (void)videoCell:(XFHomeVideoTableViewCell *)cell didClickIconWithjindexpath:(NSIndexPath *)indexpath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedCellBlock) {
        
        self.selectedCellBlock();
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenWidth * 42/75.f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videos.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFHomeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFHomeVideoTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFHomeVideoTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    XFHomeDataModel *model = self.videos[indexPath.row];
    
    cell.picView.image = [UIImage imageNamed:model.userPic];
    cell.nameLabel.text = model.userName;
    cell.iconVIew.image = [UIImage imageNamed:model.userIcon];
    cell.likeButton.selected = [model.isLiked intValue] == 0 ? NO : YES;
    cell.numberLabel.text = model.likeNumer;
    cell.delegate = self;
    
    return cell;
    
}

- (void)tapHeaderView {
    
    if (self.selectedCellBlock) {
        
        self.selectedCellBlock();
    }
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    
    [self.view addSubview:self.tableView];
    
}

- (void)setupHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenWidth * 38/75.f))];
    
    self.headerView.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.headerPicView = [[UIImageView alloc] init];
    
    self.headerPicView.image = [UIImage imageNamed:@"video_pic1"];
    
    [self.headerView addSubview:self.headerPicView];
    self.headerPicView.layer.masksToBounds = YES;
    self.headerPicView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView)];
    self.headerPicView.userInteractionEnabled = YES;
    [self.headerPicView addGestureRecognizer:tapHeader];
    
    self.gqButton = [[UIButton alloc] init];
    
    [self.gqButton setTitle:@"高清视频" forState:(UIControlStateNormal)];
     [self.gqButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.gqButton setTitleColor:kMainRedColor forState:(UIControlStateSelected)];

    self.gqButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.gqButton];
    
    
    self.vrButton = [[UIButton alloc] init];
    
    [self.vrButton setTitle:@"VR视频" forState:(UIControlStateNormal)];
    [self.vrButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.vrButton setTitleColor:kMainRedColor forState:(UIControlStateSelected)];

    self.vrButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.vrButton];
    
    self.slideView = [[UIView alloc] init];
    
    self.slideView.backgroundColor = kMainColor;
    [self.headerView addSubview:self.slideView];
    
    [self.gqButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vrButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];

    
}

- (void)updateViewConstraints {
    
    
    [self.headerPicView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(150);
        
    }];
    
    [self.gqButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.headerPicView.mas_bottom).offset(0);
        make.bottom.mas_offset(-2);
        make.left.mas_offset(0);
    }];
    
    [self.vrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headerPicView.mas_bottom).offset(0);
        make.bottom.mas_offset(-2);
        make.right.mas_offset(0);
        make.width.mas_equalTo(self.gqButton);
        make.left.mas_equalTo(self.gqButton.mas_right);
    }];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
        make.centerX.mas_equalTo(self.gqButton);
        make.height.mas_equalTo(2);
    }];
    
    [super updateViewConstraints];
}

@end
