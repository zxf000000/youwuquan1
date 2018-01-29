//
//  XFShareUrlViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFShareUrlViewController.h"
#import "XFShareManager.h"

@implementation XFShareUrlCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _picView = [[UIImageView alloc] init];
        _picView.layer.cornerRadius = 10;
        _picView.layer.masksToBounds = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.image = [UIImage imageNamed:@"zhanweitu22"];
        [self.contentView addSubview:_picView];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_picView addSubview:_effectView];

        
        _photoButton = [[UIButton alloc] init];
        [_photoButton setImage:[UIImage imageNamed:@"shareurl_xiangce"] forState:(UIControlStateNormal)];
        
        [self.contentView addSubview:_photoButton];
        
        _selectedButton = [[UIButton alloc] init];
        [_selectedButton setTitle:@"选中" forState:(UIControlStateNormal)];
        [_selectedButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_selectedButton setBackgroundColor:kMainRedColor];
        [self.contentView addSubview:_selectedButton];
        
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);

    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
        
    }];
    
    
    [super updateConstraints];
    
}

@end

@interface XFShareUrlViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) UIButton *doneButton;

@end

@implementation XFShareUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *caramerButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
    [caramerButton setImage:[UIImage imageNamed:@"shareurl_xiangji"] forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:caramerButton];
    
    [caramerButton addTarget:self action:@selector(clickCaramerButton) forControlEvents:(UIControlEventTouchUpInside)];

    [self setupCollectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFShareUrlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFShareUrlCell" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        
        cell.effectView.hidden = NO;
        cell.photoButton.hidden = NO;
        cell.selectedButton.hidden = NO;
        cell.selectedButton.backgroundColor = [UIColor whiteColor];
        [cell.selectedButton setTitle:@"从相册中选择" forState:(UIControlStateNormal)];
        [cell.selectedButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
    } else {
        
        cell.effectView.hidden = YES;
        cell.photoButton.hidden = YES;

        cell.selectedButton.backgroundColor = kMainColor;
        [cell.selectedButton setTitle:@"已选择" forState:(UIControlStateNormal)];
        [cell.selectedButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        if (self.selectedIndexPath == indexPath) {
            
            cell.selectedButton.hidden = NO;
        } else {
            
            cell.selectedButton.hidden = YES;

        }
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
    } else {
        

        
        self.selectedIndexPath = indexPath;
        
        [self.collectionView reloadData];
        
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        [XFShareManager sharedUrlImageWithBg:@"shareurl_bg" icon:image url:[XFUserInfoManager sharedManager].userInfo[@"inviteUrl"]];
        
    }];
    
}


- (void)clickCaramerButton {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)clickDoneButton {
    
    XFShareUrlCell *cell = (XFShareUrlCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    
    [XFShareManager sharedUrlImageWithBg:@"shareurl_bg" icon:cell.picView.image url:[XFUserInfoManager sharedManager].userInfo[@"inviteUrl"]];

    
}


- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((kScreenWidth - 15)/2, (kScreenWidth - 15)/2 * 41/36.f);
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)) collectionViewLayout:layout];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[XFShareUrlCell class] forCellWithReuseIdentifier:@"XFShareUrlCell"];
    
    [self.view addSubview:self.collectionView];
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.frame = CGRectMake(0, kScreenHeight - 64 - 49, kScreenWidth, 49);
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.doneButton setTitle:@"分享" forState:(UIControlStateNormal)];
    self.doneButton.backgroundColor = kMainRedColor;
    [self.view addSubview:self.doneButton];
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}


@end
