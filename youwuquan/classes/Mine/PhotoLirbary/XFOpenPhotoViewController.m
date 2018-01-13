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
#import "XFmyPhotoModel.h"
#import "XFMineNetworkManager.h"
#import "XFFindNetworkManager.h"


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
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"unselected"] forState:(UIControlStateNormal)];
        [_deleteButton setImage:[UIImage imageNamed:@"selected"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.selected = NO;
        _deleteButton.hidden = YES;
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setModel:(XFmyPhotoModel *)model {
    
    _model = model;
    
    [self.picView setImageWithURL:[NSURL URLWithString:_model.image[@"thumbImage500pxUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
}

- (void)updateConstraints {
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.mas_offset(0);
        make.width.height.mas_equalTo(25);
        
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.mas_offset(0);
        make.width.height.mas_equalTo(30);
        
    }];
    
    [super updateConstraints];
}

@end

@interface XFOpenPhotoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFWallImagePickerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) NSArray *photos;

@property (nonatomic,strong) NSMutableArray *selectedWallIndex;

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,strong) UIButton *deleteButton;


@end

@implementation XFOpenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedWallIndex = [NSMutableArray array];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 40, 30))];
    [addButton setTitle:@"编辑" forState:(UIControlStateNormal)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addButton addTarget:self action:@selector(clickAddbutton) forControlEvents:(UIControlEventTouchUpInside)];
    [addButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    if (self.type == OPenPhotoVCTypeWall) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    }
    
    switch (self.type) {
        case OPenPhotoVCTypeWall:
        {
            self.title = @"照片墙";
        }
            break;
        case OPenPhotoVCTypeOpen:
        {
            self.title = @"公开相册";

        }
            break;
        case OPenPhotoVCTypeClose:
        {
            self.title = @"私密相册";

        }
            break;
            
        default:
            break;
    }
    
    [self setupCollectionView];
    
    self.deleteButton = [[UIButton alloc] init];
    [self.deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
    [self.deleteButton setBackgroundColor:kMainRedColor];
    [self.view addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(clickDeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
    self.deleteButton.hidden = YES;
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(49);
        
    }];
}

