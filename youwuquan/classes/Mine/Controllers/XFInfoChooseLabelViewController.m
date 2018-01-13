//
//  XFChooseLabelViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFInfoChooseLabelViewController.h"
#import "XFTagsModel.h"
#import "XFStatusNetworkManager.h"
#import "XFLoginNetworkManager.h"
#import "XFMineNetworkManager.h"

@implementation XFInfoChooseLabelcell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment =NSTextAlignmentCenter;
        _titleLabel.layer.borderColor = UIColorHex(808080).CGColor;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.cornerRadius = frame.size.height/2;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end

@interface XFInfoChooseLabelViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,copy) NSArray *labels;

@property (nonatomic,copy) NSArray *myTags;

@end

@implementation XFInfoChooseLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择标签";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTitles];
    [self setupCollectionView];
    
    [self getTags];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)getTags {
    
    // 获取自己的标签
    NSArray *myTags = [XFUserInfoManager sharedManager].userInfo[@"tags"];
    
    NSLog(@"%@",[XFUserInfoManager sharedManager].userInfo);
    
    NSMutableArray *allMyTags = [NSMutableArray array];
    for (NSInteger i = 0 ; i < myTags.count ; i ++ ) {
        
        [allMyTags addObject:[XFTagsModel modelWithDictionary:myTags[i]]];
        
    }
    
    self.myTags = allMyTags.copy;
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];
    // 获取标签
    [XFLoginNetworkManager getAllTagsWithprogress:^(CGFloat progress) {
        
        
    } successBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];

        NSArray *datas = (NSArray *)responseObj;

        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFTagsModel modelWithJSON:datas[i]]];
            
        }
        
        self.tags = arr.copy;
        
        [self.collectionView reloadData];
        
    } failBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    }];
    

    
    
}

- (void)clickDoneButton {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.view withText:@"正在保存"];
    
    NSString *string = @"";
    
    for (NSInteger i = 0 ; i < self.selectedlabels.count ; i ++ ) {
        
        XFTagsModel *model = self.selectedlabels[i];
        
        if (i == 0) {
            
            string = [string stringByAppendingString:model.id];
        } else {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }
        
    }
    
    if ([[XFUserInfoManager sharedManager].userInfo[@"basicInfo"][@"gender"] isEqualToString:@"male"]) {
        
        
        [XFMineNetworkManager followTagsWithTags:string successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
            
            // 完成,直接跳转
            [self.navigationController popViewControllerAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存失败,请检查网络设置"];
            
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFMineNetworkManager setTagsWithTags:string successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoKey object:nil];
            
            // 完成,直接跳转
            [self.navigationController popViewControllerAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存失败,请检查网络设置"];
            
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    }
    
    
//
//    if (self.refreshTagsBlock) {
//
//        self.refreshTagsBlock(self.selectedlabels);
//    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFInfoChooseLabelcell *cell = (XFInfoChooseLabelcell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.titleLabel.backgroundColor == [UIColor whiteColor]) {
        cell.titleLabel.backgroundColor = kMainRedColor;
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.selectedlabels addObject:self.tags[indexPath.item]];
    } else {
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.layer.borderColor = UIColorHex(808080).CGColor;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        [self.selectedlabels removeObject:self.tags[indexPath.item]];
        
    }
    
    if (self.selectedlabels.count > 0) {
        self.doneButton.backgroundColor = kMainRedColor;
        self.doneButton.enabled = YES;
    } else {
        
        self.doneButton.backgroundColor = UIColorHex(999999);
        self.doneButton.enabled = NO;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.tags.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFInfoChooseLabelcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFChooseLabelcell" forIndexPath:indexPath];
    
    XFTagsModel *model = self.tags[indexPath.item];
    
    cell.titleLabel.text = model.tagName;
    
    XFTagsModel *tag = self.tags[indexPath.item];
    
    for (XFTagsModel *myTag in self.myTags) {
        
        if ([myTag.id isEqualToString:tag.id]) {
            
            cell.titleLabel.backgroundColor = kMainRedColor;
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.selectedlabels addObject:self.tags[indexPath.item]];
            
        } else {
            
            cell.titleLabel.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.layer.borderColor = UIColorHex(808080).CGColor;
            cell.titleLabel.textColor = [UIColor blackColor];
            
        }
        
    }

    if ([self.selectedlabels containsObject:self.tags[indexPath.item]]) {
        
        cell.titleLabel.backgroundColor = kMainRedColor;
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.layer.borderColor = UIColorHex(808080).CGColor;
        cell.titleLabel.textColor = [UIColor blackColor];
        
        
    }
    return cell;
    
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = 84;
    CGFloat itemHeight = 30;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    CGFloat padding = (kScreenWidth - itemWidth * 3)/6.f;
    layout.minimumLineSpacing = padding;
    layout.minimumInteritemSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(0, 2*padding, 0, 2*padding);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XFInfoChooseLabelcell class] forCellWithReuseIdentifier:@"XFChooseLabelcell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;

    [self.view addSubview:self.collectionView];
    
}

- (void)setupTitles {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.textColor = UIColorHex(808080);
    self.desLabel.font = [UIFont systemFontOfSize:14];
    

    if (self.sex == 1) {
        
        self.titleLabel.text = @"选择你的个人标签";
        self.desLabel.text = @"更好的将资料推荐给欣赏你的人";
    } else {
        
        self.titleLabel.text = @"选择你感兴趣的内容";
        self.desLabel.text = @"更好的推荐你感兴趣的内容";

        
    }
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.desLabel];
    
    self.doneButton = [[UIButton alloc] init];
    [self.doneButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.doneButton setBackgroundColor:UIColorHex(999999)];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.doneButton.layer.cornerRadius = 22;
    [self.view addSubview:self.doneButton];
    
    [self.doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)updateViewConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(64);
        make.centerX.mas_offset(0);
        
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.mas_offset(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(0);
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(28.5);
        make.right.mas_offset(0);
        make.height.mas_equalTo(4 * 30 + (4 - 1)*(kScreenWidth - 84 * 3)/6.f);

    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(111);
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
        make.height.mas_equalTo(44);
        
    }];
    
    [super updateViewConstraints];
}

- (NSMutableArray *)selectedlabels {
    
    if (_selectedlabels == nil) {
        
        _selectedlabels = [NSMutableArray array];
    }
    return _selectedlabels;
}


@end
