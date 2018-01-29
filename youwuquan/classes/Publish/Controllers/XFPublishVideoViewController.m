//
//  XFAddImageViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFPublishVideoViewController.h"
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


#define kImgInset 12
#define kImgPadding 2
#define kItemWidth (kScreenWidth - 20 - 6)/3
#define KImgBottom 15


@interface XFPublishVideoViewController () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,XFImagePickerDelegate,XFSelectTagVCDelegate,XFpublishCollectionCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PLShortVideoUploaderDelegate,CustomeImagePickerDelegate>

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

@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) UIButton *doneButton;
@property (nonatomic,strong) UIView *priceView;
@end


static NSString *const kUploadToken = @"MqF35-H32j1PH8igh-am7aEkduP511g-5-F7j47Z:clOQ5Y4gJ15PnfZciswh7mQbBJ4=:eyJkZWxldGVBZnRlckRheXMiOjMwLCJzY29wZSI6InNob3J0LXZpZGVvIiwiZGVhZGxpbmUiOjE2NTUyNjAzNTd9";
static NSString *const kURLPrefix = @"http://shortvideo.pdex-service.com";

@implementation XFPublishVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布";

    [self setupnavigationButton];
    [self setupScrolLView];
    [self setupOtherView];
    [self prepareUpload];
    
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
    
    if (self.openSwitch.on) {
        
        [self outShadowView];
        
    } else {
        
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
        
        __block MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        HUD.progress = 0;
        
        // 上传封面图片
        [XFFindNetworkManager uploadFileWithData:UIImageJPEGRepresentation(self.videoImage, 1) successBlock:^(id responseObj) {
            
            NSString *coverUrl = ((NSDictionary *)responseObj)[@"url"];
            
            // 上传视频
            [XFFindNetworkManager publishWithType:@"video" title:@"test" unlockPrice:[self.diamondTextField.text longValue] labels:labels text:self.textView.text srcTypes:@"open" images:nil videoCoverUrl:coverUrl videoUrl:_videoPath videoWidth:self.videoWidth videoHeight:self.videoHeight successBlock:^(id responseObj) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        // 刷新动态页面通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
                        
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
            
        } failBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        } progress:^(CGFloat progress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                HUD.progress = progress;

            });
            
        }];
    
//        // 上传成功之后要删除本地数据
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        NSError *err;
//        [fileMgr createDirectoryAtPath:self.videoPath withIntermediateDirectories:YES attributes:nil error:&err];
//        BOOL bRet = [fileMgr fileExistsAtPath:self.videoPath];
//        if (bRet) {
//            //
//            NSError *err;
//            [fileMgr removeItemAtPath:self.videoPath error:&err];
//        }
    
        
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
    [self.scrollView addSubview:self.textView];
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
    [self.scrollView addSubview:self.centerView];
    
    // 公开图片
    self.openHeader = [[UIView alloc] init];
    
    self.openHeader.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.openHeader];
    
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

    [self.scrollView addSubview:self.openView];

    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = UIColorHex(e0e0e0);
    [self.view addSubview:self.bottomView];
    
    self.openSwitch = [[UISwitch alloc] init];
    self.openSwitch.tintColor = kMainRedColor;
    self.openSwitch.onTintColor = kMainRedColor;
    [self.bottomView addSubview:self.openSwitch];
    
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
    
    
    self.shadowView = [[UIView alloc] init];
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.shadowView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    self.shadowView.alpha = 0;
    [self.view addSubview:self.shadowView];
    
    self.priceView = [[UIView alloc] init];
    self.priceView.backgroundColor = [UIColor whiteColor];
    self.priceView.layer.cornerRadius = 10;
    [self.view addSubview:self.priceView];
    
    self.priceView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 120);
    
    self.priceTextField = [[UITextField alloc] init];
    self.priceTextField.placeholder = @"请输入查看价格";
    self.priceTextField.frame = CGRectMake(30, 25, kScreenWidth - 60, 25);
    [self.priceView addSubview:self.priceTextField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(808080);
    lineView.frame = CGRectMake(10, self.priceTextField.bottom + 5, kScreenWidth - 20, 1);
    [self.priceView addSubview:lineView];
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.backgroundColor = kMainRedColor;
    [self.doneButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.priceView addSubview:self.doneButton];
    self.doneButton.frame = CGRectMake(0, lineView.bottom + 19, kScreenWidth, 50);
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.doneButton.layer.cornerRadius = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)];
    [self.shadowView addGestureRecognizer:tap];
    
}

