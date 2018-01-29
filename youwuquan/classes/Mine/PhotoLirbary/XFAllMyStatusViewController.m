//
//  XFAllMyStatusViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/8.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAllMyStatusViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFMyStatusCellNode.h"
#import "XFStatusDetailViewController.h"
#import "XFUserInfoNetWorkManager.h"
#import <MJRefresh.h>
#import "XFStatusModel.h"
#import "XFStatusNetworkManager.h"
#import "XFFindNetworkManager.h"
#import "XFVideoDetailViewController.h"

@interface XFAllMyStatusViewController () <ASTableDelegate,ASTableDataSource,XFMyStatusCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,assign) NSInteger page;

@end

@implementation XFAllMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的动态";
    
    self.datas = [NSMutableArray array];
    
    [self setupNavigationBar];
    [self setupTableNode];
    
//    [self.tableNode.view.mj_header beginRefreshing];
    

    self.page = 0;
}


- (void)loadAgain {
    
    self.noneDataView.hidden = YES;
    
    [self loadDataWithProgress:YES indexpath:nil];
    
}

- (void)setLoadFailed {
    
    self.tableNode.hidden = YES;
    self.noneDataView.hidden = NO;
    
}

- (void)loadMoreData {
    
    self.page += 1;

    [XFFindNetworkManager getAllMyStatusWithPage:self.page rows:10 successBlock:^(id responseObj) {
        [self.tableNode.view.mj_footer endRefreshing];
    
        self.noneDataView.hidden = YES;
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            NSDictionary *dic = datas[i];
            
            XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
            
            [arr addObject:model];
            
        }
        
        [self.datas addObjectsFromArray:arr.copy];
        
//        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
        [self.tableNode reloadData];

    } failBlock:^(NSError *error) {
        
        [self.tableNode.view.mj_footer endRefreshing];
        self.noneDataView.hidden = NO;
        self.tableNode.hidden = YES;
        
    } progress:^(CGFloat progress) {
        
        
    }];
}

#pragma mark - 加载数据

- (void)refreshDataForIndexPath:(NSIndexPath *)indexPath {
    
    // 直接更改模型中的数据
    XFStatusModel *model = self.datas[indexPath.row];
    
    model.likeNum  = [NSString stringWithFormat:@"%zd",[model.likeNum intValue] + 1];
    
    [self.tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (void)loadDataWithProgress:(BOOL)progress indexpath:(NSIndexPath *)indexPath {
    
    self.page = 0;
    UIActivityIndicatorView *indicatorView;
    
    if (progress) {
        
        indicatorView = [XFToolManager showIndicatorViewTo:self.view];

    }
    
    [XFFindNetworkManager getAllMyStatusWithPage:self.page rows:10 successBlock:^(id responseObj) {
        [self.tableNode.view.mj_header endRefreshing];

        [indicatorView setHidden:YES];
        [indicatorView removeFromSuperview];
        
        self.noneDataView.hidden = YES;
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            NSDictionary *dic = datas[i];
            
            XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
            
            [arr addObject:model];
            
        }
        
        if (![self.datas modelIsEqual:arr]) {
            self.datas = arr;
            [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
            
        }
        
    } failBlock:^(NSError *error) {
        
        [indicatorView setHidden:YES];
        [indicatorView removeFromSuperview];
        
        [self.tableNode.view.mj_header endRefreshing];
        self.noneDataView.hidden = NO;
        self.tableNode.hidden = YES;
        
    } progress:^(CGFloat progress) {
        
        
    }];

}

#pragma mark - 插入更多数据----智能预加载
- (void)retrieveNextPageWithCompletion:(void (^)(NSArray *))block {

    self.page += 1;
    
    [XFFindNetworkManager getAllMyStatusWithPage:self.page rows:10 successBlock:^(id responseObj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.noneDataView.hidden = YES;

        });
        [self.tableNode.view.mj_header endRefreshing];
    
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            NSDictionary *dic = datas[i];
            
            XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
            
            [arr addObject:model];
            
        }
        
        if (arr.count > 0) {
            
            block(arr.copy);

        }
        
    } failBlock:^(NSError *error) {
    
        
    } progress:^(CGFloat progress) {
        
        
    }];

    
}

- (void)insertNewRowsInTableNode:(NSArray *)newDatas {
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];

    NSUInteger newTotalNumberOfPhotos = self.datas.count + newDatas.count;
    for (NSUInteger row = self.datas.count; row < newTotalNumberOfPhotos; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
    }

    [self.datas addObjectsFromArray:newDatas];

    [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 预加载
- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return YES;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    //1
    [self retrieveNextPageWithCompletion:^(NSArray *animals) {
        //2
        [self insertNewRowsInTableNode:animals];
        //3
        [context completeBatchFetching:YES];
    }];
}

#pragma mark - cell代理方法
- (void)findCellNode:(XFMyStatusCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    
    [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
        

    }];
    
    XFStatusModel *model = self.datas[indexPath.row];
    
    if ([model.user[@"liked"] boolValue]) {
        
        [XFFindNetworkManager unlikeWithStatusId:model.id successBlock:^(id responseObj) {
            
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
    } else {
        
        [XFFindNetworkManager likeWithStatusId:model.id successBlock:^(id responseObj) {
            
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];

        
    }

}

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen {
    
    if (isOpen) {
        
        self.openIndexPath = index;
        
    } else {
        
        self.openIndexPath = nil;
        
    }
    
    self.tableNode.hidden = YES;
    [self.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationNone)];

    self.tableNode.hidden = NO;
    
}


- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    XFStatusModel *model = self.datas[indexPath.row];

    
    XFStatusDetailViewController *statusDetailVC = [[XFStatusDetailViewController alloc] init];
        
    statusDetailVC.type = Mine;
        
    statusDetailVC.status = model;
        
    [self.navigationController pushViewController:statusDetailVC animated:YES];

}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode *{
        
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < indexPath.row % 10 ; i ++ ) {
            
            [mutableArr addObject:@"34"];
        }
        BOOL isOpen;
        
        if (self.openIndexPath == indexPath) {
            
            isOpen = YES;
            
        } else {
            
            isOpen = NO;
        }
        
        
        XFMyStatusCellNode *node = [[XFMyStatusCellNode alloc] initWithPics:mutableArr.copy open:isOpen model:self.datas[indexPath.row]];
        
        node.index = indexPath;
        
        node.delegate = self;
        
        NSLog(@"%@",node.description);
        
        return node;
    };

}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 1;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}


- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.backgroundColor = UIColorHex(f4f4f4);

    [self.view addSubnode:self.tableNode];
    
    if (@available (ios 11 , * )) {
        
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
        
    }
    
    // 加载更多数据之前
    self.tableNode.leadingScreensForBatching = 1;
    
    self.tableNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [self loadDataWithProgress:NO indexpath:nil];
//
//    }];
//
//    self.tableNode.view.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//
//        [self loadMoreData];
//
//    }];
    
}
- (void)setupNavigationBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
    
}




@end
