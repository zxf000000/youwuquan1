//
//  XFNearbyViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFNearbyViewController.h"
#import "XFNearbyTableViewCell.h"
#import "XFFindDetailViewController.h"
#import "XFHomeNetworkManager.h"
#import "XFNearModel.h"

@interface XFNearbyViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIImage *nearImg;

@property (nonatomic,copy) NSString *gender;

@property (nonatomic,strong) NSMutableArray *nearDatas;

@property (nonatomic,assign) NSInteger page;


@end

@implementation XFNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.type == Nearby) {
        
        self.title = @"附近的人";

    } else {
        
        self.title = @"相关用户";

    }
    
    self.nearImg = [UIImage imageNamed:@"find12"];
    
    self.nearDatas = [NSMutableArray array];
    
    self.gender = @"male";
    
    [self setupNavigationBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((kScreenWidth - 15)/2, (kScreenWidth - 15)/2*41/36.f + 50);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)) collectionViewLayout:layout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (@available (ios 11 , * )) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    self.collectionView.backgroundColor = UIColorHex(f4f4f4);
    [self.collectionView registerNib:[UINib nibWithNibName:@"XFNearbyTableViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFNearbyTableViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self getNearData];
}

- (void)getNearData {
    
    self.page = 0;
    
    [XFHomeNetworkManager getNearbyDataWithSex:self.gender longitude:[XFUserInfoManager sharedManager].userLong latitude:[XFUserInfoManager sharedManager].userLati distance:100 page:self.page size:20 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFNearModel modelWithDictionary:datas[i]]];
            
        }
        
        self.nearDatas = arr;
        // 成功之后
        [self.collectionView reloadData];
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)loedMoredata {
    
    self.page += 1;
    
    [XFHomeNetworkManager getNearbyDataWithSex:self.gender longitude:[XFUserInfoManager sharedManager].userLong latitude:[XFUserInfoManager sharedManager].userLati distance:100 page:self.page size:20 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFNearModel modelWithDictionary:datas[i]]];
            
        }
        
        [self.nearDatas addObjectsFromArray:arr.copy];
        // 成功之后
        [self.collectionView reloadData];
    } failBlock:^(NSError *error) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

// 筛选
- (void)clickSxButton {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionBoy = [UIAlertAction actionWithTitle:@"只看男神" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
//        self.nearImg = [UIImage imageNamed:@"find13"];
        self.gender = @"female";
        [self getNearData];
        [self.collectionView reloadData];
    }];
    UIAlertAction *actionGirl = [UIAlertAction actionWithTitle:@"只看女神" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.gender = @"male";
        [self getNearData];
        [self.collectionView reloadData];

    }];
    UIAlertAction *actionAll = [UIAlertAction actionWithTitle:@"查看所有" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.gender = @"all";
        [self getNearData];
        [self.collectionView reloadData];

    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertController addAction:actionAll];
    [alertController addAction:actionGirl];
    [alertController addAction:actionBoy];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES
                     completion:nil];
}

- (void)setupNavigationBar {
    
    UIButton *sxButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
    [sxButton setImage:[UIImage imageNamed:@"home_filtrate"] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sxButton];
    
    [sxButton addTarget:self action:@selector(clickSxButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (self.type == Nearby) {
        sxButton.hidden = NO;
        
    } else {
        
        sxButton.hidden = YES;
    }
    
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
}

// 返回
- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XFNearModel *model = self.nearDatas[indexPath.item];

    XFFindDetailViewController *datailVC = [[XFFindDetailViewController alloc] init];
    datailVC.userId = model.uid;
    datailVC.userName = model.nickname;
    datailVC.iconUrl = model.headIconUrl;
    [self.navigationController pushViewController:datailVC animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.nearDatas.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFNearbyTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFNearbyTableViewCell" forIndexPath:indexPath];
    
    cell.model = self.nearDatas[indexPath.item];
    
    return cell;
    
}

@end
