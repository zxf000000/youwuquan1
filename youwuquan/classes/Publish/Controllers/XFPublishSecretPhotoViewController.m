//
//  XFPublishSecretPhotoViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/20.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPublishSecretPhotoViewController.h"
#import "XFPublishTransation.h"
#import "XFPublishAddImageViewCollectionViewCell.h"
#import "XFImagePickerViewController.h"
#import "XFFindNetworkManager.h"

#import "PLShortVideoKit/PLShortVideoKit.h"
#import <IQKeyboardManager.h>
#define kItemWidth (kScreenWidth - 20 - 6)/3
#define KImgBottom 15
#define kImgPadding 2
#define kImgInset 12

@interface XFPublishSecretPhotoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,XFpublishCollectionCellDelegate,XFImagePickerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *picCollection;

@property (nonatomic,strong) UITextField *priceTextField;

@property (nonatomic,strong) NSMutableArray *pics;

@property (nonatomic,strong) UIButton *publishButton;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,weak) UIScrollView *scrollView;


@end

@implementation XFPublishSecretPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorHex(f4f4f4);
    self.title = @"发布私密照片";
    self.pics = [NSMutableArray array];
    
    [self setupViews];
    
    [self updateViewConstraints];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
//    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        
        if (keyboardFrame.origin.y == kScreenHeight) {
            
            self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);

        } else {
            
            self.scrollView.frame = CGRectMake(0, -kScreenHeight + 64 + keyboardFrame.origin.y, kScreenWidth, kScreenHeight - 64);

        }
        
        
        
    }];
}

- (void)clickPublishButton {
    
    if ([self.priceTextField.text intValue] <= 0) {
        [XFToolManager showProgressInWindowWithString:@"请输入正确的钻石数量"];
        return;
    }
    
    NSString *labels = @"";
    
    if (self.tags.count > 1) {
        
        for (NSInteger i = 0 ; i < self.tags.count - 1; i ++) {
            
            if (i == 0) {
                
                labels = [labels stringByAppendingString:self.tags[i]];
                
            } else {
                labels = [labels stringByAppendingString:[NSString stringWithFormat:@",%@",self.tags[i]]];
                
            }
        }
        
    } else {
        
        labels = nil;
        
    }
    
    NSMutableArray *srcTypes = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < self.openpics.count; i ++ ) {
        
        [srcTypes addObject:@"open"];
        
    }
    
    for (NSInteger i = 0 ; i < self.pics.count; i ++ ) {
        
        [srcTypes addObject:@"close"];
        
    }

    NSString *srcStr = [srcTypes componentsJoinedByString:@","];
    
    NSMutableArray *images = [NSMutableArray arrayWithArray:self.openpics];
    [images addObjectsFromArray:self.pics];
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.progress = 0;
    
    [XFFindNetworkManager publishWithType:@"picture" title:@"asdasd" unlockPrice:[self.priceTextField.text intValue] labels:labels text:self.text srcTypes:srcStr images:images videoCoverUrl:nil videoUrl:nil videoWidth:0 videoHeight:0 successBlock:^(id responseObj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                //                     刷新动态页面通知
                
            }];
            
            
        });
        
        
    } failBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideAnimated:YES];
            
        });
        
        
    } progress:^(CGFloat progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            HUD.progress = progress;
            
        });
    }];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//
    
}

//

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.priceTextField resignFirstResponder];
//
    
}

#pragma mark - 图片选择collectionViewCellDelegate
- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath {
    
        if([self.picCollection.visibleCells containsObject:cell]) {
            
            // 公开的
            [self.pics removeObjectAtIndex:indexPath.item];
            [self.picCollection reloadData];
            
        }
    
}

- (void)selectImageForCollectionView:(UICollectionView *)collectionView {
    
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    assetCollections = nil;
    
        XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
        
        imagePicker.delegate = self;
    
        imagePicker.selectedNumber = self.pics.count;
    
        imagePicker.maxNumber = 100;
    
        [self.navigationController pushViewController:imagePicker animated:YES];
        

}

#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selectImageForCollectionView:collectionView];


        

    
}

#pragma mark - imagepickerdelegate
- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images {
    
    
        [self.pics addObjectsFromArray:images];
        
        [self.picCollection reloadData];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        XFPublishAddImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell" forIndexPath:indexPath];
    
            if (self.pics.count == 9) {
                
                cell.picView.image = self.pics[indexPath.item];
                cell.deleteButton.hidden = NO;
                
            } else {
                
                if (indexPath.item == self.pics.count) {
                    
                    cell.picView.image = [UIImage imageNamed:@"pic_jinzhi"];
                    
                    cell.deleteButton.hidden = YES;
                    
                    [cell removeTap];
                    
                } else {
                    
                    cell.picView.image = self.pics[indexPath.item];
                    cell.deleteButton.hidden = NO;
                    
                }
                
            }
    
        cell.delegate = self;
        
        cell.indexpath = indexPath;
        
        return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
            
            if (self.pics.count == 9) {
                
                return self.pics.count;
            } else {
                
                return self.pics.count + 1;
                
            }
 
    return 0;
}

- (void)setupViews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    _publishButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 40, 21))];;
    [_publishButton setTitle:@"发布" forState:(UIControlStateNormal)];
    [_publishButton setTitleColor:UIColorHex(808080) forState:(UIControlStateDisabled)];
    [_publishButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_publishButton];
    _publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _publishButton.enabled = YES;
    [_publishButton addTarget:self action:@selector(clickPublishButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    UICollectionViewFlowLayout *openLayout = [[UICollectionViewFlowLayout alloc] init];
    openLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    openLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    openLayout.minimumLineSpacing = 2;
    openLayout.minimumInteritemSpacing = 2;
    self.picCollection = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:openLayout];
    self.picCollection.delegate = self;
    self.picCollection.dataSource = self;
    self.picCollection.backgroundColor = [UIColor whiteColor];
    [self.picCollection registerNib:[UINib nibWithNibName:@"XFPublishAddImageViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell"];
    
    [scrollView addSubview:self.picCollection];
    self.picCollection.frame = CGRectMake(0, 30, kScreenWidth, kItemWidth * 3 + 40);
    
    
    self.priceTextField = [[UITextField alloc] init];
    self.priceTextField.placeholder = @"请输入查看价格";
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:self.priceTextField];
    self.priceTextField.delegate = self;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:self.lineView];
    
    self.priceTextField.frame = CGRectMake(10, self.picCollection.bottom, kScreenWidth - 20, 30);
    self.lineView.frame = CGRectMake(10, self.priceTextField.bottom + 5, kScreenWidth - 20, 1);
}



@end
