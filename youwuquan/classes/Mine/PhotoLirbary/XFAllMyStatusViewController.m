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

@interface XFAllMyStatusViewController () <ASTableDelegate,ASTableDataSource,XFMyStatusCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@property (nonatomic,copy) NSArray *datas;

@end

@implementation XFAllMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的动态";
    
    [self setupNavigationBar];
    [self setupTableNode];
    
//    [self loadData];
    
    [self.tableNode.view.mj_header beginRefreshing];
}

- (void)loadData {
    
    [XFUserInfoNetWorkManager getAllMyStatusWithStart:0 successBlock:^(NSDictionary *responseDic) {
        
        [self.tableNode.view.mj_header endRefreshing];
        
        if (responseDic) {
            
            NSArray *datas = responseDic[@"data"];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
                
                NSDictionary *dic = datas[i];
                
                XFStatusModel *model = [XFStatusModel modelWithDictionary:dic];
                
                [arr addObject:model];
                
            }
            
            self.datas = arr.copy;
            
            [self.tableNode reloadData];
            
        }
        
    } failedBlock:^(NSError *error) {
        
        [self.tableNode.view.mj_header endRefreshing];

    }];
    
    
}

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen {
    
    if (isOpen) {
        
        self.openIndexPath = index;
        
    } else {
        
        self.openIndexPath = nil;
        
    }
    
//    [UIView performWithoutAnimation:^{
//
//        [self.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationNone)];
//
//    }];
    

    
//    UIImageView *imgView = (UIImageView*) [self.view snapshotViewAfterScreenUpdates:true];
//    [self.navigationController.view addSubview:imgView];
//    imgView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
//

    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [imgView removeFromSuperview];
//
//    });
    
//
    //关闭CALayer隐式动画
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//
////    [self.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationNone)];
//
//    [CATransaction commit];
    
    
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
