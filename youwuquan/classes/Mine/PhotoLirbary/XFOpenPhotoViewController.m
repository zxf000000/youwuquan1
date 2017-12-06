//
//  XFOpenPhotoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOpenPhotoViewController.h"
#import "XFMyStatusViewController.h"

@implementation XFOpenPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _picView = [[UIImageView alloc] init];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.layer.masksToBounds = YES;
        [self.contentView addSubview:_picView];
        
        _iconButton = [[UIButton alloc] init];
        [_iconButton setImage:[UIImage imageNamed:@"home_picture"] forState:(UIControlStateNormal)];
        [_iconButton setImage:[UIImage imageNamed:@"home_video"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_iconButton];
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.mas_offset(0);
        make.width.height.mas_equalTo(25);
        
    }];
    
    [super updateConstraints];
}

@end

@interface XFOpenPhotoViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation XFOpenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupCollectionView];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyStatusViewController *statusVC = [[XFMyStatusViewController alloc] init];
    
    [self.navigationController pushViewController:statusVC animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFOpenPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFOpenPhotoCell" forIndexPath:indexPath];
    
    cell.picView.image = [UIImage imageNamed:kRandomPhoto];
    
    return cell;
    
}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    CGFloat itemWidth = (kScreenWidth - 15)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 41/36.f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColorHex(f4f4f4);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XFOpenPhotoCell class] forCellWithReuseIdentifier:@"XFOpenPhotoCell"];
    
}

@end
