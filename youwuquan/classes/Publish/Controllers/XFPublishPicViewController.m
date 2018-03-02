//
//  XFPublishPicViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/19.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFPublishPicViewController.h"
#import "XFPublishTransation.h"
#import "XFLabelCollectionViewCell.h"
#import "XFHistoryViewRowsCaculator.h"
#import "XFPublishAddImageViewCollectionViewCell.h"
#import "XFImagePickerViewController.h"
#import "XFSelectLabelViewController.h"
#import "XFStatusNetworkManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XFFindNetworkManager.h"

#import "PLShortVideoKit/PLShortVideoKit.h"
#import "CustomeImagePicker.h"
#import "XFSecretphotoNotiViewController.h"
#import "XFAuthManager.h"

#define kImgInset 12
#define kImgPadding 2
#define kItemWidth (kScreenWidth - 20 - 6)/3
#define KImgBottom 15
#define kTextViewHeight 175 * kScreenWidth / 375.f

@interface XFPublishPicViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,XFImagePickerDelegate,XFSelectTagVCDelegate,XFpublishCollectionCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PLShortVideoUploaderDelegate,CustomeImagePickerDelegate>
@property (nonatomic,strong) UIButton *publishButton;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UICollectionView *centerView;

@property (nonatomic,strong) UIView *openHeader;
@property (nonatomic,strong) UICollectionView *openView;

@property (nonatomic,strong) UIView *secretHeader;

@property (nonatomic,strong) UICollectionView *secretView;

@property (nonatomic,strong) UITextField *diamondTextField;

@property (nonatomic,strong) UILabel *placeHolderLabel;

@property (nonatomic,strong) UIButton *openButton;

@property (nonatomic,strong) UIButton *secretButton;

@property (nonatomic,strong) UILabel *detailLabel;


@property (nonatomic,assign) CGFloat topHeight;

@property (nonatomic,assign) CGFloat centerHeight;
@property (nonatomic,assign) CGFloat openHeight;
@property (nonatomic,assign) CGFloat secretHeight;

@property (nonatomic,strong) NSMutableArray *labels;

@property (nonatomic,copy) NSArray *titleArr;

@property (nonatomic,strong) NSMutableArray *labelsArr;

@property (nonatomic,strong) NSMutableArray *openintentionImages;
@property (nonatomic,strong) NSMutableArray *secintentionImages;

//@property (nonatomic,assign) CGFloat centerHeight;
@property (nonatomic,assign) BOOL isOpenImage;

@property (nonatomic,strong) NSMutableArray *video;

@property (strong, nonatomic) PLShortVideoUploader *shortVideoUploader;

// 上传进度
@property (nonatomic,strong) MBProgressHUD *uploadProgressHUD;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UISwitch *openSwitch;

@property (nonatomic,assign) BOOL isUp;


@end

static NSString *const kUploadToken = @"MqF35-H32j1PH8igh-am7aEkduP511g-5-F7j47Z:clOQ5Y4gJ15PnfZciswh7mQbBJ4=:eyJkZWxldGVBZnRlckRheXMiOjMwLCJzY29wZSI6InNob3J0LXZpZGVvIiwiZGVhZGxpbmUiOjE2NTUyNjAzNTd9";
static NSString *const kURLPrefix = @"http://shortvideo.pdex-service.com";

@implementation XFPublishPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布";
    
    [self setupnavigationButton];
    [self setupScrolLView];
    [self setupOtherView];
    [self prepareUpload];
    
    XFMyAuthModel *model = [[XFAuthManager sharedManager].authList lastObject];
    
    
//    if ([model.identificationName isEqualToString:@"基本认证"]) {
//        _isUp = YES;
//
//        self.bottomView.hidden = YES;
//    } else {
        _isUp = NO;
        self.bottomView.hidden = NO;
        
