//
//  XFMyStatusViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyStatusViewController.h"
#import "XFStatusDetailViewController.h"
#import "XFYwqAlertView.h"

@implementation XFMyStatusCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_scrollView];
        _scrollView.frame = self.bounds;
        
        _picView = [[UIImageView alloc] init];
        _picView.frame = CGRectMake(0, 0, frame.size.width, CGRectGetHeight(frame));
        _picView.contentMode = UIViewContentModeScaleAspectFit;
        _picView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_picView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapPic:)];
        tap.numberOfTapsRequired = 2;
        _picView.userInteractionEnabled = YES;
        
        [_picView addGestureRecognizer:tap];
        
        _scrollView.delegate = self;
        //设置最大放大倍数，默认是1.0
        _scrollView.maximumZoomScale = 3.0;
        //设置最小缩小倍数，默认是1.0
        _scrollView.minimumZoomScale = 1;
        //设置默认缩放倍数，默认是1.0
        _scrollView.zoomScale = 1.0;
        //是否打开缩放回弹效果，默认是YES
        _scrollView.bouncesZoom = YES;
        
        _HUD = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];

        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.progress = 0.9;
        _HUD.animationType = MBProgressHUDAnimationZoom;
        _HUD.minShowTime = 0.3;
        _HUD.removeFromSuperViewOnHide = YES;

        _HUD.contentColor = [UIColor whiteColor];

        _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _HUD.bezelView.backgroundColor = [UIColor clearColor];

        self.userInteractionEnabled = NO;
        _HUD.progress = 0;
    }
    return self;
}

- (void)setUrl:(NSString *)url {
    
    _url = url;
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:_url] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            _HUD.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;

        });


    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {

        return image;


    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {

        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (error) {
                _HUD.mode = MBProgressHUDModeText;
                _HUD.label.text = @"加载失败,请稍后重试";
                [_HUD hideAnimated:YES afterDelay:0.5];
                return;
            }
            
            [_HUD hideAnimated:YES afterDelay:0.5];
            self.picView.image = image;
            self.userInteractionEnabled = YES;


        });

    }];
    
}

- (void)doubleTapPic:(UITapGestureRecognizer *)tap {
    
    if (self.scrollView.zoomScale == 2) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _scrollView.zoomScale = 1;

        }];

    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _scrollView.zoomScale = 2;
            
        }];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //返回需要缩放的子视图
    return self.picView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    //缩放前调用
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //正在缩放时调用

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    
}
@end

@interface XFMyStatusViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) UIButton *commentButton;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIView *myNavigationbar;

@property (nonatomic,assign) BOOL barIsHide;

@property (nonatomic,copy) NSArray *picArr;

@property (nonatomic,assign) NSInteger number;


@end

@implementation XFMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.type == XFMyStatuVCTypeMine) {
        
        self.title = @"日期";

    } else {
        
        self.title = @"名字";

    }
    
    self.number = 2;
    NSMutableArray *allImg = [NSMutableArray array];
    
    [allImg addObjectsFromArray:self.model.openImageList];
    [allImg addObjectsFromArray:self.model.intimateImageList];

    self.picArr = allImg.copy;
    
    [self initCollectionView];
    [self initBottomView];
    [self initContnetView];
    [self setupNavigationBar];
    
    [self setDatas];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapView];


}

// 初始化数据
- (void)setDatas {
    
    self.contentLabel.text = self.model.title;
    [self.commentButton setTitle:self.model.messageNum forState:(UIControlStateNormal)];
    [self.likeButton setTitle:self.model.greatNum forState:(UIControlStateNormal)];
    
}

- (void)clickMyBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 单击底部View
- (void)tapBottomView {
    
    [self clickCommentButton];
    
}

