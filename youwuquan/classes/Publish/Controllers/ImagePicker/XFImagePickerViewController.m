//
//  XFImagePickerViewController.m
//  chaofen
//
//  Created by mr.zhou on 2017/8/8.
//  Copyright © 2017年 a.hep. All rights reserved.
//

#import "XFImagePickerViewController.h"
#import <Photos/Photos.h>
#import "XFImagePickerCollectionViewCell.h"


@interface XFImagePickerViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,copy) NSArray *images;

@property (nonatomic,strong) UIButton *bottomButton;

@property (nonatomic,copy) NSArray *origionImages;

@property (nonatomic,strong) NSMutableArray *selectedIndexPaths;

@property (nonatomic,copy) PHFetchResult *assets;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) NSMutableArray *editedImages;


//@property (nonatomic,copy) NSArray *selectedImages;

@end

@implementation XFImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    
    [self.view addSubview:self.collectionView];
    
    [self setupBottomView];
    [self getThumbnailImages];
    
}

- (void)clickDoneButton {
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.tintColor = [UIColor whiteColor];
    
    [self.selectedImages addObjectsFromArray:[self getBigImageWithArr:self.selectedIndexPaths]];

    if (self.selectedImages.count < 1) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"至少选择一张图片" preferredStyle:(UIAlertControllerStyleAlert)];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        });
    
    } else {
        
        [self.delegate XFImagePicker:self didSelectedImagesWith:self.selectedImages];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    

}

- (void)setupNavigationBar {

    self.title = @"选择图片";
    
    self.numberLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 100, 21))];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.numberLabel];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    self.numberLabel.text = [NSString stringWithFormat:@"%zd/9张已选择",self.selectedNumber];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // 获取原图
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    
    // 原图尺寸
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        // 跳转展示控制器
        UIViewController *viewC = [[UIViewController alloc] init];
        
        viewC.view.backgroundColor = [UIColor whiteColor];
        
        viewC.title = @"查看原图";
        
        UIImageView *imageVIew = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
        
        imageVIew.contentMode = UIViewContentModeScaleAspectFit;
        
        imageVIew.image = result;
        
        [viewC.view addSubview:imageVIew];
        
        [self.navigationController pushViewController:viewC animated:YES];
    }];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    XFImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFImagePickerCollectionViewCell" forIndexPath:indexPath];
    
    cell.iconView.image = self.images[indexPath.item];
    
    cell.indexPath = indexPath;
    
    if (self.selectedIndexPaths.count + self.selectedNumber == self.maxNumber) {
        
        cell.canSeleted = NO;
        
    } else {
        
        cell.canSeleted = YES;
    }
        
        
    
    cell.selectedEnoughBlock = ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"图片超限" message:[NSString stringWithFormat:@"只能选择%zd张",self.maxNumber] preferredStyle:(UIAlertControllerStyleAlert)];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    };
    
    
    __weak typeof(cell) weakCell = cell;
    cell.selectedImageBlock = ^(BOOL isSelected, NSIndexPath *indexPath) {
        
        if (isSelected) {
            
            [self.selectedIndexPaths addObject:indexPath];
            
        } else {
            
            [self.selectedIndexPaths removeObject:indexPath];
            
        }
        
        self.numberLabel.text = [NSString stringWithFormat:@"%zd/%zd张已选择",self.selectedIndexPaths.count + self.selectedNumber,self.maxNumber];
        
        if ([self.selectedIndexPaths containsObject:indexPath]) {
            
            weakCell.selectedButton.selected = YES;
            
            
        } else {
            
            weakCell.selectedButton.selected = NO;
            
        }
        
        if (self.selectedIndexPaths.count + self.selectedNumber >= self.maxNumber) {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCountEnough" object:self.selectedIndexPaths];
        
        } else {
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCountOk" object:self.selectedIndexPaths];
            

        }
        
    };
    

    
    return cell;
}

#pragma mark - 获取单张大图
- (NSArray *)getBigImageWithArr:(NSArray *)arr {
    
    NSMutableArray *array = [NSMutableArray array];

    for (NSInteger i = 0 ; i < arr.count ; i ++ ) {
    
        NSIndexPath *indexPath = arr[i];
        
        // 获取原图
        PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
        
        // 原图尺寸
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [array addObject:result];
            
            if (array.count == arr.count) {
                [self.HUD hideAnimated:YES];
            }

        }];
    }
    return array.copy;
}


#pragma mark - 获取所有大图
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchOptions *requestOptions = [[PHFetchOptions alloc] init];
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:requestOptions];
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *myAssets = [NSMutableArray array];
    [assets enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(obj.pixelWidth, obj.pixelHeight) : CGSizeZero;
        
        // 只获取图片类型
        if (obj.mediaType == PHAssetMediaTypeImage) {
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:obj targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [array addObject:result];
                [myAssets addObject:obj];
            }];
            
        }
    
    }];
    
    self.assets = myAssets.copy;
    
    self.images = array.copy;
    
//    self.images = [[self.images reverseObjectEnumerator] allObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];

    });
    
    
}
#pragma mark - 获取所有缩略图
- (void)getThumbnailImages
{
    
//    PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
//    PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
//    // The user cannot change this application’s status, possibly due to active restrictions
//    //   such as parental controls being in place.
//    PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
//    PHAuthorizationStatusAuthorized
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
     
        UIAlertController *alert = [UIAlertController xfalertControllerWithMsg:@"您未开启相册权限,请到设置中开启" doneBlock:^{
           
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    // 请求相册权限
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
    
    }
    
    
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                // 获得所有的自定义相簿
                PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
                // 遍历所有的自定义相簿
                for (PHAssetCollection *assetCollection in assetCollections) {
                    [self enumerateAssetsInAssetCollection:assetCollection original:NO];
                }
                // 获得相机胶卷
                PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
                [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
            }
        }];
    }
    

    
}

- (void)setupBottomView {
    
    _bottomView = [[UIView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 49 -64, kScreenWidth, 49))];
    
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    
    [self.view addSubview:_bottomView];
    
    _bottomButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    
    _bottomButton.layer.cornerRadius = 5;
    
    _bottomButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    
    [_bottomButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [_bottomButton setTitle:@"完成" forState:(UIControlStateNormal)];
    
    [_bottomButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView addSubview:_bottomButton];
    
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.centerY.mas_offset(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
}


- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
    
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat width = (kScreenWidth - 5 * 5)/4.0;
        
        layout.itemSize = CGSizeMake(width, width);
        
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight- 49 - 64)) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        UINib *nib = [UINib nibWithNibName:@"XFImagePickerCollectionViewCell" bundle:nil];
        
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"XFImagePickerCollectionViewCell"];
        
    }
    return _collectionView;
}

- (NSMutableArray *)selectedIndexPaths {

    if (_selectedIndexPaths == nil) {
    
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}

- (NSMutableArray *)editedImages {

    if (_editedImages == nil ) {
    
        _editedImages = [NSMutableArray array];
    
    }
    return _editedImages;
}

- (NSMutableArray *)selectedImages {

    if (_selectedImages == nil) {
    
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

@end
