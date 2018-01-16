//
//  XFHomeViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeViewController.h"
#import "XFOutsideButtonView.h"
#import "XFHomeTopHeaderReusableView.h"
#import "XFHomeCollectionViewCell.h"
#import "XFHomeSecondReusableView.h"

#import "XFActorViewController.h"
#import "XFNetHotViewController.h"
#import "XFVideoViewController.h"
#import "XFHomeTableNode.h"
#import "XFHomeSectionHeader.h"
#import "XFHomeNearNode.h"
#import <CoreLocation/CoreLocation.h>
#import "XFLoginVCViewController.h"
#import "XFSearchViewController.h"
#import "XFFindDetailViewController.h"
#import "XFNearbyViewController.h"
#import <AFHTTPSessionManager.h>
#import "XFStatusDetailViewController.h"
#import "XFVideoDetailViewController.h"
#import "XFHomeCacheManger.h"
#import "XFYwqAlertView.h"
#import "SDCycleScrollView.h"
#import "XFHomeNetworkManager.h"
#import "XFMyAuthViewController.h"
#import "XFMineNetworkManager.h"
#import "XFMineNetworkManager.h"
#import "XFHomeDataParamentModel.h"

#define kHomeHeaderHeight (15 + 15 + 17 + 210 + 15 + 100 + 15 + 15 + 17)
#define kSecondHeaderHeight (195 + 15 + 17 + 15)

@interface XFHomeViewController () <ASTableDelegate,ASTableDataSource,UICollectionViewDelegateFlowLayout,XFHomeSectionHeaderDelegate,XFHomeNodedelegate,CLLocationManagerDelegate,XFNearbyCellNodeDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,weak) UIButton *whButton;

@property (nonatomic,weak) UIButton *yyButton;

@property (nonatomic,weak) UIButton *spButton;

@property (nonatomic,weak) UIView *titleView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,weak) SDCycleScrollView *headScroll;

@property (nonatomic,strong) NSMutableArray *selectedIndexs;
//@property (nonatomic,strong) XFActorViewController *actorVC;

@property (nonatomic,strong) XFNetHotViewController *actorVC;
@property (nonatomic,strong) XFNetHotViewController *netHotVC;
@property (nonatomic,strong) XFVideoViewController *videoVC;

// 定位
@property (nonatomic,strong) CLLocationManager *CLManager;

@property (nonatomic, strong) CLGeocoder *geoC;
// 位置按钮
@property (nonatomic,weak) UIButton *positionButton;

// 数据
@property (nonatomic,copy) NSArray *homeData;
@property (nonatomic,copy) NSArray *ywData;
@property (nonatomic,copy) NSArray *whData;
@property (nonatomic,copy) NSArray *videoData;

// 所有View数组
@property (nonatomic,copy) NSArray *allMainViews;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,copy) NSArray *adDatas;

@property (nonatomic,copy) NSArray *authList;

// 第一层
@property (nonatomic,copy) NSArray *model;
// 第二层

// 第三层


@end

@implementation XFHomeViewController


- (instancetype)init {
    
    if (self = [super init]) {
        

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";

    self.ywData = [XFHomeCacheManger sharedManager].ywData;
    self.whData = [XFHomeCacheManger sharedManager].whData;
    self.videoData = [XFHomeCacheManger sharedManager].videoData;

    [self setupTableNode];

    [self setupNavigationbar];
    
    [self setupVideos];

    [self network];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeHomeViewVIsiable) name:@"ChangeHomePAgeVisiable" object:nil];
    
    [self getLocation];
    
    [self.view setNeedsUpdateConstraints];
    

    
}

- (void)network {
    
    // 获取广告
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadAdData];
    }];
    // 获取认证信息列表
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadAuthData];
    }];

    // 获取首页数据
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadHomeData];
    }];
    
    //设置依赖
    [operation3 addDependency:operation2];      //任务3依赖任务2
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
    
}

