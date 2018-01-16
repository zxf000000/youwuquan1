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
            
                
//                [weakSelf network];

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
                
                [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:followed];
                self.isChanged = YES;
                
            }
            
        }
    
    [self loadFollowData];
        
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
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [XFFindNetworkManager getFindAdWithPage:0 size:6 SuccessBlock:^(id responseObj) {
       
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < datas.count; i ++ ) {
            
            [arr addObject:[XFFindActivityModel modelWithDictionary:datas[i]]];
        }
        
        self.adDatas = arr.copy;
        self.hdCount = self.adDatas.count >= 2 ? 2 : self.adDatas.count;
        dispatch_semaphore_signal(sema);

    } failBlock:^(NSError *error) {
        dispatch_semaphore_signal(sema);

    } progress:^(CGFloat progress) {
        
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    
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
//    self.scrollView.hidden = YES;
    
    self.carePage = 0;
    
    [XFFindNetworkManager getFollowsDataWithPage:self.carePage rows:10 SuccessBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
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
    
    NSInteger count = [self.tableNode numberOfRowsInSection:1];
    if ( count > 0 ) {
        
        // 将肉眼可见的cell添加进indexPathesToBeReloaded中
        for (int i = 0 ; i < 2 ; i ++ ) {
            
            for (int j = 0 ; j < 5 ; j ++ ) {
                
                [_indexPathsTobeReload appendObject:[NSIndexPath indexPathForRow:j inSection:i]];

            }
        
        }

    }

    [self.tableNode reloadData];
}

- (void)reloadrihtData {
    
    NSInteger count = [self.rightNode numberOfRowsInSection:0];
    if ( count > 0 ) {
        
        // 将肉眼可见的cell添加进indexPathesToBeReloaded中
        for (int i = 0 ; i < 2 ; i ++ ) {
            
            for (int j = 0 ; j < 5 ; j ++ ) {
                
                [_indexPathsTobeReload appendObject:[NSIndexPath indexPathForRow:j inSection:i]];
                
            }
            
        }
        
    }
    
    [self.rightNode reloadData];
}

#pragma mark - 插入更多数据----智能预加载
- (void)retrieveNextPageWithCompletion:(void (^)(NSArray *))block {
    
    if (self.isInvite) {
        
        self.page += 1;
        
        [XFFindNetworkManager getInviteDataWithPage:self.page rows:10 SuccessBlock:^(id responseObj) {
            
            [self.tableNode.view.mj_footer endRefreshing];
            
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
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        self.carePage += 1;
        
        [XFFindNetworkManager getFollowsDataWithPage:self.carePage rows:10 SuccessBlock:^(id responseObj) {
            
            [self.rightNode.view.mj_footer endRefreshing];

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
            
        } failBlock:^(NSError *error) {
            
            
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
    
//    if (self.inviteDatas.count == 0) {
//
//        return NO;
//    }
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
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView removeGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    // 推荐
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.leadingScreensForBatching = 1;

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
    self.rightNode.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.rightNode.view.showsVerticalScrollIndicator = NO;
    self.rightNode.leadingScreensForBatching = 1;

    [self.scrollView addSubnode:self.rightNode];
    
    if (@available (ios 11 , * )) {
        self.rightNode.view.estimatedRowHeight = 0;
        self.rightNode.view.estimatedSectionHeaderHeight = 0;
        self.rightNode.view.estimatedSectionFooterHeight = 0;
        self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    }
    
    self.rightNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.rightNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadinviteData];
        
    }];
    
    self.tableNode.view.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self retrieveNextPageWithCompletion:^(NSArray *datas) {
            
            [self insertNewRowsInTableNode:datas];

        }];

    }];
    
    self.rightNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadFollowData];
    }];
    
    self.rightNode.view.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self retrieveNextPageWithCompletion:^(NSArray *datas) {
            
            [self insertNewRowsInTableNode:datas];

        }];
        
    }];
    
}

#pragma mark - cellNodeDelegate点赞

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
        
        // 分享
        [XFShareManager sharedUrl:@"http://www.baidu.com" image:image title:model.user[@"nickname"] detail:@"我在尤物圈等你哦"];
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
            [node.likeButton setTitle:model.likeNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
            
            node.likeButton.selected = NO;
            
            [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
                
                
            }];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFFindNetworkManager likeWithStatusId:model.id successBlock:^(id responseObj) {
            
            
            [self refreshlikeStatusWithModel:model witfFollowed:YES];
            
            [node.likeButton setTitle:model.likeNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
            
            node.likeButton.selected = YES;
            
            [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
                
                
            }];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
    }
    

    
    
//    model.isLiked = [model.isLiked intValue] == 0 ? @"1" : @"0";

    
    
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
    detailVC.userId = model.user[@"uid"];
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
            [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:NO] ;


        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];

            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } else {
            
            [XFMineNetworkManager careSomeoneWithUid:model.user[@"uid"] successBlock:^(id responseObj) {
                [HUD hideAnimated:YES];

                [self refreshFollowStatusWithUid:model.user[@"uid"] witfFollowed:YES];
                
            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];

            } progressBlock:^(CGFloat progress) {
                
                
            }];
            
        }
    

}

- (void)refreshlikeStatusWithModel:(XFStatusModel *)model witfFollowed:(BOOL)liked {
    
    model.likedIt = liked;
    if (liked) {
        
        model.likeNum = [NSString stringWithFormat:@"%zd",[model.likeNum integerValue] + 1];
        
    } else {
        
        model.likeNum = [NSString stringWithFormat:@"%zd",[model.likeNum integerValue] - 1];

    }

}

- (void)refreshFollowStatusWithUid:(NSString *)uid witfFollowed:(BOOL)followed {
    
    if (self.isInvite) {
        
        for (XFStatusModel *model in self.inviteDatas) {
            
            if ([model.user[@"uid"] intValue] == [uid intValue]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.user];
                
                [dic setObject:@(followed) forKey:@"followed"];
                
                model.user = dic.copy;
            }
        
        }
        
        // 分开刷新
        [self reloadLeftData];
    }
    
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
                    
                    return searchNode;
                    
                }
                
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
                        
                        NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                        
                        [self.indexPathsTobeReload removeObjectAtIndex:index];
                        
                    });
                    
                }
                
                    return node;
                
            }
                break;
            case 1:
            {
                    
                XFFindCellNode *node = [[XFFindCellNode alloc] initWithModel:self.inviteDatas[indexPath.row]];
                node.delegate = self;
                node.index = indexPath;
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        node.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            node.neverShowPlaceholders = NO;
                            
                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                            
                            [self.indexPathsTobeReload removeObjectAtIndex:index];
                            
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
