//
//  XFLeaderboardViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFLeaderboardViewController.h"
#import "XFLeaderboardModel.h"
#import "XFLeaderboardTableViewCell.h"
#import "XFFindDetailViewController.h"

#define kFirstheaderWidth 80
#define kFirstheaderHeight 100
#define kSecondheaderWidth 70
#define kSecondHeaderHeight 87

#define kHeaderIconBottom 5

#define kHeaderViewHeight 162

@implementation XFLeaderboardHeaderIconView

- (instancetype)init {
    
    if (self = [super init]) {
        _bgImage = [[UIImageView alloc] init];
    
        [self addSubview:_bgImage];
        
        
        _iconImage = [[UIImageView alloc] init];
        
        [self addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentCenter)];
        [self addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont systemFontOfSize:14] textColor:[UIColor whiteColor] aligment:(NSTextAlignmentCenter)];
        [self addSubview:_numberLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
    CGFloat bgWidth = width;
    CGFloat bgHeight = width * 5/4.f;
    CGFloat iconWidth = bgWidth - 10;
    
    self.bgImage.frame = CGRectMake(0, 0, bgWidth, bgHeight);
    
    self.iconImage.frame = CGRectMake(5, bgHeight - 5 - iconWidth, iconWidth, iconWidth);
    
    self.iconImage.layer.cornerRadius = iconWidth/2;
    self.iconImage.layer.masksToBounds = YES;
    
    self.nameLabel.center = CGPointMake(width/2, bgHeight + 12);
    self.nameLabel.bounds = CGRectMake(0, 0, 100, 15);
    
    self.numberLabel.center = CGPointMake(width/2, bgHeight + 12 + 17);
    self.numberLabel.bounds = CGRectMake(0, 0, 100, 15);
    
}

- (void)updateConstraints {
    
//    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.right.mas_offset(0);
//        make.height.mas_equalTo(_bgImage.width*5/4.f);
//
//    }];
//
//    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.mas_offset(-5);
//        make.left.mas_offset(5);
//        make.bottom.mas_equalTo(_bgImage.mas_bottom).offset(-5);
//        make.height.mas_equalTo(_iconImage.width);
//
//    }];
//
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.mas_offset(0);
//        make.top.mas_equalTo(_bgImage.mas_bottom).offset(5);
//
//    }];
//
//    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerX.mas_offset(0);
//        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(5);
//
//    }];
    
    
    [super updateConstraints];
}

@end

@interface XFLeaderboardViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,copy) NSArray *headerIcons;

@property (nonatomic,copy) NSArray *bgImgs;

@property (nonatomic,copy) NSArray *models;

@end

@implementation XFLeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"富豪榜";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj-1"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    imageView.frame = self.view.bounds;
    
    [self setupHeadView];
    
    [self setupTableView];
    
    [self setupTitleView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count - 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFLeaderboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFLeaderboardTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XFLeaderboardTableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.model = self.models[indexPath.row + 3];
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + 4];
    
    return cell;
    
}

// 前三名
- (void)setupHeadView {
    
    CGFloat padding = (kScreenWidth - 80 - 140)/4.f;
    
    self.headView = [[UIView alloc] init];
    self.headView.frame = CGRectMake(0, 64, kScreenWidth, kHeaderViewHeight);
    [self.view addSubview:self.headView];
    for (NSInteger i = 0 ; i < 3 ; i ++ ) {
        
        XFLeaderboardModel *model = self.models[i];
        
        XFLeaderboardHeaderIconView *headerIcon1 = [[XFLeaderboardHeaderIconView alloc] init];
        headerIcon1.bgImage.image = [UIImage imageNamed:self.bgImgs[i]];
        headerIcon1.iconImage.image = [UIImage imageNamed:model.icon];
        headerIcon1.nameLabel.text = model.name;
        headerIcon1.numberLabel.text = model.number;
        [self.headView addSubview:headerIcon1];
        
        switch (i) {
            case 0:{
                
                [headerIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.top.mas_offset(15);
                    make.bottom.mas_offset(0);
                    make.centerX.mas_offset(0);
                    make.width.mas_equalTo(80);
                }];
            }
                break;
            case 1:{
                
                [headerIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(27);
                    make.bottom.mas_offset(0);
                    make.centerX.mas_offset(-(40 + 35 + padding));
                    make.width.mas_equalTo(70);
                }];
                
            }
                break;
            case 2:{
                [headerIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_offset(27);
                    make.bottom.mas_offset(0);
                    make.centerX.mas_offset((40 + 35 + padding));
                    make.width.mas_equalTo(70);
                }];
                
            }
                break;
                
        }
        
    }
    
    

}

- (void)setupTitleView {
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(9.3, 28, 70, 30);
    [backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"富豪榜";
    [self.view addSubview:titleLabel];
    
    titleLabel.frame = CGRectMake((kScreenWidth - 55)/2, 35, 55, 16);
    [backButton addTarget:self action:@selector(clickBackbutton) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)clickBackbutton {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(10, kHeaderViewHeight + 64, kScreenWidth - 20, kScreenHeight - 64 - kHeaderViewHeight);
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [XFToolManager setTopCornerwith:10 view:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}

- (NSArray *)bgImgs {
    
    if (_bgImgs == nil) {
        
        _bgImgs = @[@"leader_first",@"leader_second",@"leaeder_thirdly"];
        
    }
    return _bgImgs;
}

- (NSArray *)models {
    
    if (_models == nil) {
        
        _models = @[[[XFLeaderboardModel alloc] initWithIcon:@"video_pic3" name:@"就是霸气就是狂" number:@"123334"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"message_touxiang" name:@"地主家的傻儿子" number:@"89762"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"me_tou1" name:@"地主家的傻儿子" number:@"9999"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"actor_pic22" name:@"宵夜行军" number:@"12312"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"home_tou" name:@"吸猫少女" number:@"1233"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_icon2" name:@"游子" number:@"999"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_icon3" name:@"香蕉" number:@"998"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_icon4" name:@"苹果" number:@"996"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_icon5" name:@"猕猴桃" number:@"844"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_pic4" name:@"大脸猫" number:@"344"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_pic8" name:@"米老鼠" number:@"324"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_pic10" name:@"唐老鸭" number:@"157"],
                    [[XFLeaderboardModel alloc] initWithIcon:@"find_pic12" name:@"李狗蛋" number:@"98"]];
        
        
    }
    return _models;
}


@end
