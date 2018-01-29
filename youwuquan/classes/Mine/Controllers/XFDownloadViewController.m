//
//  XFDownloadViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/29.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFDownloadViewController.h"
#import "XFMineNetworkManager.h"

@implementation XFDownPicModel


@end

@implementation XFDownloadPicCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _picView = [[UIImageView alloc] init];
        [self.contentView addSubview:_picView];
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_offset(0);
            
        }];
    }
    return self;
}

@end

@implementation XFDownloadPicHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView setMyShadow];
        
        _desLabel = [[UILabel alloc] init];
        [_desLabel setFont:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor] aligment:(NSTextAlignmentCenter)];
        _desLabel.text = @"获取您拍摄作品日期倒计时";
        [_headerView addSubview:_desLabel];
        
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont systemFontOfSize:30] textColor:[UIColor blackColor] aligment:(NSTextAlignmentCenter)];
        _numberLabel.text = @"0";
        [_headerView addSubview:_numberLabel];
        
        _daylabel = [[UILabel alloc] init];
        [_daylabel setFont:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor] aligment:(NSTextAlignmentCenter)];
        _daylabel.text = @"天";
        [_headerView addSubview:_daylabel];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_offset(0);
            make.top.mas_offset(28);
            
        }];
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_offset(0);
            make.top.mas_equalTo(_desLabel.mas_bottom).offset(15);
        }];
        
        [_daylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(_numberLabel);
            make.left.mas_equalTo(_numberLabel.mas_right).offset(7.5);
        }];
        
        [self addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset(10);
            make.top.mas_offset(15);
            make.right.mas_offset(-10);
            make.bottom.mas_offset(-10);
            
        }];

    }
    return self;
}

@end

@interface XFDownloadViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *picView;

@property (nonatomic,strong) UIButton *downloadButton;

@property (nonatomic,copy) NSArray *datas;

@end

@implementation XFDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCollectionView];
    
    [self setupdownloadButton];
    [self.view setNeedsUpdateConstraints];
    
    [self loadData];
}

- (void)clickDownloadButton {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    __block NSInteger count = 0;
    HUD.label.text = [NSString stringWithFormat:@"%zd/%zd",count,self.datas.count];
    
    for (NSInteger i = 0 ; i < self.datas.count; i ++ ) {
        XFDownPicModel *model = self.datas[i];
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:model.image[@"imageUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
           
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

            count += 1;
            if (count == self.datas.count) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [HUD hideAnimated:YES];

                });
                
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    HUD.label.text = [NSString stringWithFormat:@"%zd/%zd",count,self.datas.count];

                });
            }
            
        }];
        
    }
    
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
}



- (void)loadData {
    
    MBProgressHUD *HUD  = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFMineNetworkManager getMyDownloadPicsWithsuccessBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];
        
        NSDictionary *dic = (NSDictionary *)responseObj;
        NSArray *datas = dic[@"photographs"][@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFDownPicModel modelWithDictionary:datas[i]]];
            
        }
        
        self.datas = arr.copy;

        [self.picView reloadData];
        
        
    } failedBlock:^(NSError *error) {
        
        [HUD hideAnimated:YES];
        
        if (error == nil) {
            
            self.datas = [NSArray array];
            [self.picView reloadData];
            
        }

    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 155);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        XFDownloadPicHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"XFDownloadPicHeader" forIndexPath:indexPath];
        
        return header;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFDownloadPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFDownloadPicCell" forIndexPath:indexPath];
    
    XFDownPicModel *model = self.datas[indexPath.item];
    [cell.picView setImageWithURL:[NSURL URLWithString:model.image[@"thumbImage300pxUrl"]] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    
    return cell;
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWidth = (kScreenWidth - 15)/2;
    CGFloat itemHeight = 41/36.f * itemWidth;
    layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.picView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44)) collectionViewLayout:layout];
    
    self.picView.delegate = self;
    self.picView.dataSource = self;
    [self.picView registerClass:[XFDownloadPicCell class] forCellWithReuseIdentifier:@"XFDownloadPicCell"];
    [self.picView registerClass:[XFDownloadPicHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XFDownloadPicHeader"];
    [self.view addSubview:self.picView];
    self.picView.backgroundColor = UIColorHex(f4f4f4);
    
}

- (void)setupdownloadButton {
    
    self.downloadButton = [[UIButton alloc] init];
    self.downloadButton.frame = CGRectMake(0, kScreenHeight - 64 - 44, kScreenWidth, 44);
    [self.downloadButton setTitle:@"下载" forState:(UIControlStateNormal)];
    self.downloadButton.backgroundColor = kMainRedColor;
    [self.view addSubview:self.downloadButton];
    
    [self.downloadButton addTarget:self action:@selector(clickDownloadButton) forControlEvents:(UIControlEventTouchUpInside)];
    
}


@end