- (void)loadNearData {
    
    [XFHomeNetworkManager getNearbyDataWithSex:@"male" longitude:[XFUserInfoManager sharedManager].userLong latitude:[XFUserInfoManager sharedManager].userLati distance:1000 page:0 size:10 successBlock:^(id responseObj) {
        
        
        // 成功之后
//        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:(UITableViewRowAnimationFade)];
        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)loadHomeData {
    
    [XFHomeNetworkManager getHomeDataWithSuccessBlock:^(id responseObj) {
    
        NSArray *datas = (NSArray *)responseObj;
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0 ; i < datas.count ; i ++ ) {
            
            NSDictionary *dic = datas[i];
            XFHomeDataParamentModel *paramentModel = [[XFHomeDataParamentModel alloc] init];
            paramentModel.categoryTitle = dic[@"categoryTitle"];
            NSArray *modelDatas  = dic[@"data"];
            NSMutableArray *mutarr = [NSMutableArray array];
            for (int j= 0 ; j < modelDatas.count ; j ++ ) {
                
                [mutarr addObject:[XFHomeDataModel modelWithDictionary:modelDatas[j]]];
            }
            paramentModel.data = mutarr.copy;
            [arr addObject:paramentModel];
        }
        
        self.homeData = arr.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableNode reloadData];

            [self.tableNode.view.mj_header endRefreshing];
        });
        
        
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableNode.view.mj_header endRefreshing];
        });
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)loadAuthData {
    
    // 信号量控制必须获取认证数据
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    // 加载认证信息
    [XFMineNetworkManager getDefineListWithsuccessBlock:^(id responseObj) {

        NSArray *datas = (NSArray *)responseObj;
        YYCache *authCache = [YYCache cacheWithName:kAuthCache];
        [authCache setObject:datas forKey:kAuthList];

        [[XFAuthManager sharedManager] authList];
        
        dispatch_semaphore_signal(sema);

    } failedBlock:^(NSError *error) {
       dispatch_semaphore_signal(sema);

    } progressBlock:^(CGFloat progress) {
        
        
    }];
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
}

- (void)loadAdData {
    
    [XFHomeNetworkManager getHomeAdWithSuccessBlock:^(id responseObj) {
        
        NSArray *datas = (NSArray *)responseObj;
        self.adDatas = datas;
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:datas[i][@"image"][@"thumbImage500pxUrl"]];
            
        }
        self.headScroll.imageURLStringsGroup = arr.copy;
        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.tableNode.hidden = YES;
//    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
//
//    [self.tableNode reloadDataWithCompletion:^{
//
//        [HUD hideAnimated:YES];
//
//        self.tableNode.hidden = NO;
//
//    }];
//
//
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
}

- (void)viewWillLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
}

- (void)loaddata {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableNode.view.mj_header endRefreshing];

    });
    
}

// 加载数据状态更改
- (void)changeStateWithShowView:(UIView *)view  {
    
    // 取消存在的网络请求
    
    
    // 判断数据是否为空---为空时进行网络请求---不为空时不请求,直接展示
    
    
    // 请求网络,成功展示,失败展示失败view
    
    UIActivityIndicatorView *indicatorView = [XFToolManager showIndicatorViewTo:self.view];
    view.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [indicatorView stopAnimating];
        view.hidden = NO;

    });
    
}

- (void)changeStateToLoadFailed {
    
    self.loadFaildView.hidden = YES;
    self.tableNode.hidden = YES;
    
    UIActivityIndicatorView *indicatorView = [XFToolManager showIndicatorViewTo:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.loadFaildView.hidden = YES;
        self.tableNode.hidden = NO;
        [indicatorView stopAnimating];
        
    });
}