//    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)prepareUpload {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *key;
    //    if (self.actionType == PLSActionTypePlayer) {
    key = [NSString stringWithFormat:@"short_video_%@.mp4", [formatter stringFromDate:[NSDate date]]];
    //    }
    //    if (self.actionType == PLSActionTypeGif) {
    //        key = [NSString stringWithFormat:@"short_video_%@.gif", [formatter stringFromDate:[NSDate date]]];
    //    }
    PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:kUploadToken videoKey:key https:YES recorder:nil];
    self.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
    self.shortVideoUploader.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.openSwitch) {
        
        self.openSwitch.on = NO;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

//- (void)viewDidLayoutSubviews {
//
//    [super viewDidLayoutSubviews];
//
//    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_offset(0);
//        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
//        make.height.mas_equalTo(self.labelsArr.count > 0 ? self.centerView.collectionViewLayout.collectionViewContentSize.height : 30);
//        make.width.mas_equalTo(kScreenWidth);
//
//    }];
//
//}

- (void)clickPublishButton {
    
    NSString *type;
    
    if ((self.openintentionImages.count + self.secintentionImages.count) > 0) {
        
        type =  @"picture";
        
    } else {
        
        type =  @"word";
        
    }
    
    NSString *labels = @"";
    
    if (self.labelsArr.count > 1) {
        
        for (NSInteger i = 0 ; i < self.labelsArr.count - 1; i ++) {
            
            if (i == 0) {
                
                labels = [labels stringByAppendingString:self.labelsArr[i]];
                
            } else {
                labels = [labels stringByAppendingString:[NSString stringWithFormat:@",%@",self.labelsArr[i]]];
                
            }
        }
        
    } else {
        
        labels = nil;
        
    }
    
    
    
    NSMutableArray *srcTypes = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < self.openintentionImages.count; i ++ ) {
        
        [srcTypes addObject:@"open"];
        
    }
    
    NSString *srcStr = [srcTypes componentsJoinedByString:@","];
    
    
    NSMutableArray *images = [NSMutableArray arrayWithArray:self.openintentionImages];
    
    if (self.openSwitch.on == NO) {
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.progress = 0;
        
        [XFFindNetworkManager publishWithType:type title:@"asdasd" unlockPrice:0 labels:labels text:self.textView.text srcTypes:srcStr images:images videoCoverUrl:nil videoUrl:nil videoWidth:0 videoHeight:0 successBlock:^(id responseObj) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    //                     刷新动态页面通知
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:nil];
                    
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
        
    } else {
        // 跳转下一个页面
        XFSecretphotoNotiViewController *notiVC = [[UIStoryboard storyboardWithName:@"Publish" bundle:nil] instantiateViewControllerWithIdentifier:@"XFSecretphotoNotiViewController"];
        
        notiVC.openpics = self.openintentionImages.copy;
        notiVC.text = self.textView.text;
        notiVC.tags = self.labelsArr;
        [self.navigationController pushViewController:notiVC animated:YES];
        
    }
    
    
    
}

- (void)setupScrolLView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    [self.view addSubview:self.scrollView];
    
    if (@available (iOS 11 , *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    self.scrollView.backgroundColor = UIColorHex(f4f4f4);
    
}


- (void)setupOtherView {
    
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    // kvo监听
    [self.textView addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    // 设置占位符
    self.textView.delegate = self;
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 21)];
    self.placeHolderLabel.text = @"分享这一刻...";
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    
    self.placeHolderLabel.textColor = UIColorHex(808080);
    self.placeHolderLabel.enabled = NO;
    [self.textView addSubview:self.placeHolderLabel];
    
    // 标签View
    //    UICollectionViewFlowLayout *
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 5;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 5;
    // 3.设置item块的大小 (可以用于自适应)
    layout.estimatedItemSize = CGSizeMake(20, 60);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    
    layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.centerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.delegate = self;
    self.centerView.dataSource = self;
    [self.centerView registerClass:[XFLabelCollectionViewCell class] forCellWithReuseIdentifier:@"history"];
    [self.view addSubview:self.centerView];
    
    // 公开图片
    self.openHeader = [[UIView alloc] init];
    
    self.openHeader.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.openHeader];
    
    UICollectionViewFlowLayout *openLayout = [[UICollectionViewFlowLayout alloc] init];
    openLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    openLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    openLayout.minimumLineSpacing = 2;
    openLayout.minimumInteritemSpacing = 2;
    self.openView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:openLayout];
    self.openView.delegate = self;
    self.openView.dataSource = self;
    self.openView.backgroundColor = [UIColor whiteColor];
    [self.openView registerNib:[UINib nibWithNibName:@"XFPublishAddImageViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell"];
    
    [self.view addSubview:self.openView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = UIColorHex(e0e0e0);
    [self.view addSubview:self.bottomView];
    
    self.openSwitch = [[UISwitch alloc] init];
    self.openSwitch.tintColor = kMainRedColor;
    self.openSwitch.onTintColor = kMainRedColor;
    [self.bottomView addSubview:self.openSwitch];
    
    [self.openSwitch addTarget:self action:@selector(clickOpenSwitch:) forControlEvents:(UIControlEventValueChanged)];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"tabbar_middle"];
    [self.bottomView addSubview:logoView];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"发照片能挣钱,在尤物圈分享照片同时赚取收益~";
    desLabel.numberOfLines = 0;
    desLabel.textColor = UIColorHex(808080);
    desLabel.font = [UIFont systemFontOfSize:13];
    [self.bottomView addSubview:desLabel];
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(11);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(40);
        
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(logoView.mas_right).offset(20);
        make.right.mas_offset(-80);
    }];
    
}

