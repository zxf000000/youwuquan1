//
//  XFAddImageViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/21.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAddImageViewController.h"
#import "XFPublishTransation.h"
#import "XFLabelCollectionViewCell.h"
#import "XFHistoryViewRowsCaculator.h"
#import "XFPublishAddImageViewCollectionViewCell.h"
#import "XFImagePickerViewController.h"
#import "XFSelectLabelViewController.h"
#import "XFStatusNetworkManager.h"

#define kImgInset 12
#define kImgPadding 2
#define kItemWidth (kScreenWidth - 20 - 6)/3
#define KImgBottom 15


@interface XFAddImageViewController () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,XFImagePickerDelegate,XFSelectTagVCDelegate,XFpublishCollectionCellDelegate>

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

@end

@implementation XFAddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布";

    [self setupnavigationButton];
    [self setupScrolLView];
    [self setupOtherView];
    
    [self.view setNeedsUpdateConstraints];
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
    
    if (self.video.count == 0 || self.video == nil) {
        
        if (self.secintentionImages.count > 0 && [self.diamondTextField.text integerValue] <= 0) {
            
            [XFToolManager showProgressInWindowWithString:@"轻为私密相册设置解锁金额"];
            
            return;
        }
        
        if (self.openintentionImages.count == 0 && self.secintentionImages.count > 0) {
            [XFToolManager showProgressInWindowWithString:@"请至少选择一张公开图片"];
            
            return;
            
        }
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在发布"];
        
        NSString *type;
        
        if ((self.openintentionImages.count + self.secintentionImages.count) > 0) {
            
            type =  @"2";
        } else {
            
            type =  @"1";

        }
        
        NSArray *albums = [XFUserInfoManager sharedManager].userInfo[@"albums"];
        
        // 上传图片文字
        [XFStatusNetworkManager publishStatusWithopenAlbumId:albums[1][@"id"] intimateAlbumId:albums[2][@"id"] opens:self.openintentionImages intimates:self.secintentionImages type:type title:self.textView.text unlockNum:self.diamondTextField.text customLabel:@"好" labels:@"1,2" successBlock:^(NSDictionary *reponseDic) {
            [HUD hideAnimated:YES];

            if (reponseDic) {
                
//                [XFToolManager changeHUD:HUD successWithText:@"发布成功"];
                [XFToolManager showProgressInWindowWithString:@"发布成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        // 刷新动态页面通知
                        
                        
                    }];
                });

                
            }
            
            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];
            
        }];
        
    } else {
        
        // 上传视频
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
    self.openButton = [[UIButton alloc] init];
    [self.openButton setImage:[UIImage imageNamed:@"photovault_hui"] forState:(UIControlStateNormal)];
    [self.openButton setTitle:@"公开照片" forState:(UIControlStateNormal)];
    [self.openButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.openButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.openButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [self.openHeader addSubview:self.openButton];

    // 私密
    UICollectionViewFlowLayout *secLayout = [[UICollectionViewFlowLayout alloc] init];
    secLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    secLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    secLayout.minimumLineSpacing = 2;
    secLayout.minimumInteritemSpacing = 2;
    self.secretView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:secLayout];
    
    self.secretView.backgroundColor = [UIColor whiteColor];
    
    self.secretView.delegate = self;
    self.secretView.dataSource = self;
    
    [self.secretView registerNib:[UINib nibWithNibName:@"XFPublishAddImageViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell"];

    [self.scrollView addSubview:self.secretView];
    
    self.secretHeader = [[UIView alloc] init];
    
    self.secretHeader.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:self.secretHeader];
    
    self.secretButton = [[UIButton alloc] init];
    [self.secretButton setImage:[UIImage imageNamed:@"photovault_cai"] forState:(UIControlStateNormal)];
    [self.secretButton setTitle:@"私密照片" forState:(UIControlStateNormal)];
    [self.secretButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.secretButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.secretButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.secretHeader addSubview:self.secretButton];

    // 小控件
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = @"钻石解锁查看";
    self.detailLabel.textColor = [UIColor blackColor];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    [self.secretHeader addSubview:self.detailLabel];
    
    self.diamondTextField = [[UITextField alloc] init];
    self.diamondTextField.text = @"10";
    self.diamondTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.diamondTextField.textAlignment = NSTextAlignmentRight;
    [self.secretHeader addSubview:self.diamondTextField];



}
#pragma mark - imagepickerdelegate
- (void)XFImagePicker:(XFImagePickerViewController *)imagePicker didSelectedImagesWith:(NSArray *)images {
    
    if (self.isOpenImage) {
        
        [self.openintentionImages addObjectsFromArray:images];

        [self reloadImageViewHeight];
        [self.openView reloadData];


    } else {
        
        [self.secintentionImages addObjectsFromArray:images];
        
        [self reloadImageViewHeight];
        [self.secretView reloadData];

        
    }
    [self setScrollContent];
    
    
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

#pragma mark - 图片选择collectionViewCellDelegate
- (void)publishCollectionCell:(XFPublishAddImageViewCollectionViewCell *)cell didClickDeleteButtonWithIndexPath:(NSIndexPath *)indexPath {
    
    if([self.openView.visibleCells containsObject:cell]) {
        
        // 公开的
        [self.openintentionImages removeObjectAtIndex:indexPath.item];
        [self.openView reloadData];
        
    } else {
        
        // 私密的
        [self.secintentionImages removeObjectAtIndex:indexPath.item];
        [self.secretView reloadData];
        
    }

    [self reloadImageViewHeight];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.centerView) {
        
        XFSelectLabelViewController *selectLabelVC = [[XFSelectLabelViewController alloc] init];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.labelsArr];
        
        [arr removeLastObject];
        
        selectLabelVC.labelsArr = arr;
        
        selectLabelVC.delegate = self;
        
        [self.navigationController pushViewController:selectLabelVC animated:YES];
        
    } else if (collectionView == self.openView) {
        
        XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
        
        imagePicker.delegate = self;
        
        self.isOpenImage = YES;
        
        imagePicker.selectedNumber = self.openintentionImages.count + self.secintentionImages.count;
        
        [self.navigationController pushViewController:imagePicker animated:YES];
    
    } else if (collectionView == self.secretView) {
        
        XFImagePickerViewController *imagePicker = [[XFImagePickerViewController alloc] init];
        
        imagePicker.delegate = self;

        self.isOpenImage = NO;
        imagePicker.selectedNumber = self.openintentionImages.count + self.secintentionImages.count;

        [self.navigationController pushViewController:imagePicker animated:YES];
        
    }
    
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
    } else  {
        
        if (self.secintentionImages.count == 9) {
            
            return self.secintentionImages.count;
        } else {
            
            return self.secintentionImages.count + 1;
            
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
//            [self.centerView.collectionViewLayout invalidateLayout];
//            [self.centerView deleteItemsAtIndexPaths:@[indexpath]];
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
                
                cell.picView.image = [UIImage imageNamed:@"my_add"];
                
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
    } else  {
        
        XFPublishAddImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFPublishAddImageViewCollectionViewCell" forIndexPath:indexPath];
        
        if (self.secintentionImages.count == 9) {
            
            cell.picView.image = self.secintentionImages[indexPath.item];
            cell.deleteButton.hidden = NO;
            
            
        } else {
            
            if (indexPath.item == self.secintentionImages.count) {
                
                cell.picView.image = [UIImage imageNamed:@"my_add"];
                
                cell.deleteButton.hidden = YES;
                [cell removeTap];

            } else {
                
                cell.picView.image = self.secintentionImages[indexPath.item];
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
    [self.openHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.centerView.mas_bottom).offset(4);
        make.width.left.mas_equalTo(self.centerView);
        make.height.mas_equalTo(30);
        
    }];
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.openHeader.mas_bottom);
        make.width.left.mas_equalTo(self.openHeader);
        make.height.mas_equalTo([self heightForOpenIntentionView]);
        
    }];
    [self.secretHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.openView.mas_bottom).offset(4);
        make.width.left.mas_equalTo(self.openView);
        make.height.mas_equalTo(30);
        
    }];
    [self.secretView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.secretHeader.mas_bottom);
        make.width.left.mas_equalTo(self.secretHeader);
        make.height.mas_equalTo([self heightForSecIntentionView]);
        
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    [self.secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.right.mas_offset(-20);
        
        
    }];
    
    [self.diamondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.detailLabel.mas_left).offset(-10);
        make.height.mas_equalTo(20);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(130);
        
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
