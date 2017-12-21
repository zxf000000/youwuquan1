//
//  XFTxViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFTxViewController.h"
#import "XFTxTotalTableViewCell.h"
#import "XFTxDiaTableViewCell.h"
#import "XFTxListTableViewCell.h"


@interface XFTxViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XFTxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";

    [self setuptableView];
}

- (void)setuptableView {
    
    self.tableView = [[UITableView alloc] init];

    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
        {
            XFTxTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTxTotalTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFTxTotalTableViewCell" owner:nil options:nil] lastObject];
                
                
            }
            return cell;
            
        }
            break;
        case 1:
        {
            XFTxDiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTxDiaTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFTxDiaTableViewCell" owner:nil options:nil] lastObject];
                
            }
            return cell;
        }
            break;
        case 2:
        {
            XFTxDiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTxDiaTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"XFTxDiaTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            cell.iconView.image = [UIImage imageNamed:@"mingxi_gift"];
            cell.titleLabel.text = @"礼物收入";
            
            return cell;
        }
            break;
            
            
        default :
        {
            XFTxListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTxListTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[XFTxListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"XFTxListTableViewCell"];
                
            }
            
            cell.textLabel.text = @"提现";
            cell.detailTextLabel.text = @"2017-09-10 13:09:56";
            
            cell.moneyLabel.text = @"- 30000";
            
            return cell;
        }
            break;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            return 89;
        }
            break;

        default:
        {
            return 50;

        }
            break;
    }
    
    return 0;
}

@end
