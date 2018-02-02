//
//  XFSearchViewController.m
//  HuiShang
//
//  Created by mr.zhou on 2017/9/11.
//  Copyright © 2017年 lhn. All rights reserved.
//

#import "XFSearchViewController.h"
#import "XFHistoryCollectionViewCell.h"
#import "XFSearchBar.h"
#import "XFFindDetailViewController.h"
#import "XFFindCellNode.h"
#import "XFHomeNearNode.h"
#import "ASSearchManCellNode.h"
#import "XFNearbyViewController.h"
#import "XFStatusDetailCellNode.h"
#import "XFStatusDetailViewController.h"
#import "XFYwqAlertView.h"
#import "XFShareManager.h"
#import "XFFIndCacheManager.h"
#import "XFLoginNetworkManager.h"
#import "XFTagsModel.h"
#import "XFHomeNetworkManager.h"
#import "XFMineNetworkManager.h"
#import "FTPopOverMenu.h"
#import <AVKit/AVKit.h>
#import "XFAlertViewController.h"
#import "XFPayViewController.h"
#import "XFFindNetworkManager.h"
#import "LBPhotoBrowserManager.h"
#import "XFGiftViewController.h"

// 缓存历史记录
#import <YYCache.h>

@implementation XFSearchUserModel


@end

@implementation XFSearchDeleteHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"历史搜索";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_titleLabel];
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"search_delete"] forState:(UIControlStateNormal)];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_deleteButton];
        
        [self updateConstraints];
        
    }
    return self;
}

- (void)clickDeleteButton {
 
    self.clickDeleteButtonBlock();
}

- (void)updateConstraints {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.centerY.mas_offset(0);
        
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-10);
        make.centerY.mas_offset(0);
        
    }];
    
    [super updateConstraints];
}

@end

@implementation XFSearchHeader
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"热门搜索";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_titleLabel];
        
        [self updateConstraints];
        
    }
    return self;
}

- (void)updateConstraints {
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(10);
        make.centerY.mas_offset(0);
        
    }];
    [super updateConstraints];
}
@end


@interface XFSearchViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,ASTableDelegate,ASTableDataSource,XFHomeNodedelegate,XFFindCellDelegate>

@property (nonatomic,strong) UICollectionView *historyView;

@property (nonatomic,copy) NSArray *titleArr;

@property (nonatomic,strong) XFSearchBar *searchBar;

@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,strong) UILabel *desLabel;

@property (nonatomic,strong) UITableView *resultView;

@property (nonatomic,copy) NSArray *resultDatas;

@property (nonatomic,copy) NSArray *hotDatas;

@property (nonatomic,strong) NSMutableArray *historyArr;

@property (nonatomic,strong) ASTableNode *resultNode;

@property (nonatomic,strong) UIGestureRecognizer *tapWindow;

@property (nonatomic,strong) NSMutableArray *historyData;
// 缓存数据
@property (nonatomic,strong) YYCache *historyCache;

@property (nonatomic,strong) NSIndexPath *isOpenIndexPath;

@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,copy) NSArray *userDatas;

@property (nonatomic,assign) BOOL isPlaying;

@property (nonatomic,strong) NSURL *voiceUrl;

@property (nonatomic,strong) AVPlayer *audioPLayer;

@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,copy) NSString *keyWord;

@property (nonatomic,strong) NSMutableArray *indexPathsTobeReload;

@end
@implementation XFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 设置取消按钮
    [self setupSearchBar];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickCancelButton)];
    // 历史记录
    [self setuphistoryView];
    
    [self setupResultView];

    [self getHistoryData];
    
    [self.view setNeedsUpdateConstraints];
    
    [self loadData];

}

- (void)reloadData {
    
    _indexPathsTobeReload = [NSMutableArray array];
    
    NSArray *cells = self.resultNode.visibleNodes;
    
    for (ASCellNode *node in cells) {
        
        if ([node isKindOfClass:[XFFindCellNode class]]) {
            
            [_indexPathsTobeReload addObject:node.indexPath];
            
        }
        
    }
    
    [self.resultNode reloadDataWithCompletion:^{
        
        _indexPathsTobeReload = [NSMutableArray array];
        
    }];
    
    
}

- (void)loadData {
    
    // 获取标签
    [XFLoginNetworkManager getAllTagsWithprogress:^(CGFloat progress) {
        
        
    } successBlock:^(id responseObj) {
        
        

        
    } failBlock:^(NSError *error) {
        
    }];
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];

    [XFHomeNetworkManager getSearchKeyWorkWithsuccessBlock:^(id responseObj) {
        [HUD hideAnimated:YES];
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        

        self.titleArr = datas.copy;
        
        [self.historyView reloadData];
    } failBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
    }];

    
}

- (void)getHistoryData {
    
    if ([self.historyCache containsObjectForKey:kSearchHistoryKey]) {
        
        NSArray *historyDatas = (NSArray *)[self.historyCache objectForKey:kSearchHistoryKey];
        
        [self.historyArr addObjectsFromArray:historyDatas];
        
        [self.historyView reloadData];
    }
    
}

