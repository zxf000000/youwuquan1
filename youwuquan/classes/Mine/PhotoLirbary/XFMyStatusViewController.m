//
//  XFMyStatusViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyStatusViewController.h"
#import "XFStatusDetailViewController.h"

@implementation XFMyStatusCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_scrollView];
        _scrollView.frame = self.bounds;
        
        _picView = [[UIImageView alloc] init];
        _picView.frame = CGRectMake(0, 0, frame.size.width, CGRectGetHeight(frame));
        _picView.contentMode = UIViewContentModeScaleAspectFit;
        _picView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_picView];
        
        _scrollView.delegate = self;
        //设置最大放大倍数，默认是1.0
        _scrollView.maximumZoomScale = 3.0;
        //设置最小缩小倍数，默认是1.0
        _scrollView.minimumZoomScale = 0.5;
        //设置默认缩放倍数，默认是1.0
        _scrollView.zoomScale = 1.0;
        //是否打开缩放回弹效果，默认是YES
        _scrollView.bouncesZoom = YES;
        
    }
    return self;
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
    self.picView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    view.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
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

@end

@implementation XFMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公开相册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:(UIControlStateNormal)];
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    [deleteButton addTarget:self action:@selector(clickdeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self initCollectionView];
    [self initBottomView];
    [self initContnetView];

}

- (void)clickCommentButton {
    
    XFStatusDetailViewController *statusDetail = [[XFStatusDetailViewController alloc] init];
    statusDetail.type = Mine;
    [self.navigationController pushViewController:statusDetail animated:YES];
    
}

- (void)clickdeleteButton {
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyStatusCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"XFMyStatusCell" forIndexPath:indexPath];
    
    cell.picView.image = [UIImage imageNamed:@"find_pic15"];
    
    return cell;
    
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - 64);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XFMyStatusCell class] forCellWithReuseIdentifier:@"XFMyStatusCell"];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
}

- (void)initBottomView {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 64 - 44, kScreenWidth, 44);
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
    
    [self.commentButton addTarget:self action:@selector(clickCommentButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.likeButton addTarget:self action:@selector(clickCommentButton) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)initContnetView {
    
    NSString *content  = @"我只想写首对于我来说有意思的诗,可总是被所有必须要理会的事打扰,回微信看邮件定计划收快递接电话,唯独任何一句牛逼的话语都没写下";
    
    CGRect stringFrame = [content boundingRectWithSize:(CGSizeMake(kScreenWidth - 27, MAXFLOAT)) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
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

@end
