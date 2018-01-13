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
#import "XFMineNetworkManager.h"

@implementation XFTransModel : NSObject



@end

@interface XFTxViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,copy) NSDictionary *info;

@end

@implementation XFTxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    
    /**
     打赏支出            REWARD_EXPENSE
     打赏收入            REWARD_RECEIVE
     充值                RECHARGE
     提现                WITHDRAW
     解锁动态支出        UNLOCK_PUBLISH
     解锁动态收入        RECEIVE_PUBLISH
     解锁微信收入        UNLOCK_WECHAT
     解锁微信支出        RECEIVE_WECHAT
     解锁电话支出        UNLOCK_PHONE
     解锁电话收入        RECEIVE_PHONE
     上家分成收入        BIND_SHARED_RECEIVE
     兑换金币            DIAMOND_TO_COIN
     */
    self.info = @{@"REWARD_EXPENSE":@"打赏支出",
                  @"REWARD_RECEIVE":@"打赏收入",
                  @"RECHARGE":@"充值",
                  @"WITHDRAW":@"提现",
                  @"UNLOCK_PUBLISH":@"解锁动态支出",
                  @"RECEIVE_PUBLISH":@"解锁动态收入",
                  @"UNLOCK_WECHAT":@"解锁微信收入",
                  @"RECEIVE_WECHAT":@"解锁微信支出",
                  @"UNLOCK_PHONE":@"解锁电话支出",
                  @"RECEIVE_PHONE":@"解锁电话收入",
                  @"BIND_SHARED_RECEIVE":@"分成收入",
                  @"DIAMOND_TO_COIN":@"兑换金币支出"
                  };

    self.datas = [NSMutableArray array];
    [self setuptableView];
    
    [self loadData];
}

- (void)loadData {
    
    self.page = 0;
    
    [XFMineNetworkManager getTranscationsWithPage:[NSString stringWithFormat:@"%zd",self.page] size:@"20" successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count ; i ++ ) {
            
            [arr addObject:[XFTransModel modelWithDictionary:datas[i]]];
            
        }
        self.datas = arr;
        
        [self.tableView reloadData];
        
    } failedBlock:^(NSError *error) {
        
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)setuptableView {
    
    self.tableView = [[UITableView alloc] init];

    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    XFTxListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFTxListTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[XFTxListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"XFTxListTableViewCell"];
        
    }
    
    XFTransModel *model = self.datas[indexPath.row];
    
    cell.textLabel.text = self.info[model.event];
    cell.detailTextLabel.text = [XFToolManager changeLongToDateWith:model.createTime];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",model.diamonds];
    cell.moneyLabel.textColor = [model.type isEqualToString:@"IN"] ? [UIColor redColor] : [UIColor greenColor];
    
    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return 65;
}

@end
