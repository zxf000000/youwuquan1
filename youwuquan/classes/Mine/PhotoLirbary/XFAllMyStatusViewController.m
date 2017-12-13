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

@interface XFAllMyStatusViewController () <ASTableDelegate,ASTableDataSource,XFMyStatusCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,assign) NSInteger start;

@end

@implementation XFAllMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的动态";
    
    self.datas = [NSMutableArray array];
    
    [self setupNavigationBar];
    [self setupTableNode];
    
//    [self loadData];
    
    [self.tableNode.view.mj_header beginRefreshing];
}
#pragma mark - 加载数据
- (void)loadData {
    
    self.start = 0;
    
    [XFUserInfoNetWorkManager getAllMyStatusWithStart:self.start successBlock:^(NSDictionary *responseDic) {
        
        [self.tableNode.view.mj_header endRefreshing];
        
        if (responseDic) {
            
            NSArray *datas = responseDic[@"data"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                NSDictionary *dic = datas[i];
                
                XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
                
                [arr addObject:model];
                
            }
            
            self.datas = arr;
            
            self.tableNode.hidden = YES;
            
            [self.tableNode reloadData];
            
            self.tableNode.hidden = NO;

        }
        
    } failedBlock:^(NSError *error) {
        
        [self.tableNode.view.mj_header endRefreshing];

    }];
    
    
}

- (void)retrieveNextPageWithCompletion:(void (^)(NSArray *))block {

    self.start += 3;
    
    [XFUserInfoNetWorkManager getAllMyStatusWithStart:self.start successBlock:^(NSDictionary *responseDic) {
        
        [self.tableNode.view.mj_header endRefreshing];
        
        if (responseDic) {
            
            NSArray *datas = responseDic[@"data"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                NSDictionary *dic = datas[i];
                
                XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
                
                [arr addObject:model];
                
            }
            
            block(arr.copy);
            
        }
        
    } failedBlock:^(NSError *error) {
        
        [self.tableNode.view.mj_header endRefreshing];
        
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
        
        XFStatusModel *model = self.datas[indexPath.row];
        
        [XFStatusNetworkManager likeStatusWithStatusId:model.id userNo:nil successBlock:^(NSDictionary *reponseDic) {
            
            if (reponseDic) {
                
                [self loadData];
                
                if ([reponseDic[@"sign"] intValue] == 303) {
                    
                    [XFToolManager showProgressInWindowWithString:@"已经赞过了"];
                    
                    return;
                }
                
                [XFToolManager showProgressInWindowWithString:@"点赞成功"];
                
            }
            
        } failedBlock:^(NSError *error) {
            
            
        }];
    }];
    

    
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
    
    XFStatusDetailViewController *statusDetailVC = [[XFStatusDetailViewController alloc] init];
    
    statusDetailVC.type = Mine;
    
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
        
        if (self.openIndexPath == indexPath) {
            node.shadowNode.hidden = YES;
            
        } else {
            node.shadowNode.hidden = NO;
        }
        
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
    
    self.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self loadData];

    }];
    
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
