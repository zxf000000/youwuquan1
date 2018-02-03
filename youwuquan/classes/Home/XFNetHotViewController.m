//
//  XFHomeViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeViewController.h"
#import "XFOutsideButtonView.h"
#import "XFHomeTopHeaderReusableView.h"
#import "XFHomeCollectionViewCell.h"
#import "XFHomeSecondReusableView.h"

#import "XFActorViewController.h"
#import "XFNetHotViewController.h"
#import "XFVideoViewController.h"
#import "XFHomeTableNode.h"
#import "XFHomeSectionHeader.h"
#import "XFHomeNearNode.h"
#import "XFStatusDetailViewController.h"
#import "XFFindDetailViewController.h"
#import "XFHomeCacheManger.h"
#import "XFHomeNetworkManager.h"
#import "XFHomeDataModel.h"
#import "XFHomeDataParamentModel.h"


#define kHomeHeaderHeight (15 + 15 + 17 + 210 + 15 + 100 + 15 + 15 + 17)
#define kSecondHeaderHeight (195 + 15 + 17 + 15)




@interface XFNetHotViewController () <ASTableDelegate,ASTableDataSource,UICollectionViewDelegateFlowLayout,XFHomeNodedelegate>

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,weak) UIButton *whButton;

@property (nonatomic,weak) UIButton *yyButton;

@property (nonatomic,weak) UIButton *spButton;

@property (nonatomic,weak) UIView *titleView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) ASTableNode *tableNode;


@property (nonatomic,copy) NSArray *names;
@property (nonatomic,copy) NSArray *updatas;

@property (nonatomic,copy) NSArray *inviteDatas;

@property (nonatomic,copy) NSArray *models;


@end

@implementation XFNetHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.upPics = @[@"1",@"2"];
//    self.invitePics = @[@"3",@"4",@"5",@"6",@"7",@"8"];

    [self setupTableNode];
    
    [self.view setNeedsUpdateConstraints];
    
    
}

- (void)firstLoadData {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    switch (self.type) {
            
        case XFNetHotVCTypeWh:
        {
            // 网红
            [XFHomeNetworkManager getHotDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    NSDictionary *dic = datas[i];
                    XFHomeDataParamentModel *paramentModel = [[XFHomeDataParamentModel alloc] init];
                    paramentModel.categoryTitle = dic[@"categoryTitle"];
                    NSArray *modelDatas  = dic[@"data"];
                    NSMutableArray *mutarr = [NSMutableArray array];
                    for (int j= 0 ; j < modelDatas.count ; j ++ ) {
                        
                        [mutarr addObject:[XFHomeDataModel modelWithDictionary:modelDatas[j]]];
                    }
                    paramentModel.data = mutarr.copy;
                    [arr addObject:paramentModel];
                }
                
                self.models = arr.copy;
                
                [self.tableNode reloadData];
                
                [self.tableNode.view.mj_header endRefreshing];
                
                [HUD hideAnimated:YES];
                
            } failBlock:^(NSError *error) {
                
                [self.tableNode.view.mj_header endRefreshing];
                [HUD hideAnimated:YES];

            } progress:^(CGFloat progress) {
                
                
            }];
        }
            break;
        case XFNetHotVCTypeYW:
        {
            // 尤物
            [XFHomeNetworkManager getYouwuDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    NSDictionary *dic = datas[i];
                    XFHomeDataParamentModel *paramentModel = [[XFHomeDataParamentModel alloc] init];
                    paramentModel.categoryTitle = dic[@"categoryTitle"];
                    NSArray *modelDatas  = dic[@"data"];
                    NSMutableArray *mutarr = [NSMutableArray array];
                    for (int j= 0 ; j < modelDatas.count ; j ++ ) {
                        
                        [mutarr addObject:[XFHomeDataModel modelWithDictionary:modelDatas[j]]];
                    }
                    paramentModel.data = mutarr.copy;
                    [arr addObject:paramentModel];
                }
                
                self.models = arr.copy;
                
                [self.tableNode reloadData];
                
                [self.tableNode.view.mj_header endRefreshing];
                [HUD hideAnimated:YES];

            } failBlock:^(NSError *error) {
                [self.tableNode.view.mj_header endRefreshing];
                [HUD hideAnimated:YES];

            } progress:^(CGFloat progress) {
                
            }];
        }
            break;
    }
}

