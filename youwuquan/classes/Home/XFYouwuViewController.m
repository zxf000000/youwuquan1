//
//  XFYouwuViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/23.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFYouwuViewController.h"
#import "XFNearbyTableViewCell.h"
#import "XFFindDetailViewController.h"
#import "XFHomeNetworkManager.h"
#import "XFHomeDataModel.h"
#import "XFHomeDataParamentModel.h"
#import "XFYouWuCollectionViewCell.h"

@interface XFYouwuViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UICollectionView *headCollectionView;

@property (nonatomic,strong) NSMutableArray *models;

@property (nonatomic,assign) NSInteger page;


@end

@implementation XFYouwuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [self setupCollectionView];
}

- (void)loadMoreData {
    
    self.page += 1;
    
    switch (self.type) {
            
        case Nethot:
        {
            // 网红
            [XFHomeNetworkManager getHotMoreDataWithPage:self.page size:20 successBlock:^(id responseObj) {
                
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    [arr addObject:[XFHomeDataModel modelWithDictionary:datas[i]]];
                    
                }
                
                [self.models addObjectsFromArray:arr.copy];
                
                [self.collectionView reloadData];
                
                [self.collectionView.mj_footer endRefreshing];
                
            } failBlock:^(NSError *error) {
                [self.collectionView.mj_footer endRefreshing];

            } progress:^(CGFloat progress) {
                
            }];
        }
            break;
        case Youwu:
        {
            [XFHomeNetworkManager getYouwuMoreDataWithPage:self.page size:20 successBlock:^(id responseObj) {
               
                NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    [arr addObject:[XFHomeDataModel modelWithDictionary:datas[i]]];
                    
                }
                
                [self.models addObjectsFromArray:arr.copy];
                
                [self.collectionView reloadData];
                
                [self.collectionView.mj_footer endRefreshing];

                
            } failBlock:^(NSError *error) {
                [self.collectionView.mj_footer endRefreshing];

            } progress:^(CGFloat progress) {
                
            }];
        }
            break;
    }
    
}

- (void)loadData {
    
    switch (self.type) {
            
        case Nethot:
        {
            // 网红
            [XFHomeNetworkManager getHotDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    [arr addObject:[XFHomeDataModel modelWithDictionary:datas[i]]];
                    
                }
                
                self.models = arr;
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                
            } failBlock:^(NSError *error) {
                [self.collectionView.mj_header endRefreshing];

                
            } progress:^(CGFloat progress) {
                
                
            }];
        }
            break;
        case Youwu:
        {
            // 尤物
            [XFHomeNetworkManager getYouwuDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {

                    [arr addObject:[XFHomeDataModel modelWithDictionary:datas[i]]];
                    
                }
                
                self.models = arr;
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];

            } failBlock:^(NSError *error) {
                [self.collectionView.mj_header endRefreshing];

            } progress:^(CGFloat progress) {
                
            }];
        }
            break;
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (collectionView == self.headCollectionView) {
            
            return nil;
        }
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"actor_yline"];
        [header addSubview:img];
        UILabel *text = [[UILabel alloc] init];
        text.font = [UIFont systemFontOfSize:13];

        text.text = self.type == Youwu ? @"推荐尤物" : @"推荐网红";
        text.textColor = [UIColor blackColor];
        [header addSubview:text];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.itemSize = CGSizeMake(105, (105 * 10 / 9.f + 30));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.headCollectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
        self.headCollectionView.delegate = self;
        self.headCollectionView.dataSource = self;
        
        if (@available (ios 11 , * )) {
            
            self.headCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        self.headCollectionView.backgroundColor = [UIColor whiteColor];
        [self.headCollectionView registerNib:[UINib nibWithNibName:@"XFYouWuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFYouWuCollectionViewCell"];
        self.headCollectionView.showsVerticalScrollIndicator = NO;
        [header addSubview:self.headCollectionView];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_offset(13);
            make.left.mas_offset(0);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(22);
            
        }];
        
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(img);
            make.left.mas_equalTo(img.mas_right).offset(10);
            
        }];
        
        [self.headCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(-10);
            make.top.mas_offset(37);
        }];
        return header;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (collectionView == self.collectionView) {
        
        return CGSizeMake(kScreenWidth, 105 * 10 / 9.f + 30 + 47 + 20);

    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.headCollectionView) {
        
        XFHomeDataModel *model = self.models[indexPath.item];
        XFFindDetailViewController *datailVC = [[XFFindDetailViewController alloc] init];
        datailVC.userId = model.uid;
        datailVC.userName = model.nickname;
        datailVC.iconUrl = model.headIconUrl;
        datailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:datailVC animated:YES];
    } else {
        XFHomeDataModel *model = self.models[indexPath.item + 10];
        XFFindDetailViewController *datailVC = [[XFFindDetailViewController alloc] init];
        datailVC.userId = model.uid;
        datailVC.userName = model.nickname;
        datailVC.iconUrl = model.headIconUrl;
        datailVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:datailVC animated:YES];
        
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.headCollectionView) {
        
        if (self.models.count > 10) {
            
            return 10;
            
        } else {
            
            return self.models.count;
        }
        
    } else {
        if (self.models.count > 10) {
            
            return self.models.count - 10;
            
        } else {
            
            return 0;
        }
    }
    
    return 0;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFYouWuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFYouWuCollectionViewCell" forIndexPath:indexPath];

    if (collectionView == self.headCollectionView) {
        
        XFHomeDataModel *model = self.models[indexPath.item];
        cell.model =  model;

    } else {
        
        XFHomeDataModel *model = self.models[indexPath.item + 10];
        cell.model =  model;

    }

    return cell;
    
}
- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((kScreenWidth - 15)/2, (kScreenWidth - 15)/2*10/9.f + 30);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)) collectionViewLayout:layout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (@available (ios 11 , * )) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XFYouWuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFYouWuCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [XFToolManager refreshHeaderWithBlock:^{
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreData];
        
    }];
    
}

@end
