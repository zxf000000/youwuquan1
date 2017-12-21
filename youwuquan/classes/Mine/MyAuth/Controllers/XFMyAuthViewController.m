//
//  XFMyAuthViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMyAuthViewController.h"
#import "XFYwqAlertView.h"
#import "XFAddAuthTableViewController.h"

@implementation XFmyAuthCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _iconView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];

        [self.contentView addSubview:_titleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_offset(15);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(8.5);
        make.centerX.mas_offset(0);
        
    }];
    
    [super updateConstraints];
}

@end


@interface XFMyAuthViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UILabel *detailLabel;


@property (nonatomic,copy) NSArray *icons;
@property (nonatomic,copy) NSArray *titles;
@property (nonatomic,copy) NSArray *unAuthIcons;


@end

@implementation XFMyAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的认证";
    [self setupScrollView];
    [self setupCollectionView];
    [self setupLabels];

}


- (void)setupLabels {
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorHex(e6e6e6);
    self.lineView.frame = CGRectMake(0, self.collectionView.frame.origin.y + self.collectionView.frame.size.height + 30, kScreenWidth, 1);
    
    [self.scrollView addSubview:self.lineView];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.text = @"注：尤物圈认证规则";
    self.desLabel.font = [UIFont systemFontOfSize:15];
    self.desLabel.textColor = UIColorHex(000000);
    [self.scrollView addSubview:self.desLabel];
    self.desLabel.frame = CGRectMake(10, self.lineView.frame.origin.y + 1 + 15, kScreenWidth, 17);
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = UIColorHex(808080);
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    self.detailLabel.numberOfLines = 0;
    NSString *str = @"1.认证需上传本人相关视频，如\'嗨歌达人\'需上传跟歌唱相关的视频；\n2.视频不少于10秒钟，且必须本人出镜；\n3.禁止上传违法视频；\n4.其他相关规则内容。\n5.用户已认证的项目图标为彩色，未认证的项目图标为灰色，点击进去可以进行认证申请。";
    
    
    self.detailLabel.text = str;
    
    CGRect frame = [str boundingRectWithSize:(CGSizeMake(kScreenWidth - 20, MAXFLOAT)) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.detailLabel.frame = CGRectMake(10, self.desLabel.frame.origin.y + self.desLabel.frame.size.height + 10, kScreenWidth - 20, frame.size.height);
    
    [self.scrollView addSubview:self.detailLabel];
    

    
}

#pragma mark - collectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 确定按钮
    XFAddAuthTableViewController *addVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFAddAuthTableViewController"];
    
    [self.navigationController pushViewController:addVC animated:YES];
    
//    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.view withTitle:@"申请须知" detail:@"1.认证尤物女神需缴1500元；\n2.1500元我们将为您拍摄1—10张精美写真。"];
//
//    alertView.doneBlock = ^{
//
//
//
//    };
//
//    alertView.cancelBlock = ^{
//
//        // 取消
//
//    };
//
//    [alertView showAnimation];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.icons.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XFmyAuthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFmyAuthCell" forIndexPath:indexPath];
    
    if (indexPath.item < 5) {
        cell.iconView.image = [UIImage imageNamed:self.icons[indexPath.item]];

    } else {
        cell.iconView.image = [UIImage imageNamed:self.unAuthIcons[indexPath.item]];

        
    }
    
    cell.titleLabel.text = self.titles[indexPath.item];
    
    return cell;
    
}


- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64))];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
}

- (void)setupCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (kScreenWidth - 25)/4;
    CGFloat itemHeight = itemWidth - 25 + 46;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, itemHeight * 3)) collectionViewLayout:layout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[XFmyAuthCell class] forCellWithReuseIdentifier:@"XFmyAuthCell"];
    
}

- (NSArray *)icons {
    
    if (_icons == nil) {
        
        _icons = @[@"my_vip",@"me_v",@"me_r",@"me_s",@"me_d",@"me_h",@"me_m",@"me_f",@"me_t",@"me_a",@"me_p",@"me_c"];
    }
    return _icons;
    
}

- (NSArray *)unAuthIcons {
    
    if (_unAuthIcons == nil) {
        
        _unAuthIcons = @[@"my_noVip",@"me_v_none",@"me_r_none",@"me_s_none",@"me_d_none",@"me_h_none",@"me_m_none",@"me_f_none",@"me_t_none",@"me_a_none",@"me_p_none",@"me_c_none"];
    }
    return _unAuthIcons;
    
}

- (NSArray *)titles {
    
    if (_titles == nil) {
        
        _titles = @[@"VIP",@"尤物女神",@"网红",@"演员",@"精舞达人",@"嗨歌大人",@"美妆达人",@"美食达人",@"旅游达人",@"运动达人",@"摄影达人",@"穿搭达人"];
    }
    return _titles;
    
}


@end