- (void)tapView {
 
    if (self.barIsHide) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.myNavigationbar.frame = CGRectMake(0, -64, kScreenWidth, 64);
            self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
            [self.view layoutIfNeeded];

        } completion:^(BOOL finished) {
            
            self.barIsHide = NO;
        }];
        
        
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.myNavigationbar.frame = CGRectMake(0, 0, kScreenWidth, 64);
            self.bottomView.frame = CGRectMake(0, kScreenHeight -44, kScreenWidth, 44);
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            self.barIsHide = YES;
        }];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)clickCommentButton {
    
    if (self.type == XFMyStatuVCTypeMine) {
        
        XFStatusDetailViewController *statusDetail = [[XFStatusDetailViewController alloc] init];
        statusDetail.type = Mine;
        statusDetail.status = self.model;
        [self.navigationController pushViewController:statusDetail animated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSLog(@"%f---",scrollView.contentOffset.x);

    if (self.number == 4) {
        
        return;
    }
    
    if (scrollView.contentOffset.x > kScreenWidth) {
        
        // TODO:
        XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"请先解锁" detail:@"解锁本条动态需要66钻石,是否支付"];
        
        alertView.doneBlock = ^{
            
            //            [XFToolManager showProgressInWindowWithString:@"余额不足,请充值"];
            //            // 充值页面
            //            XFPayViewController *payVC = [[XFPayViewController alloc] init];
            //            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
            //            [self presentViewController:navi animated:YES completion:nil];
            
            // 充值成功,刷新页面
            
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];
            
            [HUD hideAnimated:YES afterDelay:0.8];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 刷新页面
                self.number = 4;
                [self.collectionView reloadData];
                
            });
        };
        
        alertView.cancelBlock = ^{
            
            // 取消
            
        };
        
        [alertView showAnimation];
    }
}

- (void)clickdeleteButton {
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count;
    if (self.picArr.count > 0) {
        
        count = self.picArr.count;
        
    } else {
        
        count = self.number;
    }
    
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyStatusCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"XFMyStatusCell" forIndexPath:indexPath];
    
    cell.picView.image = [UIImage imageNamed:[NSString stringWithFormat:@"find%zd",indexPath.row + 1]];
    
    
    if (self.picArr.count > 0) {
        
        NSDictionary *imgInfo = self.picArr[indexPath.item];
        
        cell.url = imgInfo[@"breviaryUrl"];
    }

    return cell;
    
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XFMyStatusCell class] forCellWithReuseIdentifier:@"XFMyStatusCell"];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.collectionView.pagingEnabled = YES;
    
//    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    
    [self.view addSubview:self.collectionView];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
    [self.view addSubview:self.bottomView];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentCenter)];
    [self.bottomView addSubview:self.timeLabel];
    self.timeLabel.text = @"2017年1月10日";
    
    self.commentButton = [[UIButton alloc] init];
    [self.commentButton setImage:[UIImage imageNamed:@"whitecomment"] forState:(UIControlStateNormal)];
    [self.commentButton setTitle:@"210" forState:(UIControlStateNormal)];
    [self.bottomView addSubview:self.commentButton];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    self.likeButton = [[UIButton alloc] init];
    [self.likeButton setImage:[UIImage imageNamed:@"home_like"] forState:(UIControlStateNormal)];
    [self.likeButton setTitle:@"210" forState:(UIControlStateNormal)];
    [self.bottomView addSubview:self.likeButton];
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:12];

    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(13.5);
        make.centerY.mas_offset(0);
        
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-18);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(80);
        
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.commentButton.mas_left).offset(-18);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(80);
        
    }];
    
    UITapGestureRecognizer *tapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottomView)];
    
    [self.bottomView addGestureRecognizer:tapBottom];
    
    [self.commentButton addTarget:self action:@selector(clickCommentButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.likeButton addTarget:self action:@selector(clickCommentButton) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)initContnetView {
    
    NSString *content  = @"我只想写首对于我来说有意思的诗,可总是被所有必须要理会的事打扰,回微信看邮件定计划收快递接电话,唯独任何一句牛逼的话语都没写下";
    
    CGRect stringFrame = [content boundingRectWithSize:(CGSizeMake(kScreenWidth - 27, MAXFLOAT)) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.contentView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(13.5, 10, kScreenWidth - 27, stringFrame.size.height);
    [self.contentLabel setFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentLeft)];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.text = content;
    self.contentLabel.numberOfLines = 0;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.height.mas_equalTo(stringFrame.size.height + 20);
        make.left.right.mas_offset(0);
        
    }];
}


- (void)setupNavigationBar {
    
    self.myNavigationbar = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 64))];
    [self.view addSubview:self.myNavigationbar];
    
    self.myNavigationbar.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    UIButton *backButton = [[UIButton alloc] init];
    
    [backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    backButton.frame = CGRectMake(0, 20, 60, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
    [self.myNavigationbar addSubview:backButton];
    
    [backButton addTarget:self action:@selector(clickMyBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.text = self.title;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [self.myNavigationbar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(20);
        make.centerX.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    [deleteButton setImage:[UIImage imageNamed:@"status_delete"] forState:(UIControlStateNormal)];
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    [deleteButton addTarget:self action:@selector(clickdeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myNavigationbar addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(44);
        
        make.width.mas_equalTo(60);
        
    }];
}
@end