// 点击搜索
- (void)clickSearchButton {
    
    XFSearchViewController *searchVC = [[XFSearchViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:navi animated:NO completion:nil];
    
}


// 定位
- (void)getLocation {
    
    self.CLManager = [[CLLocationManager alloc] init];
    self.CLManager.delegate = self;
    self.CLManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.CLManager.pausesLocationUpdatesAutomatically = YES;
    
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    [self.positionButton setTitle:@"正在定位" forState:(UIControlStateNormal)];
    
    if ([self.CLManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [self.CLManager requestAlwaysAuthorization];
        
    }

    if (status == kCLAuthorizationStatusNotDetermined) {
        
        [self.CLManager requestWhenInUseAuthorization];
        
    }
    // 调用代理方法
    [self.CLManager startUpdatingLocation];
}

#pragma mark - locationDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
//    self.CLManager.allowsBackgroundLocationUpdates = YES;
//    [self.CLManager allowDeferredLocationUpdatesUntilTraveled:100 timeout:10];
    // 用户位置对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    [XFUserInfoManager sharedManager].userLong = coordinate.longitude;
    [XFUserInfoManager sharedManager].userLati = coordinate.latitude;

    // 更新位置
    
    if ([XFUserInfoManager sharedManager].userName) {
        
        [XFHomeNetworkManager refreshUserLocationWithlon:coordinate.longitude lat:coordinate.latitude successBlock:^(id responseObj) {
            
        } failBlock:^(NSError *error) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    [self loadNearData];

    
    _geoC = [[CLGeocoder alloc] init];

    [_geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            
            NSString *city = pl.locality;
            
            [self.positionButton setTitle:city forState:(UIControlStateNormal)];
            
            

        }else
        {
            NSLog(@"错误");
        }
        
    }];
    
    [manager stopUpdatingLocation];
    
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        [XFToolManager showProgressInWindowWithString:@"定位出错,请检查GPS状态"];
    }
}

#pragma mark - 点击位置按钮重新获取位置
- (void)clickPositionButton {
    
    // 判断定位状态
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位不可用" message:@"请开启定位权限" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        
        [self getLocation];

    }
    
    
}

#pragma mark - headerDelegate
- (void)homeSectionHeader:(XFHomeSectionHeader *)header didClickButton:(UIButton *)moreButton atSection:(NSInteger )section {
    
    // 点击更多按钮
    
    switch (section) {
            
        case 0:
        {
            [self clickTopButton:self.whButton];
        }
            break;
            
        case 1:
        {
            [self clickTopButton:self.yyButton];
        }
            break;
        case 2:
        {
            XFNearbyViewController *nearVC = [[XFNearbyViewController alloc] init];
            
            nearVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:nearVC animated:YES];
            
        }
            break;
            
    }
    
    
}

- (void)clickTopButton:(UIButton *)sender {
    
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = kScreenHeight - 49;
    self.tabBarController.tabBar.frame = frame;
    
    CGFloat centerOffset = 0;
    
    if (sender == _whButton) {
        
        centerOffset = -60;
        

    
    }
    if (sender == _yyButton) {
        
        centerOffset = 0;
        

    }
    
    if (sender == _spButton) {
        
        centerOffset = 60;
        
    }
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    

//    [UIView animateWithDuration:0.2 animations:^{
//        [self.titleView layoutIfNeeded];
//
//
//
//    }];
    
    if (self.slideView.hidden == YES) {
        
        self.slideView.hidden = NO;
    }
    
    for (UIButton *button in self.titleButtons) {
        
        if (sender == button) {
            
            button.selected = YES;
            
        } else {
            
            button.selected = NO;
        }
    }
    
    self.scrollView.hidden = NO;

    
    switch (sender.tag) {
            case 1001:
            {
                self.tableNode.hidden = YES;

                [self.scrollView setContentOffset:(CGPointMake(0, 0)) animated:NO];
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [self.netHotVC firstLoadData];
                    
                });

            }
            break;
            case 1002:
        {
            self.tableNode.hidden = YES;

            [self.scrollView setContentOffset:(CGPointMake(kScreenWidth, 0)) animated:NO];
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.actorVC firstLoadData];
                
            });
        }
            break;
            case 1003:
        {
            self.tableNode.hidden = YES;

            [self.scrollView setContentOffset:(CGPointMake(kScreenWidth*2, 0)) animated:NO];
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.videoVC loadData];
                
            });

        }
            break;

        default:
            break;
    }
    
    
}

