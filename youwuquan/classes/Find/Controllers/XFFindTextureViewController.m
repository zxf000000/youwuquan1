//
//  XFFindTextureViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindTextureViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFFindCellNode.h"
#import "XFFIndHeaderCell.h"
#import "XFSlideView.h"
#import "XFFindDetailViewController.h"
#import "XFStatusDetailViewController.h"
#import "XFYwqAlertView.h"
#import "XFShareManager.h"
#import "XFFIndCacheManager.h"
#import "XFFindModel.h"
#import "XFGiftViewController.h"
#import "XFVideoDetailViewController.h"
#import "XFActivityViewController.h"
#import "XFFindNetworkManager.h"
#import "XFMineNetworkManager.h"
#import "XFMyAuthViewController.h"
#import "XFFindActivityModel.h"
#import "XFFindSearchNode.h"
#import "XFSearchViewController.h"
#import "LBPhotoBrowserManager.h"
#import <AVKit/AVKit.h>
#import "XFAlertViewController.h"
#import "XFPayViewController.h"
#import "FTPopOverMenu.h"

@interface XFFindTextureViewController () <ASTableDelegate,ASTableDataSource,XFFindCellDelegate,XFFindHeaderdelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) XFSlideView *topView;

@property (nonatomic,strong) ASTableNode *rightNode;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) NSInteger hdCount;

@property (nonatomic,copy) NSArray *pics;

@property (nonatomic,assign) BOOL hdIsopen;

@property (nonatomic,copy) NSArray *datas;

@property (nonatomic,strong) NSMutableArray *inviteDatas;
@property (nonatomic,strong) NSMutableArray *careDatas;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger carePage;

@property (nonatomic,assign) BOOL isInvite;
// 状态是否更改
@property (nonatomic,assign) BOOL isChanged;

@property (nonatomic,strong) NSMutableArray *indexPathsTobeReload;

@property (nonatomic,copy) NSArray *authList;

@property (nonatomic,copy) NSArray *adDatas;

@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSURL  *voiceUrl;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) AVPlayer *audioPLayer;

@end

@implementation XFFindTextureViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _inviteDatas = [NSMutableArray array];
        _careDatas = [NSMutableArray array];
        _indexPathsTobeReload = [NSMutableArray array];
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    
    self.hdCount = 0;
    self.page = -1;
    self.carePage = -1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    self.topView = [[XFSlideView alloc] initWithTitle:@[@"推荐",@"关注"]];
    self.navigationItem.titleView = self.topView;
    
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
    if (@available (ios 11 , *)) {
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.mas_offset(0);
        }];
        
    }
    
    self.isInvite = YES;
    __weak typeof(self) weakSelf = self;
    
    self.topView.clickButtonBlock = ^(NSInteger tag) {
        
        switch (tag) {
                
            case 1001:
            {
                weakSelf.isInvite = YES;
                [weakSelf.scrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
                
            }
                break;
                
            case 1002:
            {
                weakSelf.isInvite = NO;
                
                [weakSelf.scrollView setContentOffset:(CGPointMake(kScreenWidth, 0)) animated:YES];
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [weakSelf loadFollowData];
                    
                });
                
                
            }
                break;
                
        }
    };
    
    [self setupScrollView];
    
    [self network];
    //    [self getAdData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLikeStatus:) name:kRefreshLikeStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCareStatus:) name:kRefreshCareStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshModelWith:) name:kRefreshLockStatusForModelNotification object:nil];
    
    
}

- (void)network {
    
    self.HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    // 获取活动
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self getAdData];
    }];
    // 获取推荐列表
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadinviteData];
    }];
    
    //设置依赖
    [operation2 addDependency:operation1];      //任务3依赖任务2
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1] waitUntilFinished:NO];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 刷新点赞和关注的通知
- (void)refreshLikeStatus:(NSNotification *)notification {
    
    XFStatusModel *model = notification.object[@"status"];
    BOOL liked = [notification.object[@"liked"] boolValue];
    
    for (XFStatusModel *status in self.inviteDatas) {
        
        if ([model.id isEqualToString:status.id]) {
            
            [self refreshlikeStatusWithModel:status witfFollowed:liked];
            
            self.isChanged = YES;
            
        }
        
    }
    
    
    for (XFStatusModel *status in self.careDatas) {
        
        if ([model.id isEqualToString:status.id]) {
            
            [self refreshlikeStatusWithModel:status witfFollowed:liked];
            
            self.isChanged = YES;
            
        }
        
    }
    
    
    
}

