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
#import "XFHomeNetworkManager.h"
#import "XFVideoModel.h"

@interface XFVideoViewController () <UITableViewDelegate,UITableViewDataSource,XFHomeVideoCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UITableView *VRView;


@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *headerPicView;

@property (nonatomic,strong) UIButton *gqButton;

@property (nonatomic,strong) UIButton *vrButton;
@property (nonatomic,strong) UIView *topLineView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,copy) NSArray *pics1;
@property (nonatomic,copy) NSArray *pics2;


@property (nonatomic,strong) NSMutableArray *hdvideos;
@property (nonatomic,strong) NSMutableArray *VRVideos;

@property (nonatomic,copy) NSArray *videos;

@property (nonatomic,assign) NSInteger hdPage;
@property (nonatomic,assign) NSInteger vrPage;

@property (nonatomic,copy) NSDictionary *adDatas;

@end

@implementation XFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    [self setupHeaderView];
    
    self.videoType = Hightdefinition;
    
    [self.view setNeedsUpdateConstraints];
    
//    [self loadData];

//    [self loadAdData];
}

- (void)loadAdData {
    
    [XFHomeNetworkManager getVideoAdWithSuccessBlock:^(id responseObj) {
        
        NSArray *adData = (NSArray *)responseObj;
       
        if (adData.count > 0) {
            
            self.adDatas = adData[0];
            
            [self.headerPicView setImageWithURL:_adDatas[@"image"][@"imageUrl"] options:(YYWebImageOptionSetImageWithFadeAnimation)];
        }

        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)loadData {
    
    [self loadAdData];
    
    if (self.videoType == Hightdefinition) {
        self.hdPage = 0;
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        
        [XFHomeNetworkManager getHDVideoWithPage:self.hdPage size:10 successBlock:^(id responseObj) {
            
            NSDictionary *datas = (NSDictionary *)responseObj;
            NSArray *hdDatas = datas[@"content"];
            
            NSMutableArray *hdarr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < hdDatas.count ; i ++ ) {
                
                [hdarr addObject:[XFVideoModel modelWithDictionary:hdDatas[i]]];
            }
            
            self.hdvideos = hdarr;
            
            self.videos = self.hdvideos;
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [HUD hideAnimated:YES];
        } failBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [HUD hideAnimated:YES];
            
        } progress:^(CGFloat progress) {
            
        }];
    } else {
        
        [self loadVrData];
    }

//    [XFHomeNetworkManager getVideoWithSuccessBlock:^(id responseObj) {
//
//        NSDictionary *datas = (NSDictionary *)responseObj;
//        NSArray *hdDatas = datas[@"hd"];
//        NSArray *vrDatas = datas[@"vr"];
//
//        NSMutableArray *hdarr = [NSMutableArray array];
//        NSMutableArray *vrArr = [NSMutableArray array];
//
//        for (NSInteger i = 0 ; i < hdDatas.count ; i ++ ) {
//
//            [hdarr addObject:[XFVideoModel modelWithDictionary:hdDatas[i]]];
//        }
//
//        self.hdvideos = hdarr.copy;
//
//        for (NSInteger i = 0 ; i < vrDatas.count ; i ++ ) {
//
//            [vrArr addObject:[XFVideoModel modelWithDictionary:vrDatas[i]]];
//        }
//
//        self.VRVideos = vrArr.copy;
//
//        self.videos = self.hdvideos;
//
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//
//
//    } failBlock:^(NSError *error) {
//
//        [self.tableView.mj_header endRefreshing];
//
//    } progress:^(CGFloat progress) {
//
//
//    }];
    
}