- (void)clickOpenSwitch:(UISwitch *)openSwitch {
    
    if (openSwitch.on) {
        
        // 跳转下一个页面
        XFSecretphotoNotiViewController *notiVC = [[UIStoryboard storyboardWithName:@"Publish" bundle:nil] instantiateViewControllerWithIdentifier:@"XFSecretphotoNotiViewController"];
        
        notiVC.openpics = self.openintentionImages.copy;
        notiVC.text = self.textView.text;
        notiVC.tags = self.labelsArr;
        [self.navigationController pushViewController:notiVC animated:YES];
        
    }
    
}

#pragma mark - imagepickerdelegate
- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images {
    
    
    [self.openintentionImages addObjectsFromArray:images];
    
    [self.openView reloadData];
    
    
    
}

#pragma mark - 标签选择器代理
- (void)selecteTagVC:(XFSelectLabelViewController *)selecteVC didSelectedTagsWith:(NSArray *)tags {
    
    self.labelsArr = [NSMutableArray arrayWithArray:tags];
    
    [self.labelsArr addObject:@""];
    
    [self.centerView reloadData];
    
    [self.centerView layoutIfNeeded];
    
    [self setScrollContent];
    
}

#pragma mark - 图片选择collectionViewCellDelegate
- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath {
    
    if([self.openView.visibleCells containsObject:cell]) {
        
        // 公开的
        [self.openintentionImages removeObjectAtIndex:indexPath.item];
        [self.openView reloadData];
        
    }
    
    
}
#pragma mark - collectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.centerView) {
        
        XFSelectLabelViewController *selectLabelVC = [[XFSelectLabelViewController alloc] init];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.labelsArr];
        
        [arr removeLastObject];
        
        selectLabelVC.labelsArr = arr;
        
        selectLabelVC.delegate = self;
        
        [self.navigationController pushViewController:selectLabelVC animated:YES];
        
        return;
    } else {
        
        // 图片选择
        [self selectImageForCollectionView:collectionView];
        
    }
    
}

- (void)selectImageForCollectionView:(UICollectionView *)collectionView {
    
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    assetCollections = nil;
    
    if (collectionView == self.openView) {
       
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
            
            UIAlertController *alert = [UIAlertController xfalertControllerWithMsg:@"您未开启相册权限,请到设置中开启" doneBlock:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
        // 请求相册权限
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            
            XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
            
            imagePicker.delegate = self;
            imagePicker.maxNumber = 8;
            self.isOpenImage = YES;
            
            imagePicker.selectedNumber = self.openintentionImages.count + self.secintentionImages.count;
            
            [self.navigationController pushViewController:imagePicker animated:YES];
        }
        
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (status == PHAuthorizationStatusAuthorized) {
                        
                        XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
                        
                        imagePicker.delegate = self;
                        imagePicker.maxNumber = 8;
                        self.isOpenImage = YES;
                        
                        imagePicker.selectedNumber = self.openintentionImages.count + self.secintentionImages.count;
                        
                        [self.navigationController pushViewController:imagePicker animated:YES];
                        
                    }
                });
                

            }];
        }
        
        
        
        
        
        
        

        
    } else if (collectionView == self.secretView) {
        
        XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
        
        imagePicker.delegate = self;
        
        self.isOpenImage = NO;
        imagePicker.selectedNumber = self.openintentionImages.count + self.secintentionImages.count;
        
        [self.navigationController pushViewController:imagePicker animated:YES];
        
    }
}