- (void)refreshCareStatus:(NSNotification *)notification {
    
    XFStatusModel *model = notification.object[@"status"];
    BOOL followed = [notification.object[@"followed"] boolValue];
    
    for (XFStatusModel *status in self.inviteDatas) {
        
        if ([model.user[@"uid"] intValue] == [status.user[@"uid"] intValue]) {
            
            [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:followed reload:NO];
            self.isChanged = YES;
            
        }
        
    }
    
}

#pragma mark - 刷新解锁状态
- (void)refreshModelWith:(NSNotification *)notification {
    
    XFStatusModel *model = notification.object;
    
    for (XFStatusModel *status in self.inviteDatas) {
        
        if ([status.id isEqualToString:model.id]) {
            status.pictures = model.pictures;
            self.isChanged = YES;
            
        }
    }
    
    for (XFStatusModel *status in self.careDatas) {
        
        if ([status.id isEqualToString:model.id]) {
            status.pictures = model.pictures;
            self.isChanged = YES;
            
        }
    }
    
    
}

- (void)getAdData {
    
    
    [XFFindNetworkManager getFindAdWithPage:0 size:6 SuccessBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < datas.count; i ++ ) {
            
            [arr addObject:[XFFindActivityModel modelWithDictionary:datas[i]]];
        }
        
        self.adDatas = arr.copy;
        self.hdCount = self.adDatas.count >= 2 ? 2 : self.adDatas.count;
        
        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.isChanged) {
        
        [self reloadLeftData];
        [self reloadrihtData];
        
        
        self.isChanged = NO;
        
    }
    
}

- (void)loadFollowData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    self.carePage = 0;
    
    [XFFindNetworkManager getFollowsDataWithPage:self.carePage rows:10 SuccessBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSLog(@"%@",datas);
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i< datas.count ; i ++ ) {
            
            [arr addObject:[XFStatusModel modelWithDictionary:datas[i]]];
            
        }
        self.careDatas = arr;
        
        [self reloadrihtData];
        
        [HUD hideAnimated:YES];
        
        [self.rightNode.view.mj_header endRefreshing];
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
        [self.rightNode.view.mj_header endRefreshing];
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}

- (void)loadinviteData {
    
    self.page = 0;
    
    [XFFindNetworkManager getInviteDataWithPage:self.page rows:10 SuccessBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i< datas.count ; i ++ ) {
            
            [arr addObject:[XFStatusModel modelWithDictionary:datas[i]]];
            
        }
        self.inviteDatas = arr;
        
        [self reloadLeftData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableNode.view.mj_header endRefreshing];
            [self.HUD hideAnimated:YES];
            
        });
        
        
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD hideAnimated:YES];
            
            [self.tableNode.view.mj_header endRefreshing];
            
        });
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}

#pragma mark - 刷新
- (void)reloadLeftData {
    
    NSArray *cells = self.tableNode.visibleNodes;
    
    for (ASCellNode *node in cells) {
        
        if ([node isKindOfClass:[XFFindCellNode class]]) {
            
            [_indexPathsTobeReload addObject:node.indexPath];

        }
        
    }
    
    for (int i = 0 ; i < 7 ; i ++ ) {
        
        
        [_indexPathsTobeReload addObject:[NSIndexPath indexPathForItem:i inSection:0]];

    }
    
    [self.tableNode reloadDataWithCompletion:^{
        
        _indexPathsTobeReload = [NSMutableArray array];
        
    }];
}

