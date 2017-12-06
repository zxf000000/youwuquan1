//
//  XFActorViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/30.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFActorViewController.h"
#import "XFActorBestTableViewCell.h"
#import "XFNewActorTableViewCell.h"
#import "XFActorInviteTableViewCell.h"
#import "XFActorInviteBottomTableViewCell.h"

@implementation XFActorSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0xf5f5f5);
        
        _lineView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 15, 3, 15))];
        
        [self addSubview:_lineView];
        
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        _titleLabel.textColor = [UIColor blackColor];
        
        [self addSubview:_titleLabel];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints {
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(0);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(2);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_lineView.mas_right).offset(5);
        make.centerY.mas_offset(0);
        
    }];
    
    [super updateConstraints];
}

@end

@interface XFActorViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) UIButton *moreButton1;
@property (nonatomic,weak) UIButton *moreButton2;

@end

@implementation XFActorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    
    [self.view setNeedsUpdateConstraints];
}

// 点击更多按钮
- (void)clickMoreButton:(UIButton *)sender {
    
    if (sender == self.moreButton1) {
        
        // 第一组
        
    } else {
        
        // 第二组
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
            case 0:
            {
                return 1;
                
            }
            break;
            case 1:
        {
            return 0;
            
        }
            break;
            case 2:
        {
            return 1;
            
        }
            break;
            case 3:
        {
            return 0;
            
        }
            break;
            case 4:
        {
            return 2;
            
        }
            break;
        default:
            break;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            case 0:
            {
                
                XFActorBestTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"XFActorBestTableViewCell"];
                
                if (cell == nil) {
                    
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"XFActorBestTableViewCell" owner:nil
                                                        options:nil] lastObject];
                    
                }
                
                return cell;
            }
            break;
            
            case 2:
        {
            XFNewActorTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFNewActorTableViewCell" owner:nil options:nil] lastObject];
            
            return cell;
            
        }
            case 4:
        {
            switch (indexPath.row) {
                    
                    case 0:
                {
                    
                    XFActorInviteTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFActorInviteTableViewCell" owner:nil options:nil] lastObject];
                    
                    return cell;
                 }
                    break;
                    
                    case 1:
                {
                    XFActorInviteBottomTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"XFActorInviteBottomTableViewCell" owner:nil options:nil] lastObject];
                    
                    return cell;
                }
                    break;
            }
            
        }
            
            break;
        default:
            break;
    }
    
    return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            case 0:
        {
            return kActorTopCellHeader;
        }
            break;
            
            case 2:
        {
            return kActorSecondCellHeight;
        }
            break;
            case 4:
        {
            switch (indexPath.row) {
                    
                    case 0:
                {
                    return kActorInviteCellHeight;
                }
                    break;
                    case 1:
                {
                    return kActorBottomCellHeight;
                }
                    break;
            }
            
        }
        default:
            break;
    }
    
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
            case 0:
        {
            return 47;
            
        }
            break;
            case 1:
        {
            return 37;
            
        }
            break;
            case 2:
        {
            return 47;
            
        }
            break;
            case 3:
        {
            return 37;
            
        }
            break;
            case 4:
        {
            return 47;
            
        }
            break;
        default:
            break;
    }
    return 47;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}


//固定头部视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XFActorSectionHeader *header = [[XFActorSectionHeader alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 47))];
    
    UIView *footer = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 37))];
    
    switch (section) {
            case 0:
        {
            header.lineView.image = [UIImage imageNamed:@"actor_yline"];
            header.titleLabel.text = @"精选演员";
        }
            break;
            case 1:
        {
            UIButton *moreButton = [[UIButton alloc] init];
            
            [moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
            
            [moreButton setTitleColor:kMainColor forState:(UIControlStateNormal)];
            
            [moreButton setImage:[UIImage imageNamed:@"actor_down"] forState:(UIControlStateNormal)];
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [footer addSubview:moreButton];
            
            moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
            
            moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
            
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.mas_offset(0);
                
            }];
            
            self.moreButton1 = moreButton;
            [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(UIControlEventTouchUpInside)];

            return footer;

        }
            break;
            case 2:
        {
            header.lineView.image = [UIImage imageNamed:@"actor_rline"];
            header.titleLabel.text = @"新晋演员";
        }
            break;
            case 3:
        {
            UIButton *moreButton = [[UIButton alloc] init];
            
            [moreButton setTitle:@"查看更多" forState:(UIControlStateNormal)];
            
            [moreButton setTitleColor:kMainColor forState:(UIControlStateNormal)];
            
            [moreButton setImage:[UIImage imageNamed:@"actor_down"] forState:(UIControlStateNormal)];
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [footer addSubview:moreButton];
            
            moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -27, 0, 0);
            
            moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 0);
            
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.mas_offset(0);
                
            }];
            
            self.moreButton2 = moreButton;
            
            [moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            return footer;

        }
            break;
            
            case 4:
        {
            header.lineView.image = [UIImage imageNamed:@"actor_pline"];
            header.titleLabel.text = @"推荐演员";
        }
            break;

            
        default:
            break;
    }
    
    return header;
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    
    [self.view addSubview:self.tableView];

//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_offset(0);
//
//    }];
    
}


@end