- (void)beginSearchWithtext:(NSString *)text {

    self.keyWord = text;
    
    self.page = 0;
    
    [XFHomeNetworkManager searchUsersWithword:text Page:0 size:20 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < datas.count ; i++) {
            
            [arr addObject:[XFSearchUserModel modelWithDictionary:datas[i]]];
            
        }
        
        self.userDatas = arr.copy;
        
        [self.resultNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        
        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
    [XFHomeNetworkManager searchPublishsWithword:text Page:self.page size:10 successBlock:^(id responseObj) {
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i= 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFStatusModel modelWithDictionary:datas[i]]];
        }
        
        self.datas = arr;

//        [self.resultNode reloadData];
        
        [self reloadData];
        
        [self.searchBar resignFirstResponder];
        self.historyView.hidden = YES;
        self.resultNode.hidden = NO;
        
        // 储存搜索历史记录
        if (![self.historyArr containsObject:text]) {
            
            [self.historyArr addObject:text];
            if (self.historyArr.count > 6) {
                
                [self.historyArr removeObjectAtIndex:0];
                
            }
            //        [self.historyView reloadData];
            
            [self.historyCache setObject:self.historyArr forKey:kSearchHistoryKey];

        }


        
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
    

    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    });
    

}

- (void)loadMoreResult {
    
    self.page += 1;
    
    [XFHomeNetworkManager searchPublishsWithword:self.keyWord Page:self.page size:10 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i= 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFStatusModel modelWithDictionary:datas[i]]];
        }
        
        [self.datas addObjectsFromArray:arr.copy];
        
//        [self.resultNode reloadData];
        [self reloadData];
        [self.resultNode.view.mj_footer endRefreshing];
        
    } failBlock:^(NSError *error) {
        [self.resultNode.view.mj_footer endRefreshing];

    } progress:^(CGFloat progress) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.searchBar resignFirstResponder];
    
}

- (void)TapView {
    
    [self.searchBar resignFirstResponder];
}


- (void)clickCancelButton {
    
    [self.searchBar resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

- (void)deleteHistory {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除全部历史记录?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.historyArr = [NSMutableArray array];
        [self.historyCache setObject:@[] forKey:kSearchHistoryKey];
        [self.historyView.collectionViewLayout invalidateLayout];
        
        [self.historyView reloadData];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alert addAction:actionDone];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    XFStatusModel *model = self.datas[indexPath.row - 1];
    
    XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
    statusVC.hidesBottomBarWhenPushed = YES;
    statusVC.type = Other;
    statusVC.status = model;
    [self.navigationController pushViewController:statusVC animated:YES];
    
}

#pragma mark - cell代理方法
// 点击头像
- (void)homeNode:(XFHomeTableNode *)node didClickIconWithindex:(NSIndexPath *)indexPath {
    
    // 点击头像
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath {
    
    node.likeNode.selected = !node.likeNode.selected;
    // 弹性动画
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer complate:^{
        
        
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
    [self beginSearchWithtext:searchBar.text];

        
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    self.historyView.hidden = NO;
    self.resultNode.hidden = YES;
    
    return YES;
    
}

- (void)setupSearchBar {

    self.searchBar = [[XFSearchBar alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 44))];

    self.searchBar.delegate = self;

    self.searchBar.placeholder = @"搜索您感兴趣的内容和用户";
    self.searchBar.contentInset = UIEdgeInsetsMake(7, 15, 7, 60);
    UITextField *searchTextField = nil;

    searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = UIColorHex(0xffffff);
    searchTextField.font = [UIFont systemFontOfSize:12];
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.layer.borderColor = [UIColor blackColor].CGColor;
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.cornerRadius = 14.5;
    searchTextField.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {

        [[self.searchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];

    }

    self.navigationItem.titleView = self.searchBar;
    
    [self.searchBar becomeFirstResponder];
    
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        
        if (indexPath.section == 0) {
            
            if (self.historyArr.count > 0) {
                
                XFSearchDeleteHeader *delete = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deleteheader" forIndexPath:indexPath];
                
                delete.clickDeleteButtonBlock = ^{
                    
                    [self deleteHistory];
                    

                };
                
                return delete;

            } else {
                
                XFSearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                
                return header;
                
            }
            
        } else {
            XFSearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            return header;
            
        }
    }
    return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.historyArr.count > 0) {
        
        return 2;

    } else {
        
        return 1;
    }
    return 2;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_historyArr.count > 0) {
        
        if (section == 0) {
            
            return self.historyArr.count;

        } else {
            
            return self.titleArr.count;
        }
        
        
    }
    
    return self.titleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XFHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
    
    if (_historyArr.count > 0) {
        
        switch (indexPath.section) {
                
            case 0:
            {
                cell.titleLabel.text = self.historyArr[indexPath.item];
            }
                break;
            case 1:
            {
                NSDictionary *title = self.titleArr[indexPath.item];
                cell.titleLabel.text = title[@"word"];

            }
                break;
        }
    } else {
        
        NSDictionary *title = self.titleArr[indexPath.item];
        cell.titleLabel.text = title[@"word"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_historyArr.count > 0) {
        
        switch (indexPath.section) {
                
            case 0:
            {
                self.searchBar.text = self.historyArr[indexPath.item];
            }
                break;
            case 1:
            {
                NSDictionary *title = self.titleArr[indexPath.item];
                self.searchBar.text = title[@"word"];

            }
                break;
        }
    } else {
        
        NSDictionary *title = self.titleArr[indexPath.item];
        self.searchBar.text = title[@"word"];
        
    }
    
    [self beginSearchWithtext:self.searchBar.text];
    
}

- (void)setuphistoryView {

    //    UICollectionViewFlowLayout
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 0;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 0;
    // 3.设置item块的大小 (可以用于自适应)
//    layout.estimatedItemSize = CGSizeMake(20, 60);
    layout.itemSize = CGSizeMake((kScreenWidth - 20)/3, 45.5);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    // 设置item的内边距
    layout.sectionInset = UIEdgeInsetsMake(0,10,10,10);
    
    self.historyView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 50) collectionViewLayout:layout];
    self.historyView.backgroundColor = [UIColor whiteColor];
    self.historyView.delegate = self;
    self.historyView.dataSource = self;
    
    [self.historyView registerNib:[UINib nibWithNibName:@"XFHistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"history"];
    [self.historyView registerClass:[XFSearchHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.historyView registerClass:[XFSearchDeleteHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deleteheader"];

    _historyView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight-64);
    
    _historyView.allowsSelection = YES;
    
    [self.view addSubview:self.historyView];

}

- (void)setupResultView {
    
    self.resultNode = [[ASTableNode alloc] init];
    self.resultNode.delegate = self;
    self.resultNode.dataSource = self;
    self.resultNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.resultNode.view.showsVerticalScrollIndicator = NO;
    [self.view addSubnode:self.resultNode];
    
    if (@available (ios 11 , * )) {
        self.resultNode.view.estimatedRowHeight = 0;
        self.resultNode.view.estimatedSectionHeaderHeight = 0;
        self.resultNode.view.estimatedSectionFooterHeight = 0;
    }
    
    self.resultNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.resultNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.resultNode.hidden = YES;
    
    self.resultNode.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreResult];
        
    }];
}

