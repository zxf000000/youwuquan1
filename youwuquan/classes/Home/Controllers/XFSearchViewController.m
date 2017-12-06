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

// 缓存历史记录
#import <YYCache.h>

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


@interface XFSearchViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout,ASTableDelegate,ASTableDataSource,XFHomeNodedelegate>

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
    

}

- (void)getHistoryData {
    
    if ([self.historyCache containsObjectForKey:kSearchHistoryKey]) {
        
        NSArray *historyDatas = (NSArray *)[self.historyCache objectForKey:kSearchHistoryKey];
        
        [self.historyArr addObjectsFromArray:historyDatas];
        
        [self.historyView reloadData];
    }
    
}

- (void)beginSearchWithtext:(NSString *)text {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HUD hideAnimated:YES afterDelay:1];
    
    // 储存搜索历史记录
    if (![self.historyArr containsObject:text]) {
        
        [self.historyArr addObject:text];
        if (self.historyArr.count > 6) {
            
            [self.historyArr removeObjectAtIndex:0];
            
        }
//        [self.historyView reloadData];
        
        [self.historyCache setObject:self.historyArr forKey:kSearchHistoryKey];
        
    }
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchBar resignFirstResponder];
        self.historyView.hidden = YES;
        self.resultNode.hidden = NO;
    });
    

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

    XFStatusDetailViewController *statusDestaiVC = [[XFStatusDetailViewController alloc] init];

    [self.navigationController pushViewController:statusDestaiVC animated:YES];
    
//    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
//
//    detailVC.hidesBottomBarWhenPushed = YES;
//
//    [self.navigationController pushViewController:detailVC animated:YES];
    
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
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer];
    
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
                cell.titleLabel.text = self.titleArr[indexPath.item];

            }
                break;
        }
    } else {
        
        cell.titleLabel.text = self.titleArr[indexPath.item];

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
                self.searchBar.text = self.titleArr[indexPath.item];
                
            }
                break;
        }
    } else {
        
        self.searchBar.text = self.titleArr[indexPath.item];
        
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
}

#pragma mark - cellNodeDelegate点赞
- (void)findCellNode:(XFFindCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    
    node.likeButton.selected = !node.likeButton.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickIconForIndex:(NSIndexPath *)indexPath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"打赏用户" icon:@"" remainNUmber:@"100"];
    
    [alertView dsShowanimation];
    
    alertView.doneBlock = ^{
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        HUD.contentColor = [UIColor whiteColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.detailsLabel.text = @"打赏成功!";
            UIImageView *img = [[UIImageView alloc] init];
            img.image = [UIImage imageNamed:@"ds_ok"];
            HUD.customView = img;
            HUD.tintColor = [UIColor blackColor];
            HUD.animationType = MBProgressHUDAnimationZoom;
            [HUD hideAnimated:YES afterDelay:0.4];
        });
        
        
        
    };
    
    alertView.cancelBlock = ^{
        
        
    };
    
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 1;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        
         return ^ASCellNode *() {
            
            ASSearchManCellNode *node = [[ASSearchManCellNode alloc] init];
             
             node.didSelecSearchMan = ^{
               
                 XFNearbyViewController *nearByVC = [[XFNearbyViewController alloc] init];
                 nearByVC.type = SearchMan;
                 [self.navigationController pushViewController:nearByVC animated:YES];
                 
             };
             
            return node;
        };
        
    }

    return ^ASCellNode *{
        
        XFFindCellNode *node = [[XFFindCellNode alloc] initWithOpen:NO];
        
        node.index = indexPath;
        
        node.delegate = self;
        
        return node;
    };

    
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

- (NSArray *)titleArr {

    if (_titleArr == nil) {
        
        _titleArr = @[@"写真秀",@"小萝莉",@"小清新",@"火辣",@"摩登",@"有人",@"历史",@"女仆装",@"美腿",@"酥胸",@"运动",@"制服诱惑",@"魅族"];
    }
    return _titleArr;
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