- (void)tapShadow {
    
    [self hideShadow];
    
}

- (void)clickDoneButton {
    
    if ([self.priceTextField.text intValue] <= 0) {
        
        [XFToolManager showProgressInWindowWithString:@"请设置正确的钻石数量"];
        
        return;
        
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
    
    __block MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.progress = 0;
    
    // 上传封面图片
    [XFFindNetworkManager uploadFileWithData:UIImageJPEGRepresentation(self.videoImage, 1) successBlock:^(id responseObj) {
        
        NSString *coverUrl = ((NSDictionary *)responseObj)[@"url"];
        // 上传视频
        [XFFindNetworkManager publishWithType:@"video" title:@"video" unlockPrice:[self.priceTextField.text intValue] labels:labels text:self.textView.text srcTypes:@"close" images:nil videoCoverUrl:coverUrl videoUrl:_videoPath videoWidth:self.videoWidth videoHeight:self.videoHeight successBlock:^(id responseObj) {
            
            [self hideShadow];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
                
                
                
                [self dismissViewControllerAnimated:YES completion:^{
                    // 刷新动态页面通知
                    
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
        
    } failBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
    } progress:^(CGFloat progress) {
        
        
    }];
    
}

- (void)hideShadow {
    
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.priceView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 120);
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.shadowView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
    
}

- (void)outShadowView {
    
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    [UIView animateWithDuration:0.2 animations:^{
        
        self.priceView.frame = CGRectMake(0, kScreenHeight - 120 - 64, kScreenWidth, 120);
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

// 重新计算高度
- (void)reloadImageViewHeight {
    
    self.secretHeight = 30 + [self heightForSecIntentionView];

    [self.secretView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.secretHeader.mas_bottom);
        make.width.left.mas_equalTo(self.secretHeader);
        make.height.mas_equalTo(self.secretHeight);

    }];
    
    self.openHeight = 30 + [self heightForOpenIntentionView];

    [self.openView mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.openHeader.mas_bottom);
        make.width.left.mas_equalTo(self.openHeader);
        make.height.mas_equalTo(self.openHeight);

    }];
}

#pragma mark - 标签选择器代理
- (void)selecteTagVC:(XFSelectLabelViewController *)selecteVC didSelectedTagsWith:(NSArray *)tags {
    
    self.labelsArr = [NSMutableArray arrayWithArray:tags];
    
    [self.labelsArr addObject:@""];
    
    [self.centerView reloadData];
    
    [self.centerView layoutIfNeeded];

    [self setScrollContent];
    
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
        

    }
  
}

#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
 
    if(info.error){
        
        [XFToolManager changeHUD:self.uploadProgressHUD successWithText:[NSString stringWithFormat:@"上传失败%@",info]];
        
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
        
        return 1;
        

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

                cell.picView.image = self.videoImage;
                cell.deleteButton.hidden = NO;
        
        cell.deleteButton.hidden = YES;
    
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
        make.height.mas_equalTo(175);
        make.width.mas_equalTo(kScreenWidth);
        
    }];
    
    // 计算标签栏高度
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(4);
        make.height.mas_equalTo(self.centerHeight > 30 ? self.centerView.collectionViewLayout.collectionViewContentSize.height : 30);
        make.width.mas_equalTo(kScreenWidth);
        
    }];

    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.centerView.mas_bottom);
        make.width.left.mas_equalTo(self.centerView);
        make.height.mas_equalTo([self heightForOpenIntentionView]);
        
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

#pragma mark - 计算图片View高度
- (CGFloat)heightForOpenIntentionView {
    
    NSInteger count = self.openintentionImages.count + 1;
    
    if (count <= 3) {
        
        return kItemWidth + 20;
        
    }
    
    if (count>3 &&count <=6) {
        
        return kItemWidth*2 + 22;
    }
    
    if (count>6) {
        
        return kItemWidth*3 + 24;
    }
    
    return 0;
}

- (CGFloat)heightForSecIntentionView {
    
    NSInteger count = self.secintentionImages.count + 1;
    
    if (count <= 3) {
        
        return kItemWidth + 20;
        
    }
    
    if (count>3 &&count <=6) {
        
        return kItemWidth*2 + 22;
    }
    
    if (count>6) {
        
        return kItemWidth*3 + 24;
    }
    
    return 0;
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

- (NSMutableArray *)secintentionImages {
    
    if (_secintentionImages == nil) {
        
        _secintentionImages = [NSMutableArray array];
    }
    return _secintentionImages;
}



- (void)clickBackButton {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