#pragma mark - cellNodeDelegate点赞


- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 1;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count + 1;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.item == 0) {
        

            ASSearchManCellNode *node = [[ASSearchManCellNode alloc] initWithDatas:self.userDatas];
            
            node.didSelecSearchMan = ^(XFSearchUserModel *model) {
                
                XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
                detailVC.userId = model.uid;
                detailVC.userName = model.nickname;
                detailVC.iconUrl = model.headIconUrl;
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
            };
            
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
    
        XFFindCellNode *node = [[XFFindCellNode alloc] initWithModel:self.datas[indexPath.row -1]];
        
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

        if (self.isOpenIndexPath == indexPath) {
            node.shadowNode.hidden = YES;
            
        } else {
            node.shadowNode.hidden = NO;
        }
        
        return node;
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
                
                NSInteger index = [self.datas indexOfObject:status];

                [self.datas replaceObjectAtIndex:index withObject:model];
                [self.resultNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index + 1 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];

                
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
    
    XFStatusModel *model = node.model;

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
    XFStatusModel *model = node.model;

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
    
    XFStatusModel *model = node.model;

    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.userId = [NSString stringWithFormat:@"%@",model.user[@"uid"]];
    detailVC.userName = model.user[@"nickname"];
    detailVC.iconUrl = model.user[@"headIconUrl"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFStatusModel *model = node.model;

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
    
    XFStatusModel *model = node.model;

    
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
        
            NSInteger index = [self.datas indexOfObject:model];
            [self.resultNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index + 1 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
            node = [self.resultNode nodeForRowAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0]];

        
        [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{}];
        
    } failBlock:^(NSError *error) {
        
        
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}


- (void)refreshFollowStatusWithUid:(NSString *)uid witfFollowed:(BOOL)followed reload:(BOOL)reload {
    
    //    if (self.isInvite) {
    
    for (XFStatusModel *model in self.datas) {
        
        if ([model.user[@"uid"] intValue] == [uid intValue]) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.user];
            
            [dic setObject:@(followed) forKey:@"followed"];
            
            model.user = dic.copy;
            

        }
        
    }

    if (reload) {
//        [self.resultNode reloadData];
        [self reloadData];
    }
    
}
- (void)updateViewConstraints {

    
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(0);
        make.left.right.bottom.mas_offset(0);
        
    }];
    
    if (@available (ios 11, *)) {
    
        [self.searchBar  mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.mas_offset(0);
            
        }];

    }

    [super updateViewConstraints];
}



- (NSMutableArray *)historyArr {
    
    if (_historyArr == nil) {
        
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

- (YYCache *)historyCache {
    
    if (_historyCache == nil) {
        
        _historyCache = [YYCache cacheWithName:kSearchHistoryKey];
    }
    return _historyCache;
}

@end
