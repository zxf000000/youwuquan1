//
//  XFMineViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFMineViewController.h"
#import "XFMyHeaderNode.h"
#import "XFMyMoneyViewController.h"
#import "XFMyInfoViewController.h"
#import "XFSetViewController.h"
#import "XFMyPhotoViewController.h"
#import "XFMyAuthViewController.h"
#import "XFLoginVCViewController.h"
#import "XFMyActorCardViewController.h"
#import "XFEverydayMissionViewController.h"
#import "XFLeaderboardViewController.h"
#import "XFSkillsViewController.h"
#import "XFDownloadViewController.h"
#import "XFYwqAlertView.h"
#import "XFLoginManager.h"
#import "XFShareManager.h"


#define kHeaderHeight (kScreenWidth * 170/375.f)

@implementation XFMyTableCellNode

- (instancetype)initWithEnd:(BOOL)end {
    
    if (self = [super init]) {
        _isEnd = end;
        
        self.backgroundColor = kBgGrayColor;

        
        _bgNode = [[ASDisplayNode alloc] init];
        
        if (_isEnd) {
            _bgNode.shadowColor = UIColorHex(808080).CGColor;
            _bgNode.shadowOffset = CGSizeMake(0, 1);
            _bgNode.shadowOpacity = 0.5;
            
        }
        
        _bgNode.backgroundColor = [UIColor whiteColor];
        [self addSubnode:_bgNode];
        _iconNode = [[ASImageNode alloc] init];
        [self addSubnode:_iconNode];
        
        _titleNode = [[ASTextNode alloc] init];
        [self addSubnode:_titleNode];
        
        

    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:14 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,_titleNode]];
    
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(13, 10, 13, 0)) child:layout];
    ASBackgroundLayoutSpec *back = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:inset background:_bgNode];

    if (self.isEnd) {
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:back];

    } else {
        
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 1, 0)) child:back];
    }
    return nil;
}

@end

@interface XFMineViewController () <ASTableDelegate,ASTableDataSource,XFMyHeaderDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *headerImage;

@property (nonatomic,strong) UIView *headerInfoView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *locationLabel;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,copy) NSArray *titles;

@property (nonatomic,copy) NSArray *imgs;

@property (nonatomic,copy) NSDictionary *userInfo;

@end

@implementation XFMineViewController

- (instancetype)init {
    
    if (self = [super init]) {
        _titles = @[@"每日任务",@"下载",@"设置"];
        _imgs = @[@"me_rw",@"me_xz",@"me_sz"];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的";
    [self setupTableView];
    [self setupHeaderView];
    [self setupInfoView];
    
    self.userInfo = [XFUserInfoManager sharedManager].userInfo;
    [self refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:kRefreshUserInfoKey object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshUserInfoKey object:nil];
    
}

- (void)refreshUserInfo {
    
    // 获取用户信息
    [[XFLoginManager sharedInstance] getUserInfoWithsuccessBlock:^(id reponseDic) {
       
        if (reponseDic) {
            
            NSDictionary *userInfo =  reponseDic[@"data"][0];
            
            //更新用户信息
            [[XFUserInfoManager sharedManager] updateUserInfo:userInfo];
            
            self.userInfo = userInfo;
            
            [self refreshData];
        }
        
    } failedBlock:^(NSError *error) {
        
        
    }];
    
}
// 更新用户数据
- (void)refreshData {
    
    self.nameLabel.text = self.userInfo[@"userNike"];
    [self.iconView setImageWithURL:[NSURL URLWithString:self.userInfo[@"headUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation)];
    
    
}

#pragma mark - headerDelegate

- (void)headerDidClickInvitebutton {
    
    XFYwqAlertView *alert = [XFYwqAlertView showToView:self.view withTitle:@"邀请有礼" detail:@"成功邀请好友将会获得好友消费1%的提成"];
    
    [alert showAnimation];
    
    alert.doneBlock = ^{
      
        [XFShareManager sharedUrl:self.userInfo[@"inviteUrl"]];
        
    };
    
}

- (void)headerDidSelectItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            // 我的资料
            XFMyInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFMyInfoViewController"];
            
            infoVC.hidesBottomBarWhenPushed = YES;
            
            infoVC.userInfo = self.userInfo;
            
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        case 1:
        {
         // 我的认证
            XFMyAuthViewController *authVC = [[XFMyAuthViewController alloc] init];
            
            authVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:authVC animated:YES];
        }
            break;
        case 2:
        {
            // 我的技能
            XFSkillsViewController *skillVC = [[XFSkillsViewController alloc] init];
            
            skillVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:skillVC animated:YES];
            
        }
            break;
        case 3:
        {
            // 我的钱包
            XFMyMoneyViewController *myMoneyVC = [[XFMyMoneyViewController alloc] init];
            myMoneyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myMoneyVC animated:YES];
            
        }
            break;
        case 4:
        {
            // 富豪榜
            XFLeaderboardViewController *leaderBoardVC = [[XFLeaderboardViewController alloc] init];
            leaderBoardVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:leaderBoardVC animated:YES];
        }
            break;
        case 5:
        {
            // 我的相册
            XFMyPhotoViewController *photoVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFMyPhotoViewController"];
            
            photoVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:photoVC animated:YES];
            

        }
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsety = self.tableNode.view.contentOffset.y;
    
    if (offsety < -kHeaderHeight){
        
        CGFloat progress = offsety / kHeaderHeight;
        
        CGFloat width = progress * kScreenWidth;
        
        CGFloat height = progress * kHeaderHeight;
        
        self.headerView.frame = CGRectMake(-(width - kScreenWidth)/2, 0, width, height);
        
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        
        XFSetViewController *setVC  =[[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFSetViewController"];
        
        setVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:setVC animated:YES];
        
    }
    
    switch (indexPath.row) {
            
        case 1:
        {
            XFEverydayMissionViewController *missionVC = [[XFEverydayMissionViewController alloc] init];
            missionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:missionVC animated:YES];
        }
            break;
        case 2:
        {
//            XFMyActorCardViewController *actorVC = [[XFMyActorCardViewController alloc] init];
//            actorVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:actorVC animated:YES];
            // 下载页面
            XFDownloadViewController *downLoadVC = [[XFDownloadViewController alloc] init];
            downLoadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:downLoadVC animated:YES];
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
    }
    
    
}


- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 1 + self.titles.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return ^ASCellNode*() {
            
            XFMyHeaderNode *node = [[XFMyHeaderNode alloc] initWithUserinfo:self.userInfo];
            
            node.delegate = self;
            

            return node;
            
        };
        
    } else {
        
        if (indexPath.row == self.titles.count) {
            
            return ^ASCellNode*() {
                
                XFMyTableCellNode *node = [[XFMyTableCellNode alloc] initWithEnd:YES];
                
                node.iconNode.image = [UIImage imageNamed:self.imgs[indexPath.row - 1]];
                
                [node.titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:self.titles[indexPath.row - 1] lineSpace:2 kern:0];
                
                return node;
                
            };
            
        } else {
            
            return ^ASCellNode*() {
                
                XFMyTableCellNode *node = [[XFMyTableCellNode alloc] initWithEnd:NO];
                
                node.iconNode.image = [UIImage imageNamed:self.imgs[indexPath.row - 1]];
                
                [node.titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:self.titles[indexPath.row - 1] lineSpace:2 kern:0];
                
                return node;
                
            };
            
        }
        

    }
    
    return nil;
}




- (void)setupTableView {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.backgroundColor = kBgGrayColor;
    
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49);
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    [self.view addSubnode:self.tableNode];
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available (ios 11 , * )) {
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
    }
    
    // footer
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 34))];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    
    infoLabel.text = @"版本信息";
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.centerY.mas_offset(-5);
    }];
    
    self.tableNode.view.tableFooterView = footerView;
    
    footerView.backgroundColor = kBgGrayColor;
    
}

- (void)setupHeaderView {
    
    // 头部比例170/375.f
    self.headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, -kHeaderHeight, kScreenWidth, kHeaderHeight))];
    
    self.headerImage = [[UIImageView alloc] init];
    
    self.headerImage.image = [UIImage imageNamed:@"me_dbj"];
    
    [self.headerView addSubview:self.headerImage];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_offset(0);
        
    }];
    
    self.tableNode.view.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    if (@available (ios 11 , * )) {
        self.tableNode.view.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;

    }
    [self.tableNode.view addSubview:self.headerView];
    
    // 粉红
    UIImageView *shadowimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_hong"]];
    
    [self.headerView addSubview:shadowimage];
    
    [shadowimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
        
    }];

}

- (void)clickTapImage {
    
    XFLoginVCViewController *loginVC = [[XFLoginVCViewController alloc] init];
    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    loginNavi.hidesBottomBarWhenPushed = YES;
    
    [self presentViewController:loginNavi animated:YES completion:nil];
}

- (void)setupInfoView {
    
    self.headerInfoView = [[UIView alloc] initWithFrame:(CGRectMake(0, -kHeaderHeight, kScreenWidth, kHeaderHeight))];
    
    self.headerInfoView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    
    [self.tableNode.view addSubview:self.headerInfoView];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.headerInfoView addSubview:self.nameLabel];
    self.nameLabel.text = @"小美同学";
    
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.headerInfoView addSubview:self.locationLabel];
    self.locationLabel.text = @"福田区, 深圳";

    self.locationLabel.font = [UIFont systemFontOfSize:11];
    self.locationLabel.textColor = [UIColor whiteColor];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.top.mas_offset(60);
        
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        
    }];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_tou1"]];
    
    self.iconView.frame = CGRectMake((kScreenWidth - 90)/2, -60, 90, 90);
    
    [self.tableNode.view addSubview:self.iconView];
    
    // TODO:
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapImage)];
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:tapHeader];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}


@end
