//
//  XFFansViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFansViewController.h"
#import "XFMyCaresViewController.h"
#import "XFMineNetworkManager.h"
#import "XFMyFansTableViewCell.h"
#import "XFMineNetworkManager.h"

@interface XFFansViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,assign) NSInteger page;

@end

@implementation XFFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的粉丝";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)endrefresh {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}

- (void)loadMoreData {
    
    self.page += 1;
    
    [XFMineNetworkManager getMyFansListWithPage:self.page rows:20 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFMyCareModel modelWithDictionary:datas[i]]];
            
            
        }
        
        [self.datas addObjectsFromArray:arr.copy];
        
        [self.tableView reloadData];
        
        [self endrefresh];
    } failedBlock:^(NSError *error) {
        
        [self endrefresh];
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];

}
- (void)loadData {
    
    self.page = 0;
    
    [XFMineNetworkManager getMyFansListWithPage:self.page rows:20 successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFMyCareModel modelWithDictionary:datas[i]]];
            
            
        }
        
        self.datas = arr;
        
        [self.tableView reloadData];
        
        [self endrefresh];
    } failedBlock:^(NSError *error) {
        [self endrefresh];

        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMyFansTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMyFansTableViewCell" owner:nil options:nil] lastObject];
    }
    
    XFMyCareModel *model = self.datas[indexPath.row];
    
    cell.model = model;
    
    cell.clickCareButtonBlock = ^(XFMyFansTableViewCell *cell) {
      
        XFMyCareModel *model = cell.model;
        
        if ([model.followEach isEqualToString:@"each"]) {
            
            
            
        } else {
            
            [XFMineNetworkManager careSomeoneWithUid:model.fansUid successBlock:^(id responseObj) {
                
                cell.careButton.selected = YES;
                cell.careButton.layer.borderColor = UIColorHex(808080).CGColor;
                
            } failedBlock:^(NSError *error) {
                
            } progressBlock:^(CGFloat progress) {
                
            }];
            
        }
        
    };
    
    return cell;
}


- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [XFToolManager refreshHeaderWithBlock:^{
        [self loadData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
        
    }];
    
}

@end