#pragma mark - 删除照片墙
- (void)clickDeleteButton {
    
    if (self.selectedWallIndex.count == 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择删除的照片"];
        
        return;
    }
    
    NSString *pics = @"";
    for (int i = 0 ; i < self.selectedWallIndex.count ; i ++ ) {
        
        NSIndexPath *indexPath = self.selectedWallIndex[i];
        XFmyPhotoModel *model = self.photos[indexPath.item];
        
        if (i == 0) {
            
            pics = [pics stringByAppendingString:[NSString stringWithFormat:@"%@",model.id]];
        } else {
            
            pics = [pics stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];

        }
        
    }
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在删除"];
    [XFMineNetworkManager deletePhotoWallWithPics:pics successBlock:^(id responseObj) {
        
        [XFToolManager changeHUD:HUD successWithText:@"删除成功"];
        
        self.deleteButton.hidden = YES;
        self.isEdit = NO;
        
        [self loadData];
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)loadData {
    
    switch (self.type) {
        case OPenPhotoVCTypeWall:
        {
            [XFMineNetworkManager getMyPhotoWallInfoWithsuccessBlock:^(id responseObj) {
                
                [self.collectionView.mj_header endRefreshing];
                
                NSArray *datas = (NSArray *)responseObj;
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                    
                    XFmyPhotoModel *model = [XFmyPhotoModel modelWithDictionary:datas[i]];
                    [arr addObject:model];
                    
                }
                
                self.photos = arr.copy;
                
                [self.collectionView reloadData];
                
            } failedBlock:^(NSError *error) {
                
                [self.collectionView.mj_header endRefreshing];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
            
        }
            break;
        case OPenPhotoVCTypeOpen:
        {
            [XFMineNetworkManager getMyOpenPhotoWithsuccessBlock:^(id responseObj) {
                
                [self.collectionView.mj_header endRefreshing];
                
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                    
                    XFmyPhotoModel *model = [XFmyPhotoModel modelWithDictionary:datas[i]];
                    [arr addObject:model];
                    
                }
                
                self.photos = arr.copy;
                
                [self.collectionView reloadData];
                
            } failedBlock:^(NSError *error) {
                
                [self.collectionView.mj_header endRefreshing];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
        }
            break;
        case OPenPhotoVCTypeClose:
        {
            
            [XFMineNetworkManager getMyClosePhotoWithsuccessBlock:^(id responseObj) {
                
                [self.collectionView.mj_header endRefreshing];
                
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];

                NSMutableArray *arr = [NSMutableArray array];
                for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                    
                    XFmyPhotoModel *model = [XFmyPhotoModel modelWithDictionary:datas[i]];
                    [arr addObject:model];
                    
                }
                
                self.photos = arr.copy;
                
                [self.collectionView reloadData];
                
            } failedBlock:^(NSError *error) {
                
                [self.collectionView.mj_header endRefreshing];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
        }
            break;
            
        default:
            break;
    }

}

- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在上传"];
    
    [XFMineNetworkManager uploadPhotoWallWithImages:images successBlock:^(id responseObj) {
        
        [XFToolManager changeHUD:HUD successWithText:@"上传成功"];
        
        [self.collectionView.mj_header beginRefreshing];
        
    } failedBlock:^(NSError *error) {

        [HUD hideAnimated:YES];
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)clickAddbutton {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *actionAdd = [UIAlertAction actionWithTitle:@"添加" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.isEdit = NO;
        self.deleteButton.hidden = YES;
        [self.collectionView reloadData];
        
        XFWallImagePickerViewController *imgPicker = [[XFWallImagePickerViewController alloc] init];
        imgPicker.delegate = self;
        [self.navigationController pushViewController:imgPicker animated:YES];
        
    }];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        self.isEdit = YES;
        self.deleteButton.hidden = NO;
        [self.collectionView reloadData];
        
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionAdd];
    [alert addAction:actionDelete];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == OPenPhotoVCTypeWall) {
        
        if (self.isEdit) {
            // 选中
            XFOpenPhotoCell *cell = (XFOpenPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.deleteButton.selected = !cell.deleteButton.selected;
            
            if (cell.deleteButton.selected) {
                
                [self.selectedWallIndex addObject:indexPath];
                
            } else {
                
                if ([self.selectedWallIndex containsObject:indexPath])
                    [self.selectedWallIndex removeObject:indexPath];
                
            }
        }

        return;
    }
    
    XFmyPhotoModel *model = self.photos[indexPath.item];
    // 获取数据
    [XFFindNetworkManager getOneStatusWithStatusId:[NSString stringWithFormat:@"%@",model.publishId] successBlock:^(id responseObj) {
        
        if (responseObj) {
            
            XFMyStatusViewController *statusVC = [[XFMyStatusViewController alloc] init];
            
            statusVC.type = XFMyStatuVCTypeMine;
            
            NSDictionary *status = (NSDictionary *)responseObj;
            
            XFStatusModel *model = [XFStatusModel modelWithDictionary:status];
            
            NSDictionary *user = @{@"nickname":[XFUserInfoManager sharedManager].userInfo[@"basicInfo"][@"nickname"],
                                   @"headIconUrl":[XFUserInfoManager sharedManager].userInfo[@"basicInfo"][@"headIconUrl"]
                                   };
            model.user = user;
            statusVC.model = model;
            
            statusVC.deleteSuccessBlock = ^{
              
                [self loadData];
                
            };
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
    
    } failBlock:^(NSError *error) {
        
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photos.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFOpenPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFOpenPhotoCell" forIndexPath:indexPath];
    
    cell.model = self.photos[indexPath.item];
    
    if (self.isEdit) {
        
        cell.deleteButton.hidden = NO;
        
    } else {
        
        cell.deleteButton.hidden = YES;

    }
    
    if ([self.selectedWallIndex containsObject:indexPath]) {
        
        cell.deleteButton.selected = YES;
        
    } else {
        
        cell.deleteButton.selected = NO;

    }
    
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
 
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
}

@end