- (void)reloadrihtData {
    
    NSArray *cells = self.rightNode.visibleNodes;
    
    for (ASCellNode *node in cells) {
        
        [_indexPathsTobeReload addObject:node.indexPath];

        
    }
    
    
    [self.rightNode reloadDataWithCompletion:^{
        
        _indexPathsTobeReload = [NSMutableArray array];
        
    }];
}

#pragma mark - 插入更多数据----智能预加载
- (void)retrieveNextPageWithCompletion:(void (^)(NSArray *))block {
    
    if (self.isInvite) {
        
        self.page += 1;
        
        [XFFindNetworkManager getInviteDataWithPage:self.page rows:10 SuccessBlock:^(id responseObj) {
            
            
            NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                NSDictionary *dic = datas[i];
                
                XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
                
                [arr addObject:model];
                
            }
            
            if (arr.count > 0) {
                
                block(arr.copy);
                
            }
            [self.tableNode.view.mj_footer endRefreshing];
            
        } failBlock:^(NSError *error) {
            
            [self.tableNode.view.mj_footer endRefreshing];
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        self.carePage += 1;
        
        [XFFindNetworkManager getFollowsDataWithPage:self.carePage rows:10 SuccessBlock:^(id responseObj) {
            
            
            NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                NSDictionary *dic = datas[i];
                
                XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
                
                [arr addObject:model];
                
            }
            
            if (arr.count > 0) {
                
                block(arr.copy);
                
            }
            [self.rightNode.view.mj_footer endRefreshing];
            
        } failBlock:^(NSError *error) {
            
            [self.rightNode.view.mj_footer endRefreshing];
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    }
    
}

- (void)insertNewRowsInTableNode:(NSArray *)newDatas {
    
    if (self.isInvite) {
        
        NSInteger section = 1;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        NSUInteger newTotalNumberOfPhotos = self.inviteDatas.count + newDatas.count;
        for (NSUInteger row = self.inviteDatas.count; row < newTotalNumberOfPhotos; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:path];
        }
        
        [self.inviteDatas addObjectsFromArray:newDatas];
        
        [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        
    } else {
        
        NSInteger section = 0;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        NSUInteger newTotalNumberOfPhotos = self.careDatas.count + newDatas.count;
        for (NSUInteger row = self.careDatas.count; row < newTotalNumberOfPhotos; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:path];
        }
        
        [self.careDatas addObjectsFromArray:newDatas];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.rightNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
        });
        
    }
    
    
}

//  预加载
- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    
    return NO;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    //1
    [self retrieveNextPageWithCompletion:^(NSArray *animals) {
        //2
        [self insertNewRowsInTableNode:animals];
        //3
        [context completeBatchFetching:YES];
    }];
}

- (void)viewWillLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    
}


- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *node = [tableNode nodeForRowAtIndexPath:indexPath];
    node.selected = NO;
    
    if (self.tableNode == tableNode) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                // 搜索
                XFSearchViewController *searchVC = [[XFSearchViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:searchVC];
                [self presentViewController:navi animated:NO completion:nil];
                
                return;
                
            }
            
            // 活动页面
            // TODO:
            XFActivityViewController *activityVC = [[XFActivityViewController alloc] init];
            activityVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityVC animated:YES];
            
        } else {
            
            XFStatusModel *model = self.inviteDatas[indexPath.row];
            
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            statusVC.hidesBottomBarWhenPushed = YES;
            statusVC.type = Other;
            statusVC.status = model;
            
            [self.navigationController pushViewController:statusVC animated:YES];
            
        }
        
    } else {
        
        XFStatusModel *model = self.careDatas[indexPath.row];
        
        XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
        statusVC.hidesBottomBarWhenPushed = YES;
        statusVC.type = Other;
        statusVC.status = model;
        
        [self.navigationController pushViewController:statusVC animated:YES];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    if (self.tableNode == tableNode) {
        
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (tableNode == self.tableNode) {
        
        if (section == 0) {
            
            return self.hdCount + 1;
        } else {
            
            return self.inviteDatas.count;
        }
    }
    
    return self.careDatas.count;
}

- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView removeGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    // 推荐
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    //    self.tableNode.leadingScreensForBatching = 2;
    
    [self.scrollView addSubnode:self.tableNode];
    if (@available (ios 11 , * )) {
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 关注
    self.rightNode = [[ASTableNode alloc] init];
    self.rightNode.delegate = self;
    self.rightNode.dataSource = self;
    self.rightNode.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64);
    self.rightNode.view.showsVerticalScrollIndicator = NO;
    //    self.rightNode.leadingScreensForBatching = 2;
    
    [self.scrollView addSubnode:self.rightNode];
    
    if (@available (ios 11 , * )) {
        self.rightNode.view.estimatedRowHeight = 0;
        self.rightNode.view.estimatedSectionHeaderHeight = 0;
        self.rightNode.view.estimatedSectionFooterHeight = 0;
        self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    self.rightNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.rightNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;

    NSMutableArray *images = [NSMutableArray array];
    for (int i= 1 ; i < 75 ; i ++ ) {
        
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"图层%zd",i]]];
        
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(network)];
    // 设置普通状态的动画图片
    [header setImages:images duration:2 forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:images duration:2 forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:images duration:2 forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;

    // 设置header
    self.tableNode.view.mj_header = header;

    
    self.tableNode.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self retrieveNextPageWithCompletion:^(NSArray *datas) {
            
            [self insertNewRowsInTableNode:datas];
            
            [self.tableNode.view.mj_footer endRefreshing];
            
        }];
        
    }];
    
    [self.tableNode.view.mj_footer setAutomaticallyHidden:YES];
    
    self.rightNode.view.mj_header = [XFToolManager refreshHeaderWithBlock:^{
        [self loadFollowData];
        
    }];
    
    self.rightNode.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self retrieveNextPageWithCompletion:^(NSArray *datas) {
            
            [self insertNewRowsInTableNode:datas];
            
            [self.tableNode.view.mj_footer endRefreshing];
            
        }];
        
    }];
}

#pragma mark - cellNodeDelegate点赞

- (void)findCellNode:(XFFindCellNode *)node didClickJuBaoButtonWithButton:(ASButtonNode *)jubaoButton {
    
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = 40;
    configuration.menuWidth = 80;
    [FTPopOverMenu showForSender:jubaoButton.view
                   withMenuArray:@[@"举报"]
                      imageArray:@[@"find_jubao"]
                       doneBlock:^(NSInteger selectedIndex) {
                            // 举报操作
                           MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view];
                           
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               
                               [XFToolManager changeHUD:HUD successWithText:@"举报成功!"];
                               
                           });
                           
                       } dismissBlock:^{
                           

                           
                       }];
    
    
}

- (void)playbackFinished:(NSNotification *)notice {
    
    self.isPlaying = NO;
    
}

// 播放语音
- (void)findCellNode:(XFFindCellNode *)node didClickVoiceButtonWithUrl:(NSString *)url {
    
    self.voiceUrl = [NSURL URLWithString:url];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:self.voiceUrl];
    if (!self.audioPLayer) {
        self.audioPLayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    }
    
    [self.audioPLayer replaceCurrentItemWithPlayerItem:songItem];
    
    if (self.isPlaying) {
        [self.audioPLayer pause];
        self.isPlaying = NO;
        
    } else {
        
        [self.audioPLayer play];
        self.isPlaying = YES;
        self.HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        [_HUD hideAnimated:YES afterDelay:0.5];
        
    }
    
}