#pragma mark - headerScrollDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 活动页面
    [self tapHeaderAdView];
    
}

#pragma mark - notification
- (void)changeHomeViewVIsiable {
    
    self.tableNode.hidden = NO;
    self.scrollView.hidden = YES;
    // titleView初始化
    self.slideView.hidden = YES;
    for (UIButton *button in self.titleButtons) {
        
        button.selected = NO;
    }
    
}
#pragma mark - 初始化
- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    
    self.tableNode.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.view.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 190/375.f*kScreenWidth))];
    
    SDCycleScrollView *headerScroll = [SDCycleScrollView cycleScrollViewWithFrame:header.bounds imageNamesGroup:@[@"home21",@"home21",@"home21"]];
    
    headerScroll.delegate = self;
    headerScroll.contentMode = UIViewContentModeScaleAspectFill;
    [header addSubview:headerScroll];

    self.headScroll = headerScroll;
    self.tableNode.view.tableHeaderView = header;
    
    self.tableNode.view.tableFooterView = [[UIView alloc] init];
    
    [self.tableNode layoutIfNeeded];
    
    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self network];
        
    }];
}

#pragma mark - headerTap
- (void)tapHeaderAdView {

    // 进入广告推荐页面
//    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
//    
//    detailVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - nearbydelegate
- (void)homeNearNode:(XFHomeNearNode *)nearnode didClickNodeWithindexPath:(NSIndexPath *)indexPath {

    XFNearbyViewController *nearVC = [[XFNearbyViewController alloc] init];
    
    nearVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nearVC animated:YES];
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //竖直滑动时 判断是上滑还是下滑
    if(velocity.y>0){
        //上滑
        [UIView animateWithDuration:0.15 animations:^{
            
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
            
        }];
    }else{
        //下滑
        [UIView animateWithDuration:0.15 animations:^{
            
            self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
            
        }];
    }
    
}

//去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableNode.view) {
        
        CGFloat sectionHeaderHeight = 47;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        
        
    }
    
    
    
}

#pragma mark - cellDelegate
- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath {

    node.likeNode.selected = !node.likeNode.selected;
    // 弹性动画
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer complate:^{
        
        
    }];
    
    XFHomeDataModel *model = self.homeData[indexPath.section][indexPath.row];
    
    model.isLiked = [model.isLiked intValue] == 0 ? @"1" : @"0";
    NSString *liked = [NSString stringWithFormat:@"%zd",[model.likeNumer intValue] + 1] ;
    NSString *unLiked = [NSString stringWithFormat:@"%zd",[model.likeNumer intValue] - 1] ;
    
    model.likeNumer = node.likeNode.selected ? liked : unLiked;
    
    [node.likeNode setTitle:model.likeNumer withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];


}


#pragma mark - tableNodeDelegate
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        XFNearbyViewController *nearVC = [[XFNearbyViewController alloc] init];
        nearVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nearVC animated:YES];
        
    } else {

        NSInteger index = indexPath.section < 2 ? indexPath.section : indexPath.section - 1;
        
        XFHomeDataParamentModel *paModel = self.homeData[index];
        XFHomeDataModel *model = paModel.data[indexPath.row];
        
        // 查看详情
        XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
        detailVC.userId = model.uid;
        detailVC.userName = model.nickname;
        detailVC.iconUrl = model.headIconUrl;
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    

}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return self.homeData.count + 1;
    
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 2:
        {
            
            XFHomeNearNode *node = [[XFHomeNearNode alloc] init];
            
            node.delegate = self;
            
            return node;
            
        }
            break;
            
        default:
        {
            NSInteger index = indexPath.section < 2 ? indexPath.section : indexPath.section - 1;
            
            XFHomeDataParamentModel *paModel = self.homeData[index];
            XFHomeDataModel *model = paModel.data[indexPath.row];
            
            XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:model];
            
            node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
            
            node.delegate = self;
            
            node.neverShowPlaceholders = YES;
            
            return node;
            
        }
            break;
    }
    
    return nil;
    
}

//- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    switch (indexPath.section) {
//        case 2:
//        {
//
//            return ^ASCellNode *() {
//
//                XFHomeNearNode *node = [[XFHomeNearNode alloc] init];
//
//                node.delegate = self;
//
//                return node;
//            };
//
//        }
//            break;
//
//        case 0:{
//
//            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
//
//                XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:self.homeData[0][indexPath.row]];
//
//                node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
//
//                node.delegate = self;
//
//                return node;
//            };
//
//            return cellNodeBlock;
//        }
//            break;
//
//        case 1:
//        {
//            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
//
//                XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:self.homeData[1][indexPath.row]];
//
//                node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
//
//                node.delegate = self;
//
//                return node;
//            };
//
//            return cellNodeBlock;
//        }
//            break;
//        default:
//        {
//            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
//
//                XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:self.homeData[3][indexPath.row]];
//
//                node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
//
//                node.delegate = self;
//
//                return node;
//            };
//
//            return cellNodeBlock;
//        }
//            break;
//    }
//
//
//    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
//
//        XFHomeTableNode *node = [[XFHomeTableNode alloc] init];
//
//        return node;
//    };
//    return cellNodeBlock;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XFHomeSectionHeader *header = [[XFHomeSectionHeader alloc] init];
    
    header.backgroundColor = [UIColor whiteColor];
    
    if (section == 2) {
        
        header.titleLabel.text = @"附近的人";
        
    } else {
        
        NSInteger index = section < 2 ? section : section - 1;
        
        XFHomeDataParamentModel *paModel = self.homeData[index];
        
        header.titleLabel.text = paModel.categoryTitle;
    }
    
    header.section = section;
    header.delegate = self;
    
    return header;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return 1;
    } else {
        
        NSInteger index = section < 2 ? section : section - 1;
        
        XFHomeDataParamentModel *paModel = self.homeData[index];
        
        return paModel.data.count;
    }
    
    return 0;
}


