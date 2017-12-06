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

#define kHomeHeaderHeight (15 + 15 + 17 + 210 + 15 + 100 + 15 + 15 + 17)
#define kSecondHeaderHeight (195 + 15 + 17 + 15)

@interface XFHomeViewController () <ASTableDelegate,ASTableDataSource,UICollectionViewDelegateFlowLayout,XFHomeSectionHeaderDelegate,XFHomeNodedelegate,CLLocationManagerDelegate,XFNearbyCellNodeDelegate>

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,weak) UIButton *whButton;

@property (nonatomic,weak) UIButton *yyButton;

@property (nonatomic,weak) UIButton *spButton;

@property (nonatomic,weak) UIView *titleView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) ASTableNode *tableNode;

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
@property (nonatomic,copy) NSArray *whData;
@property (nonatomic,copy) NSArray *yyData;
@property (nonatomic,copy) NSArray *videoData;

// 所有View数组
@property (nonatomic,copy) NSArray *allMainViews;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation XFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";

    [self setupNavigationbar];
    
    [self setupVideos];

    [self setupTableNode];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeHomeViewVIsiable) name:@"ChangeHomePAgeVisiable" object:nil];
    
    [self getLocation];
    
    self.allMainViews = @[self.loadFaildView,self.tableNode.view,self.netHotVC.view,self.actorVC.view,self.videoVC.view];
    
    [self.view setNeedsUpdateConstraints];

    
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
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    [self.positionButton setTitle:@"正在定位" forState:(UIControlStateNormal)];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        [self.CLManager requestWhenInUseAuthorization];
        
    }
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位不可用" message:@"请开启定位权限" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    
    // 请求授权
    if ([self.CLManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.CLManager requestAlwaysAuthorization];
    }
    
    // 调用代理方法
    [self.CLManager startUpdatingLocation];
}

#pragma mark - locationDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // 用户位置对象
    CLLocation *location = [locations lastObject];
//    CLLocationCoordinate2D coordinate = location.coordinate;
    
//
//    self.longitute = [NSNumber numberWithDouble:coordinate.longitude];
//    self.latitude = [NSNumber numberWithDouble:coordinate.latitude];

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
    
    [self getLocation];
    
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
    
    [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_equalTo(sender);
        make.height.mas_equalTo(2);
    }];

    [UIView animateWithDuration:0.2 animations:^{
        [self.titleView layoutIfNeeded];
        

        
    }];
    
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
//                self.actorVC.view.hidden = YES;
//                self.netHotVC.view.hidden = NO;
//                self.videoVC.view.hidden = YES;
//                [self changeStateWithShowView:self.netHotVC.view];
                [self.scrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];

            }
            break;
            case 1002:
        {
            self.tableNode.hidden = YES;
//            self.actorVC.view.hidden = NO;
//            self.netHotVC.view.hidden = YES;
//            self.videoVC.view.hidden = YES;
//            [self changeStateWithShowView:self.actorVC.view];
            [self.scrollView setContentOffset:(CGPointMake(kScreenWidth, 0)) animated:YES];


        }
            break;
            case 1003:
        {
            self.tableNode.hidden = YES;
//            self.actorVC.view.hidden = YES;
//            self.netHotVC.view.hidden = YES;
//            self.videoVC.view.hidden = NO;
//            [self changeStateWithShowView:self.videoVC.view];
            [self.scrollView setContentOffset:(CGPointMake(kScreenWidth*2, 0)) animated:YES];


        }
            break;

        default:
            break;
    }
    
    
}
#pragma mark - notification
- (void)changeHomeViewVIsiable {
    
    self.tableNode.hidden = NO;
    self.scrollView.hidden = YES;
//    self.actorVC.view.hidden = YES;
//    self.netHotVC.view.hidden = YES;
//    self.videoVC.view.hidden = YES;
//    [self changeStateWithShowView:self.tableNode.view];
//    [self.scrollView setContentOffset:(CGPointMake(kScreenWidth*2, 0)) animated:YES];


    // titleView初始化
    self.slideView.hidden = YES;
    for (UIButton *button in self.titleButtons) {
        
        button.selected = NO;
    }
    
    // 固定tabbar的位置
    if (self.tableNode.view.contentOffset.y > 0 && self.tableNode.view.contentOffset.y < 200) {
        
        CGFloat progress = self.tableNode.view.contentOffset.y / 200.f;
        
        
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = kScreenHeight-49 + progress * 49;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.tabBarController.tabBar.frame = frame;

        }];
        
    }
    
    if (self.tableNode.view.contentOffset.y >= 200) {
        
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = kScreenHeight;
        [UIView animateWithDuration:0.2 animations:^{
            
            self.tabBarController.tabBar.frame = frame;
            
        }];
    }
    
    if (self.tableNode.view.contentOffset.y <= 0) {
        
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = kScreenHeight - 49;
        [UIView animateWithDuration:0.2 animations:^{
            
            self.tabBarController.tabBar.frame = frame;
            
        }];
        
    }
    
}

- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    
    self.tableNode.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.view.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 190/375.f*kScreenWidth))];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_T1"]];
    
    headerImg.frame = header.bounds;
    
    [header addSubview:headerImg];
    
    self.tableNode.view.tableHeaderView = header;
    
    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loaddata];
        
    }];
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
//        // 隐藏tabbar
//        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 200) {
//
//            CGFloat progress = scrollView.contentOffset.y / 200.f;
//
//            CGRect frame = self.tabBarController.tabBar.frame;
//            frame.origin.y = kScreenHeight-49 + progress * 49;
//
//            self.tabBarController.tabBar.frame = frame;
//
//        }
//
//        if (scrollView.contentOffset.y >= 200) {
//
//            CGRect frame = self.tabBarController.tabBar.frame;
//            frame.origin.y = kScreenHeight;
//            self.tabBarController.tabBar.frame = frame;
//        }
//
//        if (scrollView.contentOffset.y <= 0) {
//
//            CGRect frame = self.tabBarController.tabBar.frame;
//            frame.origin.y = kScreenHeight - 49;
//            self.tabBarController.tabBar.frame = frame;
//
//        }
        
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
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer];
    

    if (node.likeNode.selected) {
        
        [self.selectedIndexs addObject:indexPath];

    } else {
        
        [self.selectedIndexs removeObject:indexPath];

    }
    
}


#pragma mark - tableNodeDelegate
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        
        XFNearbyViewController *nearVC = [[XFNearbyViewController alloc] init];
        nearVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nearVC animated:YES];
        
    } else {
        
        // 查看详情
        XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
        
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    

}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 3;
    
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 2:
        {
            
            return ^ASCellNode *() {
                
                XFHomeNearNode *node = [[XFHomeNearNode alloc] init];
                
                node.delegate = self;
                
                return node;
            };
            
        }
            break;
            
        default:
        {
            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                
                XFHomeTableNode *node = [[XFHomeTableNode alloc] init];
                
                node.cornerRadius = 10;
                node.clipsToBounds = YES;
                
                switch (indexPath.section) {
                    case 0:
                    {
                        
                        node.shadowNode.image = [UIImage imageNamed:@"overlay-zise"];
                        node.picNode.defaultImage = [UIImage imageNamed:[XFIconmanager sharedManager].homeImages[indexPath.item%2]];
                        
                    }
                        break;
                    case 1:
                    {
                        
                        node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
                        node.picNode.defaultImage = [UIImage imageNamed:kRandomPic];

                    }
                        break;
                        
                    default:
                        break;
                }
                
                node.delegate = self;
                
                if ([self.selectedIndexs containsObject:indexPath]) {
                    
                    node.likeNode.selected = YES;
                } else {
                    
                    node.likeNode.selected = NO;

                }
                
                return node;
            };
            return cellNodeBlock;
        }
            break;
    }
    

    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        
        XFHomeTableNode *node = [[XFHomeTableNode alloc] init];
        
        return node;
    };
    return cellNodeBlock;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XFHomeSectionHeader *header = [[XFHomeSectionHeader alloc] init];
    
    header.backgroundColor = [UIColor whiteColor];
    
    switch (section) {
        case 0:
        {
            
            header.titleLabel.text = @"新晋网红";
            
        }
            break;
        case 1:
        {
            
            header.titleLabel.text = @"新晋演员";
            
        }
            break;
        case 2:
        {
            
            header.titleLabel.text = @"附近的人";
            
        }
            break;
        default:
            break;
    }
    
    header.section = section;
    header.delegate = self;
    
    return header;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return 1;
    } else {
        
        return 2;
    }
    
    
    return 4;
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
    
    [@[whButton,yyButton,spButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
        
    }];
    
    self.slideView = [[UIView alloc] init];
    self.slideView.backgroundColor = kMainColor;
    self.slideView.hidden = YES;
    
    self.whButton = whButton;
    self.yyButton = yyButton;
    self.spButton = spButton;
    
    self.titleView = titleView;

//    [self.titleView addSubview:self.whButton];
//    [self.titleView addSubview:self.yyButton];
//    [self.titleView addSubview:self.spButton];
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
    UIButton *searchButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 20, 20))];
    
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
    [self addChildViewController:self.netHotVC];
    
    [self.scrollView addSubview:self.netHotVC.view];
    
    self.actorVC = [[XFNetHotViewController alloc] init];
    self.actorVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.actorVC.type = XFNetHotVCTypeWh;

    [self addChildViewController:self.actorVC];
    
    [self.scrollView addSubview:self.actorVC.view];
    
    self.videoVC = [[XFVideoViewController alloc] init];
    self.videoVC.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 64 - 49);

    __weak typeof(self) weakSelf = self;
    self.videoVC.selectedCellBlock = ^{
      
        XFVideoDetailViewController *videoDetailVC = [[XFVideoDetailViewController alloc] init];
        
        videoDetailVC.hidesBottomBarWhenPushed = YES;
        
        videoDetailVC.type = weakSelf.videoVC.videoType;
        
        [weakSelf.navigationController pushViewController:videoDetailVC animated:YES];
        
        
    };
    
    [self addChildViewController:self.videoVC];
    [self.scrollView addSubview:self.videoVC.view];
    

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
        make.right.mas_equalTo(self.yyButton.mas_left);
    }];
    
    [self.spButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.yyButton.mas_right);
        make.width.mas_equalTo(60);
        make.right.mas_offset(0);
        make.top.bottom.mas_offset(0);
        
    }];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_offset(0);
        make.width.mas_equalTo(35);
        make.centerX.mas_equalTo(self.whButton);
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