- (void)buyTheStatusWithStatus:(XFStatusModel *)status {
    
    XFAlertViewController *alertVC = [[XFAlertViewController alloc] init];
    alertVC.type = XFAlertViewTypeUnlockStatus;
    alertVC.unlockPrice = status.unlockPrice;
    alertVC.clickOtherButtonBlock = ^(XFAlertViewController *alert) {
        // 充值页面
        XFPayViewController *payVC = [[XFPayViewController alloc] init];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
        
        [self presentViewController:navi animated:YES completion:nil];
        
    };
    
    alertVC.clickDoneButtonBlock = ^(XFAlertViewController *alert) {
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];
        
        [XFFindNetworkManager unlockStatusWithStatusId:status.id successBlock:^(id responseObj) {
            // 重新获取数据
            [XFToolManager changeHUD:HUD successWithText:@"解锁成功"];
            // 重新获取数据,刷新
            [XFFindNetworkManager getOneStatusWithStatusId:status.id successBlock:^(id responseObj) {
            
                XFStatusModel *model = [XFStatusModel modelWithDictionary:(NSDictionary *)responseObj];
                
                if (self.isInvite) {
                    
                    NSInteger index = [self.inviteDatas indexOfObject:status];
                    [self.inviteDatas replaceObjectAtIndex:index withObject:model];
                    [self.tableNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
                } else {
                    
                    NSInteger index = [self.careDatas indexOfObject:status];
                    [self.careDatas replaceObjectAtIndex:index withObject:model];

                    [self.rightNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                    
                }
                
            } failBlock:^(NSError *error) {
                
            } progress:^(CGFloat progress) {
                
            }];
            // 刷新上层数据
            
        } failBlock:^(NSError *error) {
            // 解锁失败
            [HUD hideAnimated:YES];
            // 获取返回状态码
            if (!error) {
                // 余额不足
                // 充值页面
                XFPayViewController *payVC = [[XFPayViewController alloc] init];
                
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
                
                [self presentViewController:navi animated:YES completion:nil];
                
            }
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
        
    };
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickImageWithIndex:(NSInteger)index urls:(NSArray *)urls {
    
    XFStatusModel *model = node.model;
    
    if (model.video) {
        
        // 是否是私密
        if ([model.video[@"videoType"] isEqualToString:@"close"]) {
            
            // 解锁
            [self buyTheStatusWithStatus:node.model];
            
        } else {
            
            // 播放视频
            NSURL * videoURL = [NSURL URLWithString:model.video[@"video"][@"srcUrl"]];
            
            AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc] init];
            
            avPlayer.player = [[AVPlayer alloc] initWithURL:videoURL];
            
            avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [[avPlayer player] play];
            [self presentViewController:avPlayer animated:YES completion:nil];
            
        }
        

        return;
    }
    
    if (index < node.openCount) {
        
        NSMutableArray *items = @[].mutableCopy;
        
        for (int i = 0; i < node.picNodes.count; i++) {
            
            if (i < node.openCount) {
                
                XFNetworkImageNode *imgNode = node.picNodes[i];
                UIImageView *imgView = [[UIImageView alloc] init];
                
                CGRect rect = CGRectZero;
                
                if ([imgNode isKindOfClass:[XFNetworkImageNode class]]) {
                    
                    rect = [node.view convertRect:imgNode.view.frame toView:self.view];
                    imgView.frame = rect;
                    
                } else if ([imgNode isKindOfClass:[ASOverlayLayoutSpec class]]){
                    
                    ASOverlayLayoutSpec *overlay = (ASOverlayLayoutSpec *)imgNode;
                    for (ASDisplayNode *picNode in overlay.children) {
                        
                        if ([picNode isKindOfClass:[XFNetworkImageNode class]]) {
                            
                            rect = [node.view convertRect:picNode.view.frame toView:self.view];
                            imgView.frame = rect;

                        }
                        
                    }
                }
                
                LBPhotoWebItem *item = [[LBPhotoWebItem alloc] initWithURLString:urls[i] frame:rect];
                [items addObject:item];
            }
            
        }
        
        [LBPhotoBrowserManager.defaultManager showImageWithWebItems:items selectedIndex:index fromImageViewSuperView:self.view].lowGifMemory = YES;
        
        [[[LBPhotoBrowserManager.defaultManager addLongPressShowTitles:@[@"保存",@"识别二维码",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
            LBPhotoBrowserLog(@"%@",title);
        }]addPhotoBrowserWillDismissBlock:^{
            LBPhotoBrowserLog(@"即将销毁");
        }].needPreloading = NO;// 这里关掉预加载功能
    } else {
        
        [self buyTheStatusWithStatus:node.model];
        
    }
    

    
}

- (void)findCellNode:(XFFindCellNode *)node didClickShareButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFStatusModel *model;
    if (self.isInvite) {
        
        model = self.inviteDatas[inexPath.row];
        
    } else {
        
        model = self.careDatas[inexPath.row];
        
    }
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:model.user[@"headIconUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *baseUrl = @"http://118.126.102.173:8081/share/index.html";
            NSString *shareUrl = [NSString stringWithFormat:@"%@?publishId=%@",baseUrl,model.id];
            
            [XFShareManager sharedUrl:shareUrl image:image title:model.user[@"nickname"] detail:@"我在尤物圈等你"];
        });
        

    }];
    
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    XFStatusModel *model;
    if (self.isInvite) {
        
        model = self.inviteDatas[indexPath.row];
        
    } else {
        
        model = self.careDatas[indexPath.row];
        
    }
    
    if (model.likedIt) {
        
        [XFFindNetworkManager unlikeWithStatusId:model.id successBlock:^(id responseObj) {
            
            [self refreshlikeStatusWithModel:model witfFollowed:NO];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFFindNetworkManager likeWithStatusId:model.id successBlock:^(id responseObj) {
            
            [self refreshlikeStatusWithModel:model witfFollowed:YES];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
    }
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickIconForIndex:(NSIndexPath *)indexPath {
    
    XFStatusModel *model;
    
    if (self.isInvite) {
        
        model = self.inviteDatas[indexPath.row];
    } else {
        
        model = self.careDatas[indexPath.row];
    }
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.userId = [NSString stringWithFormat:@"%@",model.user[@"uid"]];
    detailVC.userName = model.user[@"nickname"];
    detailVC.iconUrl = model.user[@"headIconUrl"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFStatusModel *model;
    if (self.isInvite) {
        
        model = self.inviteDatas[inexPath.row];
    } else {
        
        model = self.careDatas[inexPath.row];
    }
    
    XFGiftViewController *giftVC = [[XFGiftViewController alloc] init];
    
    giftVC.userName = model.user[@"nickname"];
    giftVC.uid = model.user[@"uid"];
    giftVC.iconUrl = model.user[@"headIconUrl"];
    
    [self presentViewController:giftVC animated:YES completion:nil];
    
    return;
    
}

// 关注
- (void)findCellNode:(XFFindCellNode *)node didClickFollowButtonWithIndex:(NSIndexPath *)inexPath {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    XFStatusModel *model;
    if (self.isInvite) {
        
        model = self.inviteDatas[inexPath.row];
        
    } else {
        
        model = self.careDatas[inexPath.row];
        
    }
    
    if ([model.user[@"followed"] boolValue]) {
        
        // 取消关注
        [XFMineNetworkManager unCareSomeoneWithUid:model.user[@"uid"] successBlock:^(id responseObj) {
            
            [HUD hideAnimated:YES];
            [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:NO reload:YES] ;
            
            
        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];
            
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFMineNetworkManager careSomeoneWithUid:model.user[@"uid"] successBlock:^(id responseObj) {
            [HUD hideAnimated:YES];
            
            [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:YES reload:YES];
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    }
    
}

- (void)refreshlikeStatusWithModel:(XFStatusModel *)model witfFollowed:(BOOL)liked {
    
    [XFFindNetworkManager getOneStatusWithStatusId:model.id successBlock:^(id responseObj) {
        
        XFStatusModel *status = [XFStatusModel modelWithDictionary:(NSDictionary *)responseObj];
        
        model.likeNum = status.likeNum;
        model.likedIt = !model.likedIt;
        
        XFFindCellNode *node;
        
        if (self.isInvite) {
            
            NSInteger index = [self.inviteDatas indexOfObject:model];
            [self.tableNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
            node = [self.tableNode nodeForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:1]];
        } else {
            
            NSInteger index = [self.careDatas indexOfObject:model];
            [self.rightNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
            node = [self.rightNode nodeForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
        }
        
        
        [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{}];
        
    } failBlock:^(NSError *error) {
        
        
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}

- (void)refreshFollowStatusWithUid:(NSString *)uid witfFollowed:(BOOL)followed reload:(BOOL)reload {
    
//    if (self.isInvite) {
    
        for (XFStatusModel *model in self.inviteDatas) {
            
            if ([model.user[@"uid"] intValue] == [uid intValue]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.user];
                
                [dic setObject:@(followed) forKey:@"followed"];
                
                model.user = dic.copy;
                
                if (followed) {
                    
                    [self.careDatas addObject:model];
                }
            }
            
        }
        
        if (reload) {
            
            // 分开刷新
            [self reloadLeftData];
        }

//    } else {
    
        NSMutableArray *datas = [NSMutableArray array];
        for (XFStatusModel *model in self.careDatas) {
            
            if ([model.user[@"uid"] intValue] == [uid intValue]) {
                
                if (!followed) {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.user];

                    [dic setObject:@(followed) forKey:@"followed"];

                    model.user = dic.copy;
                    
                }

            } else {
                
                [datas addObject:model];
                
            }
            
        }
        
        self.careDatas = datas;
        if (reload) {
            
            // 分开刷新
            [self reloadrihtData];
        }
//    }
    
}

#pragma mark - 活动celldaili
- (void)didClickMoreButton {
    
    self.hdCount = self.adDatas.count;
    
    self.hdIsopen = YES;
    [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
    
}

- (void)didClickNoMoreButton {
    
    self.hdCount = self.adDatas.count >= 2 ? 2 : self.adDatas.count;
    self.hdIsopen = NO;
    [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
    [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    
}

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen {
    
    if (isOpen) {
        
        self.openIndexPath = index;
        
    } else {
        
        self.openIndexPath = nil;
        
    }
    
    if (self.scrollView.contentOffset.x == 0) {
        
        [self reloadLeftData];
        
    } else {
        
        [self reloadrihtData];
        
    }
    
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableNode == self.tableNode) {
        
        switch (indexPath.section) {
            case 0:
            {
                
                if (indexPath.row == 0) {
                    
                    XFFindSearchNode *searchNode = [[XFFindSearchNode alloc] init];
                    
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        searchNode.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            searchNode.neverShowPlaceholders = NO;
                            
                            
                        });
                        
                    }
                    
                    return searchNode;
                    
                } else {
                    XFFIndHeaderCell *node = [[XFFIndHeaderCell alloc] initWithModel:self.adDatas[indexPath.row - 1]];
                    
                    node.delegate = self;
                    if (indexPath.row == self.hdCount) {
                        
                        node.isEnd = YES;
                        node.isOpen = self.hdIsopen;
                        
                    } else {
                        
                        node.isEnd = NO;
                    }
                    
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        node.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            node.neverShowPlaceholders = NO;
                        
                        });
                    }
                    return node;
                }
            }
                break;
            case 1:
            {
                
                XFFindCellNode *node = [[XFFindCellNode alloc] initWithModel:self.inviteDatas[indexPath.row]];
                node.delegate = self;
                node.index = indexPath;
                node.neverShowPlaceholders = YES;
                if ([_indexPathsTobeReload containsObject:indexPath]) {
                    
                    ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                    
                    node.neverShowPlaceholders = YES;
                    oldCellNode.neverShowPlaceholders = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        node.neverShowPlaceholders = NO;
                        
                        
                    });
                    
                }
                
                return node;
            }
                break;
            default:
                break;
        }
    } else {
        
        XFFindCellNode *node = [[XFFindCellNode alloc] initWithModel:self.careDatas[indexPath.row]];
        
        node.index = indexPath;
        
        node.delegate = self;
        
        if ([_indexPathsTobeReload containsObject:indexPath]) {
            
            ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
            
            node.neverShowPlaceholders = YES;
            oldCellNode.neverShowPlaceholders = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                node.neverShowPlaceholders = NO;
                
            });
            
        }
        
        return node;
        
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 11;
    }
    return 0;
}



@end