- (void)setupNavigationbar {
    // titleView
    UIView *titleView = [[UIView alloc] init];
    
    titleView.frame = CGRectMake(0, 0, 180, 44);
    
    self.navigationItem.titleView = titleView;
    
    if (@available (iOS 11 , *)) {
    
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        
    }
    
    UIButton *whButton = [[UIButton alloc] init];
    
    [whButton setTitle:@"尤物" forState:(UIControlStateNormal)];
    
    [whButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [whButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    whButton.titleLabel.font = [UIFont systemFontOfSize:16];
    whButton.tag = 1001;
    [titleView addSubview:whButton];
    
    UIButton *yyButton = [[UIButton alloc] init];
    
    [yyButton setTitle:@"网红" forState:(UIControlStateNormal)];
    
    [yyButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [yyButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    yyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    yyButton.tag = 1002;
    [titleView addSubview:yyButton];
    
    UIButton *spButton = [[UIButton alloc] init];
    
    [spButton setTitle:@"视频" forState:(UIControlStateNormal)];
    
    [spButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [spButton setTitleColor:kMainColor forState:(UIControlStateSelected)];
    spButton.titleLabel.font = [UIFont systemFontOfSize:16];
    spButton.tag = 1003;
    [titleView addSubview:spButton];
    

    
    self.slideView = [[UIView alloc] init];
    self.slideView.backgroundColor = kMainColor;
    self.slideView.hidden = YES;
    
    self.whButton = whButton;
    self.yyButton = yyButton;
    self.spButton = spButton;
    
    self.titleView = titleView;

    [self.titleView addSubview:self.slideView];
    self.titleButtons = @[self.whButton,self.yyButton,self.spButton];
    
    [self.whButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.yyButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.spButton addTarget:self action:@selector(clickTopButton:) forControlEvents:(UIControlEventTouchUpInside)];

    // 位置按钮
    UIButton *positionButton = [[UIButton alloc] initWithFrame:(CGRectMake(-25, 0, 85, 30))];
    
    [positionButton setTitle:@"位置" forState:(UIControlStateNormal)];
    [positionButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [positionButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [positionButton setImage:[UIImage imageNamed:@"home_position"] forState:(UIControlStateNormal)];
    positionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    positionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [positionButton addTarget:self action:@selector(clickPositionButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.positionButton = positionButton;
    
    XFOutsideButtonView *outsideView = [[XFOutsideButtonView alloc] initWithFrame:(CGRectMake(0, 0, 60, 30))];
    
    [outsideView addSubview:positionButton];
    
    outsideView.outsideButton = positionButton;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:outsideView];
    
    // searchButton
    UIButton *searchButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 40))];
    
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    
    [searchButton setImage:[UIImage imageNamed:@"home_search"] forState:(UIControlStateNormal)];
    
    [searchButton addTarget:self action:@selector(clickSearchButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];

}

- (void)setupVideos {
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView removeGestureRecognizer:self.scrollView.panGestureRecognizer];
    [self.view addSubview:self.scrollView];
    
    self.netHotVC = [[XFNetHotViewController alloc] init];
    self.netHotVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.netHotVC.type = XFNetHotVCTypeYW;
    self.netHotVC.datas = self.ywData;
    [self addChildViewController:self.netHotVC];
    
    [self.scrollView addSubview:self.netHotVC.view];
    
    self.actorVC = [[XFNetHotViewController alloc] init];
    self.actorVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.actorVC.type = XFNetHotVCTypeWh;
    self.actorVC.datas = self.whData;
    [self addChildViewController:self.actorVC];
    
    [self.scrollView addSubview:self.actorVC.view];
    
    self.videoVC = [[XFVideoViewController alloc] init];
    self.videoVC.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 64 - 49);

    __weak typeof(self) weakSelf = self;
    
    self.videoVC.selectedCellBlock = ^(XFVideoModel *videoModel) {
    
        XFVideoDetailViewController *videoDetailVC = [[XFVideoDetailViewController alloc] init];
        
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        
        videoDetailVC.type = weakSelf.videoVC.videoType;
        
        videoDetailVC.model = videoModel;
        
        [weakSelf.navigationController pushViewController:videoDetailVC animated:YES];
    };

    [self addChildViewController:self.videoVC];
    [self.scrollView addSubview:self.videoVC.view];
    
    self.scrollView.hidden = YES;
}


- (void)updateViewConstraints {
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
        
    }];
    
    [self.yyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
        
    }];
    
    [self.whButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(60);
        if (@available (ios 11, *)) {
            make.right.mas_equalTo(self.yyButton.mas_left);

        }
    }];
    
    [self.spButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available (ios 11, *)) {

            make.left.mas_equalTo(self.yyButton.mas_right);
        }
        make.width.mas_equalTo(60);
        make.right.mas_offset(0);
        make.top.bottom.mas_offset(0);
        
    }];
    
    [@[_whButton,_yyButton,_spButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
        
    }];
    
    
        CGFloat centerOffset = 0;
        
        if (_whButton.selected) {
            
            centerOffset = -60;
        }
        if (_yyButton.selected) {
            
            centerOffset = 0;
        }
        
        if (_spButton.selected) {
            
            centerOffset = 60;
        }

    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_offset(centerOffset);
        make.height.mas_equalTo(2);
    }];
    
    [super updateViewConstraints];
}

- (NSMutableArray *)selectedIndexs {
    
    if (_selectedIndexs == nil) {
        _selectedIndexs = [NSMutableArray array];
    }
    return _selectedIndexs;
}

@end