- (void)selectVideoForCollectionView:(UICollectionView *)collectionView {
    
    
    if (collectionView == self.openView) {
        
        self.isOpenVideo = YES;
    } else if (collectionView == self.secretView) {
        
        self.isOpenVideo = NO;
        
        
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (![info objectForKey:UIImagePickerControllerMediaURL]) {
        
        [XFToolManager showProgressInWindowWithString:@"请选择视频"];
        
        return;
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            
            self.uploadProgressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            self.uploadProgressHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            
            
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            
            _videoPath = [url absoluteString];
            
            // 判断视频文件大小和时长
            
            NSDictionary *videoInfo = [XFToolManager getVideoInfoWithSourcePath:_videoPath];
            
            CGFloat duration = [videoInfo[@"duration"] floatValue];
            //            CGFloat size = [videoInfo[@"size"] integerValue];
            
            if (duration > 10) {
                
                [XFToolManager showProgressInWindowWithString:@"发布视频时长不能超过10s"];
                
                return;
            }
            
            // 视频封面
            self.videoImage = [XFToolManager getImage:_videoPath];
            
            // 上传
            [self.shortVideoUploader uploadVideoFile:url.path];
            
            // TODO:
            
            [self.secretView reloadData];
            [self.openView reloadData];
            
        }];
        
    }
    
}

#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
    
    if(info.error){
        
        [XFToolManager changeHUD:self.uploadProgressHUD successWithText:[NSString stringWithFormat:@"上传失败%@",info]];
        
        //        NSLog(@"%@",info.error);
        
        self.videoPath = nil;
        self.videoImage = nil;
        
        [self.openView reloadData];
        [self.secretView reloadData];
        return ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kURLPrefix, uploadKey];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = urlString;
    
    //    [XFToolManager changeHUD:self.uploadProgressHUD successWithText:@"上传成功"];
    [self.uploadProgressHUD hideAnimated:YES afterDelay:0.3];
    
    // 上传路径
    self.videoPath = urlString;
    
    
    NSLog(@"uploadInfo: %@",info);
    NSLog(@"uploadKey:%@",uploadKey);
    NSLog(@"resp: %@",resp);
}

- (void)shortVideoUploader:(PLShortVideoUploader *)uploader uploadKey:(NSString *)uploadKey uploadPercent:(float)uploadPercent {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.uploadProgressHUD.progress = uploadPercent;
        
    });
    NSLog(@"uploadKey: %@",uploadKey);
    NSLog(@"uploadPercent: %.2f",uploadPercent);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.centerView) {
        
        if (self.labelsArr.count > 1) {
            
            return self.labelsArr.count;
            
        } else {
            
            return self.titleArr.count;
            
        }
    } else if (collectionView == self.openView) {
        
        
        if (self.openintentionImages.count == 9) {
            
            return self.openintentionImages.count;
        } else {
            
            return self.openintentionImages.count + 1;
            
        }
        
    }
    
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.centerView) {
        
        XFLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        
        if (self.labelsArr.count > 1) {
            // 赋值
            cell.tagStr = self.labelsArr[indexPath.item];
            cell.textLabel.textColor = kMainRedColor;
            cell.deleteButton.hidden = NO;
            if (indexPath.item == self.labelsArr.count - 1) {
                cell.deleteButton.hidden = YES;
            }
            
        } else {
            // 赋值
            cell.tagStr = self.titleArr[indexPath.item];
            cell.textLabel.textColor = UIColorHex(808080);
            cell.deleteButton.hidden = YES;
            
        }
        
        cell.clickDeleteButtonForIndex = ^(NSIndexPath *indexpath) {
            
            // 删除相应的标
            [self.labelsArr removeObjectAtIndex:indexpath.item];
            
            [self.centerView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            // 计算高度
            // 计算标签栏高度
            [self setScrollContent];
            
        };
        
        return cell;
        
    } else if (collectionView == self.openView) {
        
        XFPublishAddImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell" forIndexPath:indexPath];
        
        
        if (self.openintentionImages.count == 9) {
            
            cell.picView.image = self.openintentionImages[indexPath.item];
            cell.deleteButton.hidden = NO;
            
            
        } else {
            
            if (indexPath.item == self.openintentionImages.count) {
                
                cell.picView.image = [UIImage imageNamed:@"pic_jinzhi"];
                
                cell.deleteButton.hidden = YES;
                
                [cell removeTap];
                
            } else {
                
                cell.picView.image = self.openintentionImages[indexPath.item];
                cell.deleteButton.hidden = NO;
                
            }
            
        }
        
        cell.delegate = self;
        
        cell.indexpath = indexPath;
        
        return cell;
    }
    
    return nil;
}


