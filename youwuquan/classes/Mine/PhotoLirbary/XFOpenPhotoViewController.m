//
//  XFOpenPhotoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/28.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFOpenPhotoViewController.h"
#import "XFMyStatusViewController.h"
#import "XFUserInfoNetWorkManager.h"
#import "XFWallImagePickerViewController.h"
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

@interface XFOpenPhotoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFWallImagePickerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation XFOpenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *addButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 40, 30))];
    [addButton setTitle:@"添加" forState:(UIControlStateNormal)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addButton addTarget:self action:@selector(clickAddbutton) forControlEvents:(UIControlEventTouchUpInside)];
    [addButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    if (self.iswall) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    }
    
    [self setupCollectionView];
    
    [self loadData];

}

- (void)loadData {
    
    [XFUserInfoNetWorkManager getPhotoAlbumPicsWithId:self.albumId successBlock:^(NSDictionary *responseDic) {
       
        if (responseDic) {
            
            // :TODO 接口问题
            
        }
        
    } failedBlock:^(NSError *error) {
        
        
    }];
}

- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在上传"];
    
    [XFUserInfoNetWorkManager uploadImgTowallWithImages:images SuccessBlock:^(NSDictionary *responseDic) {
       
        if (responseDic) {
            
            [XFToolManager changeHUD:HUD successWithText:@"上传成功"];
            
            // 刷新数据
            
            
        }
        
        [HUD hideAnimated:YES];
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];

    }];
    
}

- (void)clickAddbutton {
    
    XFWallImagePickerViewController *imgPicker = [[XFWallImagePickerViewController alloc] init];
    imgPicker.delegate = self;
    [self.navigationController pushViewController:imgPicker animated:YES];

    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.iswall) {
        
        return;
    }
    
    XFMyStatusViewController *statusVC = [[XFMyStatusViewController alloc] init];
    statusVC.type = XFMyStatuVCTypeMine;
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
