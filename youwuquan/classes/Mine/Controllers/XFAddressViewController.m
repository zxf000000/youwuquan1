//
//  XFAddressViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2018/1/24.
//  Copyright © 2018年 mr.zhou. All rights reserved.
//

#import "XFAddressViewController.h"
#import "XFAddressTableViewCell.h"
#import "XFMineNetworkManager.h"
#import "XFAddressModel.h"
#import "XFAddAddressViewController.h"

@interface XFAddressViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSIndexPath *selectedIndexpath;

@property (nonatomic,copy) NSArray *models;

@end

@implementation XFAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收获地址";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTableView];
    
}

- (void)clickAddButton {
    
    XFAddAddressViewController *addVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAddAddressViewController"];
    
    [self.navigationController pushViewController:addVC animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadData];
    
}



- (void)loadData {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    [XFMineNetworkManager getAddressListWithsuccessBlock:^(id responseObj) {
        
        [HUD hideAnimated:YES];
        
        NSArray *datas = (NSArray *)responseObj;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i= 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFAddressModel modelWithDictionary:datas[i]]];
        
        }
        
        self.models  = arr.copy;
        
        [self.tableView reloadData];
        
    } failedBlock:^(NSError *error) {
        [HUD hideAnimated:YES];

    } progressBlock:^(CGFloat progress) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexpath = indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFAddressTableViewCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFAddressTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.model = self.models[indexPath.row];
    
    cell.clickDeleteButtonBlock = ^(XFAddressModel *model) {
        
    };
    
    cell.clickEditButtonBlock = ^(XFAddressModel *model) {
        
        XFAddAddressViewController *addVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAddAddressViewController"];
        
        addVC.model = model;
        
        [self.navigationController pushViewController:addVC animated:YES];
        
    };
    
    return cell;
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor whiteColor];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setBackgroundImage:[UIImage imageNamed:@"address_add"] forState:(UIControlStateNormal)];
    [footer addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_offset(0);
        make.width.mas_equalTo(kScreenWidth - 60);
        make.height.mas_equalTo(44);
        
    }];
    
    [addButton addTarget:self action:@selector(clickAddButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableView.tableFooterView = footer;
}

@end
