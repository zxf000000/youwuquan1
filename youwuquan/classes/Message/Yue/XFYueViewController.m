//
//  XFYueViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFYueViewController.h"
#import "XFYueTableViewCell.h"

@interface XFYueViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation XFYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"约的信息";
    
    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFYueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFYueTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFYueTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
    
}

@end
