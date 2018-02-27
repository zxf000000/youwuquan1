//
//  XFMyCaresViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyCaresViewController.h"
#import "XFMineNetworkManager.h"
#import "XFFindDetailViewController.h"

@implementation XFMyCareModel

@end

@implementation XFMyCareViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _authIcons = [NSMutableArray array];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = UIColorHex(808080);
        _iconView.layer.cornerRadius = 30;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = UIColorHex(808080);
        _statusLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_statusLabel];
        
        _careButton = [[UIButton alloc] init];
        [_careButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
        [_careButton setTitle:@"已关注" forState:(UIControlStateSelected)];
        [_careButton setTitleColor:UIColorHex(808080) forState:(UIControlStateSelected)];
        [_careButton setTitleColor:kMainRedColor forState:(UIControlStateNormal)];
        _careButton.layer.cornerRadius = 5;
        _careButton.layer.borderColor = kMainRedColor.CGColor;
        _careButton.layer.borderWidth = 1;
        
        [self.contentView addSubview:_careButton];
        

        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setModel:(XFMyCareModel *)model {
    
    _model = model;
    
    _nameLabel.text = _model.nickname;
    [_iconView setImageWithURL:[NSURL URLWithString:_model.headIconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    _careButton.hidden = YES;
    _statusLabel.text = _model.introduce;
    
//    for (NSInteger i = 0; i < _model.identificationIds.count ; i ++ ) {
//
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhanweitu44"]];
//
//        [_authIcons addObject:imgView];
//
//        [self.contentView addSubview:imgView];
//    }
}

- (void)updateConstraints {
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.mas_equalTo(60);
        make.left.mas_offset(15);
        make.centerY.mas_offset(0);
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconView.mas_right).offset(14);
        make.centerY.mas_offset(-20);
        
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_iconView.mas_right).offset(14);
        make.centerY.mas_offset(20);
        make.right.mas_offset(-30);
        
    }];
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-15);
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(29);
        
    }];
    
    CGFloat authPadding = 3;
    CGFloat authWidth = 12;
    for (NSInteger i = 0 ; i < self.authIcons.count; i ++) {
        
        UIImageView *imgView = self.authIcons[i];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(_nameLabel.mas_right).offset(10 + (authPadding + authWidth)*i);
            make.centerY.mas_equalTo(_nameLabel);
            make.width.height.mas_equalTo(authWidth);
        }];
        
    }
    
    [super updateConstraints];
}

@end

@interface XFMyCaresViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,assign) NSInteger page;


@end

@implementation XFMyCaresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self setupSearchBar];
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)endrefresh {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}

- (void)loadMoreData {
    
    self.page += 1;

    [XFMineNetworkManager getMyCaresWithPage:self.page rows:20 successBlock:^(id responseObj) {
        
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
    
    [XFMineNetworkManager getMyCaresWithPage:self.page rows:20 successBlock:^(id responseObj) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyCareModel *model = self.datas[indexPath.row];
    
    XFFindDetailViewController *datailVC = [[XFFindDetailViewController alloc] init];
    datailVC.userId = model.followedUid;
    datailVC.userName = model.nickname;
    datailVC.iconUrl = model.headIconUrl;
    [self.navigationController pushViewController:datailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFMyCareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFMyCareViewCell"];
    
    if (cell == nil) {
        
        cell  = [[XFMyCareViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"XFMyCareViewCell"];
    }
    
    cell.model = self.datas[indexPath.row];
    
    return cell;
}

- (void)setupSearchBar {
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44))];
    
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
