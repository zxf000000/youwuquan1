//
//  XFRefreshInfoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/24.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFRefreshInfoViewController.h"
#import "XFMyInfoViewController.h"
#import "XFPublishAddImageViewCollectionViewCell.h"
#import "XFMineNetworkManager.h"
#import "XFmyPhotoModel.h"

#define kItemWidth (kScreenWidth - 60)/3.f

@interface XFRefreshInfoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFpublishCollectionCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UILabel *iconDesLabel;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UICollectionView *wallCollectionView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSMutableArray *wallPics;

@property (nonatomic,strong) XFMyInfoViewController *infoVC;

@property (nonatomic,assign) BOOL isHeader;


@end

@implementation XFRefreshInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的资料";
    UIButton *saveButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 50, 30))];
    
    [saveButton setImage:[UIImage imageNamed:@"refresh_save"] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    [saveButton addTarget:self action:@selector(clickRefreshButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self setupViews];
    
    [self loadWalldata];
    
}

- (void)clickTapImage {
    self.isHeader = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *actionCar = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *actionphoto = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    [alert addAction:actionphoto];
    [alert addAction:actionCar];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)clickRefreshButton:(UIButton *)sender {
    
    [self.infoVC clickSaveButton:sender];
    
}

- (void)loadWalldata {
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在上传"];

    [XFMineNetworkManager getMyPhotoWallInfoWithsuccessBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];
        
        NSArray *datas = (NSArray *)responseObj;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            XFmyPhotoModel *model = [XFmyPhotoModel modelWithDictionary:datas[i]];
            [arr addObject:model];
            
        }
        
        self.wallPics = arr.copy;
        
        [self.wallCollectionView reloadData];
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

#pragma mark - 图片选择collectionViewCellDelegate
- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath {
    
    if([self.wallCollectionView.visibleCells containsObject:cell]) {
        
        XFmyPhotoModel *model = self.wallPics[indexPath.item];
        
        // 删除
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在删除"];
        [XFMineNetworkManager deletePhotoWallWithPics:[NSString stringWithFormat:@"%@",model.id] successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"删除成功"];

            [self loadWalldata];
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (self.isHeader) {
            
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在保存"];
            
            // 上传头像
            [XFMineNetworkManager uploadIconWithImage:image successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
                self.iconView.image = image;
                
                
            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
        } else {
            
            // 上传
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在上传"];
            
            [XFMineNetworkManager uploadPhotoWallWithImages:@[image] successBlock:^(id responseObj) {
                
                [HUD hideAnimated:YES];
                
                [self loadWalldata];
                
            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
        }

        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.isHeader = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XFPublishAddImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell" forIndexPath:indexPath];
    
    
    if (indexPath.item < self.wallPics.count) {
        XFmyPhotoModel *model = self.wallPics[indexPath.item];

        [cell.picView setImageWithURL:[NSURL URLWithString:model.image[@"imageUrl"]] options:(YYWebImageOptionProgressiveBlur)];
        cell.deleteButton.hidden = NO;
        
        
    } else {
        
//        if (indexPath.item == self.wallPics.count) {

            cell.picView.image = [UIImage imageNamed:@"pic_jinzhi"];
            
            cell.deleteButton.hidden = YES;
            
            [cell removeTap];
            
//        } else {
//            XFmyPhotoModel *model = self.wallPics[indexPath.item];
//
//            [cell.picView setImageWithURL:[NSURL URLWithString:model.image[@"imageUrl"]] options:(YYWebImageOptionProgressiveBlur)];
//            cell.deleteButton.hidden = NO;
//
//        }
        
    }
    
    cell.delegate = self;
    
    cell.indexpath = indexPath;
    
    return cell;
    
}

- (void)setupViews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"账号信息";
    self.titleLabel.textColor = UIColorHex(808080);
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(13, 0, kScreenWidth - 13, 26);
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.image = [UIImage imageNamed:@"logo"];
    [self.scrollView addSubview:self.iconView];
    self.iconView.frame = CGRectMake(kScreenWidth - 15 - 50, _titleLabel.bottom + 5, 50, 50);
    
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapImage)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:tapHeader];
    
    [self.iconView setImageWithURL:[NSURL URLWithString:self.userInfo[@"basicInfo"][@"headIconUrl"]] placeholder:[UIImage imageNamed:@"logo"]];

    
    self.iconDesLabel = [[UILabel alloc] init];
    self.iconDesLabel.frame = CGRectMake(13, self.iconView.bottom - 25 - 7.5, 100, 15);
    self.iconDesLabel.textColor = [UIColor blackColor];
    self.iconDesLabel.font = [UIFont systemFontOfSize:12];
    self.iconDesLabel.text = @"修改头像";
    [self.scrollView addSubview:self.iconDesLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(f4f4f4);
    lineView.frame = CGRectMake(0, self.iconView.bottom + 10, kScreenWidth, 1);
    [self.scrollView addSubview:lineView];
    
    UICollectionViewFlowLayout *openLayout = [[UICollectionViewFlowLayout alloc] init];
    openLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    openLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    openLayout.minimumLineSpacing = 15;
    openLayout.minimumInteritemSpacing = 1;
    self.wallCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:openLayout];
    self.wallCollectionView.delegate = self;
    self.wallCollectionView.dataSource = self;
    self.wallCollectionView.backgroundColor = [UIColor whiteColor];
    [self.wallCollectionView registerNib:[UINib nibWithNibName:@"XFPublishAddImageViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell"];
    self.wallCollectionView.frame = CGRectMake(0, lineView.bottom, kScreenWidth, kItemWidth * 2 + 45);
    
    [self.scrollView addSubview:self.wallCollectionView];
    
    
    self.infoVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFMyInfoViewController"];
    
    self.infoVC.userInfo = self.userInfo;
    
    [self addChildViewController:self.infoVC];
    [self.scrollView addSubview:self.infoVC.view];
    self.infoVC.view.frame = CGRectMake(10, self.wallCollectionView.bottom + 10, kScreenWidth - 20, 500);
    ((UITableView *)_infoVC.view).scrollEnabled = NO;
    [self.infoVC.view setMyShadow];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.infoVC.view.bottom + 10);
    
    
    
    
}

@end