- (void)setScrollContent {
    
    self.centerHeight = self.centerView.collectionViewLayout.collectionViewContentSize.height;
    
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.height.mas_equalTo(self.labelsArr.count > 1 ? self.centerHeight : 30);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    self.scrollView.contentSize = CGSizeMake(0, self.topHeight + self.centerHeight + self.openHeight + self.secretHeight + 16 + 20);
    
}

- (void)updateViewConstraints {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.height.mas_equalTo(kTextViewHeight);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    // 计算标签栏高度
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.height.mas_equalTo(self.centerHeight > 30 ? self.centerView.collectionViewLayout.collectionViewContentSize.height : 30);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    //    [self.openHeader mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.top.mas_equalTo(self.centerView.mas_bottom).offset(4);
    //        make.width.left.mas_equalTo(self.centerView);
    //        make.height.mas_equalTo(30);
    //
    //    }];
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.centerView.mas_bottom);
        make.width.left.mas_equalTo(self.centerView);
        //        make.height.mas_equalTo(kItemWidth*3 + 24);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(65);
        
    }];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_offset(-11);
        make.centerY.mas_offset(0);
    }];
    
    
    self.topHeight = 175;
    self.openHeight = 40 + KImgBottom + kItemWidth;
    self.secretHeight = 40 + KImgBottom + kItemWidth;
    
    //    self.scrollView.contentSize = CGSizeMake(0, self.topHeight + self.centerHeight + self.openHeight + self.secretHeight + 16 + 20);
    
    
    //    [self setScrollContent];
    
    [super updateViewConstraints];
}

#pragma mark - 监听textView
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        
        self.publishButton.enabled = YES;
        
    } else {
        
        self.publishButton.enabled = NO;
        
        
    }
    
}
#pragma mark - 占位符相关
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeHolderLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.placeHolderLabel.alpha = 1;
    }
    return YES;
}

- (void)setupnavigationButton {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 60, 21))];;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton setTitle:@"取消" forState:(UIControlStateNormal)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    _publishButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 40, 21))];;
    [_publishButton setTitle:@"发布" forState:(UIControlStateNormal)];
    [_publishButton setTitleColor:UIColorHex(808080) forState:(UIControlStateDisabled)];
    [_publishButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_publishButton];
    _publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _publishButton.enabled = NO;
    [_publishButton addTarget:self action:@selector(clickPublishButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    
    if (operation == UINavigationControllerOperationPush) {
        
        [XFPublishTransation transitionWithtype:Push];
    }
    
    if (operation == UINavigationControllerOperationPop) {
        
        
    }
    
    return nil;
    
}

- (NSArray *)titleArr {
    
    if (_titleArr == nil) {
        
        _titleArr = @[@"添加/编辑标签",@""];
    }
    return _titleArr;
}

- (NSMutableArray *)labelsArr {
    
    if (_labelsArr == nil) {
        
        _labelsArr = [NSMutableArray array];
    }
    return _labelsArr;
}

- (NSMutableArray *)openintentionImages {
    
    if (_openintentionImages == nil) {
        
        _openintentionImages = [NSMutableArray array];
    }
    return _openintentionImages;
}

- (void)clickBackButton {
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