- (void)loadData {
    
    switch (self.type) {
            
        case XFNetHotVCTypeWh:
        {
            // 网红
            [XFHomeNetworkManager getHotDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    NSDictionary *dic = datas[i];
                    XFHomeDataParamentModel *paramentModel = [[XFHomeDataParamentModel alloc] init];
                    paramentModel.categoryTitle = dic[@"categoryTitle"];
                    NSArray *modelDatas  = dic[@"data"];
                    NSMutableArray *mutarr = [NSMutableArray array];
                    for (int j= 0 ; j < modelDatas.count ; j ++ ) {
                        
                        [mutarr addObject:[XFHomeDataModel modelWithDictionary:modelDatas[j]]];
                    }
                    paramentModel.data = mutarr.copy;
                    [arr addObject:paramentModel];
                }
                
                self.models = arr.copy;
                
                [self.tableNode reloadData];
                
                [self.tableNode.view.mj_header endRefreshing];
                
            } failBlock:^(NSError *error) {
                
                [self.tableNode.view.mj_header endRefreshing];

            } progress:^(CGFloat progress) {
                
                
            }];
        }
            break;
        case XFNetHotVCTypeYW:
        {
            // 尤物
            [XFHomeNetworkManager getYouwuDataWithSuccessBlock:^(id responseObj) {
                
                NSArray *datas = (NSArray *)responseObj;
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0 ; i < datas.count ; i ++ ) {
                    
                    NSDictionary *dic = datas[i];
                    XFHomeDataParamentModel *paramentModel = [[XFHomeDataParamentModel alloc] init];
                    paramentModel.categoryTitle = dic[@"categoryTitle"];
                    NSArray *modelDatas  = dic[@"data"];
                    NSMutableArray *mutarr = [NSMutableArray array];
                    for (int j= 0 ; j < modelDatas.count ; j ++ ) {
                        
                        [mutarr addObject:[XFHomeDataModel modelWithDictionary:modelDatas[j]]];
                    }
                    paramentModel.data = mutarr.copy;
                    [arr addObject:paramentModel];
                }
                
                self.models = arr.copy;
                
                [self.tableNode reloadData];
                
                [self.tableNode.view.mj_header endRefreshing];

            } failBlock:^(NSError *error) {
                [self.tableNode.view.mj_header endRefreshing];

            } progress:^(CGFloat progress) {
                
            }];
        }
            break;
    }

}



- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    
    self.tableNode.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    
    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    self.tableNode.view.tableHeaderView = [[UIView alloc] init];
    
}

#pragma mark - cellNodeDelegate
- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath {
    
    node.likeNode.selected = !node.likeNode.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer complate:^{
        
        
    }];
}

//去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableNode.view)
    {
        CGFloat sectionHeaderHeight = 47;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    XFHomeDataParamentModel *paModel = self.models[indexPath.section];
    XFHomeDataModel *model = paModel.data[indexPath.row];
    detailVC.userId = model.uid;
    detailVC.userName = model.nickname;
    detailVC.iconUrl = model.headIconUrl;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return self.models.count;
    
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFHomeDataParamentModel *paModel = self.models[indexPath.section];
    
    XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:paModel.data[indexPath.row] isBottom:NO];
    
    node.delegate = self;
    
    node.shadowNode.image = [UIImage imageNamed:@"overlay-zise"];
    node.neverShowPlaceholders = YES;

    return node;

}

//- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
//
//        XFHomeDataParamentModel *paModel = self.models[indexPath.section];
//
//        XFHomeTableNode *node = [[XFHomeTableNode alloc] initWithModel:paModel.data[indexPath.row]];
//
//        node.delegate = self;
//
//        node.shadowNode.image = [UIImage imageNamed:@"overlay-zise"];
//
//        return node;
//    };
//
//        return cellNodeBlock;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 47;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XFHomeSectionHeader *header = [[XFHomeSectionHeader alloc] init];
    
    header.backgroundColor = [UIColor whiteColor];
    
    XFHomeDataParamentModel *paModel = self.models[section];

    header.titleLabel.text = paModel.categoryTitle;
    
    return header;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    XFHomeDataParamentModel *paModel = self.models[section];

    return paModel.data.count;
}





@end

