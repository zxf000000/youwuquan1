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

@interface XFNearbyViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIImage *nearImg;

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
}


// 筛选
- (void)clickSxButton {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionBoy = [UIAlertAction actionWithTitle:@"只看男神" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.nearImg = [UIImage imageNamed:@"find13"];
        [self.collectionView reloadData];
    }];
    UIAlertAction *actionGirl = [UIAlertAction actionWithTitle:@"只看女神" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.nearImg = [UIImage imageNamed:@"find7"];
        [self.collectionView reloadData];

    }];
    UIAlertAction *actionAll = [UIAlertAction actionWithTitle:@"查看所有" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.nearImg = [UIImage imageNamed:@"find21"];
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

    XFFindDetailViewController *datailVC = [[XFFindDetailViewController alloc] init];
    
    [self.navigationController pushViewController:datailVC animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFNearbyTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFNearbyTableViewCell" forIndexPath:indexPath];
    
    cell.picView.image = self.nearImg;
    
    return cell;
    
}

@end
