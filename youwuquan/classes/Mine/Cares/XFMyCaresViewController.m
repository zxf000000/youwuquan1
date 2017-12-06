//
//  XFMyCaresViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/5.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyCaresViewController.h"

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
        
        for (NSInteger i = 0; i < 4; i ++ ) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XFIconmanager sharedManager].authIcons[i]]];
            
            [_authIcons addObject:imgView];
            
            [self.contentView addSubview:imgView];
        }
        
        [self setNeedsUpdateConstraints];
    }
    return self;
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

@end

@implementation XFMyCaresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSearchBar];
    
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

- (void)setupSearchBar {
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44))];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

@end