- (void)loadVrData {
    
    self.vrPage = 0;
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];

    [XFHomeNetworkManager getVRVideoWithPage:self.vrPage size:10 successBlock:^(id responseObj) {
        
        NSDictionary *datas = (NSDictionary *)responseObj;
        NSArray *vrDatas = datas[@"content"];
        
        NSMutableArray *vrArr = [NSMutableArray array];

        for (NSInteger i = 0 ; i < vrDatas.count ; i ++ ) {
            
            [vrArr addObject:[XFVideoModel modelWithDictionary:vrDatas[i]]];
        }
        
        self.VRVideos = vrArr;
        
        self.videos = self.VRVideos;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [HUD hideAnimated:YES];
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)loadMoreData {
    
    if (self.videoType == Hightdefinition) {
        self.hdPage += 1;
        
        [XFHomeNetworkManager getHDVideoWithPage:self.hdPage size:10 successBlock:^(id responseObj) {
            
            
            NSDictionary *datas = (NSDictionary *)responseObj;
            NSArray *hdDatas = datas[@"content"];
            
            NSMutableArray *hdarr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < hdDatas.count ; i ++ ) {
                
                [hdarr addObject:[XFVideoModel modelWithDictionary:hdDatas[i]]];
            }
            
            [self.hdvideos addObjectsFromArray:hdarr.copy];
            self.videos = self.hdvideos;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        } failBlock:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            
            
        } progress:^(CGFloat progress) {
            
        }];
        
    } else {
        
        self.vrPage += 1;
        [XFHomeNetworkManager getVRVideoWithPage:self.vrPage size:10 successBlock:^(id responseObj) {
            [self.tableView.mj_footer endRefreshing];
            
            NSDictionary *datas = (NSDictionary *)responseObj;
            NSArray *vrDatas = datas[@"content"];
            
            NSMutableArray *vrArr = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < vrDatas.count ; i ++ ) {
                
                [vrArr addObject:[XFVideoModel modelWithDictionary:vrDatas[i]]];
            }
            
            [self.VRVideos addObjectsFromArray:vrArr.copy];
            
            self.videos = self.VRVideos;
            
            [self.tableView reloadData];
            
        } failBlock:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}

- (void)clickTopButton:(UIButton *)sender {
    
    if (sender == self.gqButton) {
        
        self.gqButton.selected = YES;
        self.vrButton.selected = NO;
        
        self.videoType = Hightdefinition;
        
        [self loadData];

    } else {
        
        self.gqButton.selected = NO;
        self.vrButton.selected = YES;
        self.videoType = VRVideo;
        [self loadVrData];

    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
     
        make.bottom.mas_offset(-8);
        make.width.mas_equalTo(60);
        make.centerX.mas_equalTo(sender);
        make.height.mas_equalTo(2);
        
    }];
    
    [UIView animateWithDuration:0.25 animations:^{

        [self.view layoutIfNeeded];

    }];
    
}

#pragma mark - videoCelldelegate

- (void)videoCell:(XFHomeVideoTableViewCell *)cell didClickIconWithjindexpath:(NSIndexPath *)indexpath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    XFVideoModel *model = self.self.videos[indexpath.row];
    
    detailVC.userName  = model.user[@"nickname"];
    detailVC.userId = model.user[@"uid"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.iconUrl = model.user[@"headIconUrl"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    if (self.selectedCellBlock) {
        
        self.selectedCellBlock(self.videos[indexPath.row]);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenWidth * 201/375.f + 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videos.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFHomeVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFHomeVideoTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFHomeVideoTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    cell.model = self.videos[indexPath.row];
    cell.delegate = self;
    
    return cell;
    
}

- (void)tapHeaderView {
    
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    [self.view addSubview:self.tableView];
    
    if (@available (ios 11 , * )) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//
//    }];
    
    self.tableView.mj_header = [XFToolManager refreshHeaderWithBlock:^{
        [self loadData];

    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
        
    }];
    
    
    
}

- (void)setupHeaderView {
    
    self.headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenWidth * 30/75.f + 43))];
    
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
    
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = UIColorHex(e0e0e0);
    [self.headerView addSubview:self.topLineView];
    
    self.slideView = [[UIView alloc] init];
    
    self.slideView.backgroundColor = kMainColor;
    [self.headerView addSubview:self.slideView];
    
    [self.gqButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vrButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];

    
}

- (void)updateViewConstraints {
    
    
    [self.headerPicView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(kScreenWidth * 30/75.f);
        
    }];
    
    [self.gqButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.headerPicView.mas_bottom).offset(9);
        make.bottom.mas_offset(-10);
        make.left.mas_offset(0);
    }];
    
    [self.vrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headerPicView.mas_bottom).offset(9);
        make.bottom.mas_offset(-10);
        make.right.mas_offset(0);
        make.width.mas_equalTo(self.gqButton);
        make.left.mas_equalTo(self.gqButton.mas_right);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(-7);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_offset(-8);
        make.width.mas_equalTo(60);
        make.centerX.mas_equalTo(self.gqButton);
        make.height.mas_equalTo(2);
    }];
    
    [super updateViewConstraints];
}

@end
