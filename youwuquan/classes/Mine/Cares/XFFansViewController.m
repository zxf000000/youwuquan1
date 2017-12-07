//
//  XFFansViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFansViewController.h"
#import "XFMyCaresViewController.h"

@interface XFFansViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XFFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的粉丝";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyCareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMyCareViewCell"];
    
    if (cell == nil) {
        
        cell  = [[XFMyCareViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"XFMyCareViewCell"];
    }
    
    cell.iconView.image = [UIImage imageNamed:@"22"];
    cell.nameLabel.text = @"小混蛋";
    cell.statusLabel.text = @"最新动态的文字，就是霸气就是狂......";
    
    return cell;
}


- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

@end
