//
//  XFEverydayMissionViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/22.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFEverydayMissionViewController.h"
#import "XFMissionTableViewCell.h"
#import "XFMissionModel.h"

@interface XFEverydayMissionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *models;

@property (nonatomic,copy) NSArray *bgArr;

@end

@implementation XFEverydayMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"每日任务";
    [self setuptableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMissionTableViewCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFMissionTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.model = self.models[indexPath.row];
    cell.bgView.image = [UIImage imageNamed:self.bgArr[indexPath.row%5]];
    
    return cell;
    
}

- (void)setuptableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorHex(f5f5f5);
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
}

- (NSArray *)models {
    
    if (_models == nil) {
        
        _models = [XFMissionModel missionModels];
        
    }
    return _models;
}

- (NSArray *)bgArr {
    
    if (_bgArr == nil) {
        
        _bgArr = @[@"neiron",@"qiandao",@"pinglun",@"点赞",@"xinren"];
    }
    return _bgArr;
    
}

@end
