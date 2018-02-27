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
#import "XFMyCaresViewController.h"
#import "XFFansViewController.h"
#import "XFAllMyStatusViewController.h"
#import "XFShareUrlViewController.h"
#import "XFShareCardViewController.h"
#import "XFPayViewController.h"
#import "XFAlertViewController.h"
#import "XFMineNetworkManager.h"
#import "XFMyDetailViewController.h"
#import "XFVIPCenterViewController.h"
#import "XFRefreshInfoViewController.h"
#import "XFAuthManager.h"


#define kHeaderHeight (kScreenWidth * 195/375.f)

// 客服电话 4000560128

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

@interface XFMineViewController () <ASTableDelegate,ASTableDataSource,XFMyHeaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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

@property (nonatomic,strong) UIButton *vipButton;

@property (nonatomic,strong) UIButton *diamondsButton;
@property (nonatomic,strong) UIButton *goldButton;
@property (nonatomic,strong) UIButton *addDiamondsButton;
@property (nonatomic,strong) UIButton *addGoldButton;

@property (nonatomic,assign) BOOL isChanged;

@property (nonatomic,assign) BOOL isUp;



@end

@implementation XFMineViewController

- (instancetype)init {
    
    if (self = [super init]) {
        _titles = @[@"下载",@"设置"];
        _imgs = @[@"me_xz",@"me_sz"];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的";
    [self setupTableView];
    [self setupHeaderView];
    [self setupInfoView];
    

    XFMyAuthModel *model = [[XFAuthManager sharedManager].authList lastObject];
    
    
//    if ([model.identificationName isEqualToString:@"基本认证"]) {
//        _isUp = YES;
//
//
//    } else {
        _isUp = NO;

//    }
    [self loadData];
   
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:kRefreshUserInfoKey object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (self.isChanged) {
        
        [self refreshUserInfo];
        [self loadBalanceInfo];
    }
    
    //    [self loadData];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshUserInfoKey object:nil];
    
}

- (void)loadData {
    
    if ([XFUserInfoManager sharedManager].userInfo) {
        
        self.userInfo = [XFUserInfoManager sharedManager].userInfo;

        [self refreshData];
        
    } else {
        
        [self refreshUserInfo];
        
    }
    
}

- (void)loadBalanceInfo {
    
    [XFMineNetworkManager getMyWalletDetailWithsuccessBlock:^(id responseObj) {
        
        XFMyMoneyModel *model = [XFMyMoneyModel modelWithDictionary:(NSDictionary *)responseObj];
        
        [self.diamondsButton setTitle:[NSString stringWithFormat:@"%zd",[model.balance integerValue]] forState:(UIControlStateNormal)];
        [self.goldButton setTitle:[NSString stringWithFormat:@"%zd",[model.coin integerValue]] forState:(UIControlStateNormal)];

    } failedBlock:^(NSError *error) {
        
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
}

- (void)refreshUserInfo {
    
    // 获取用户信息
    [XFMineNetworkManager getAllInfoWithsuccessBlock:^(id responseObj) {
        
        [[XFUserInfoManager sharedManager] updateUserInfo:responseObj];
        
        if (self.userInfo != responseObj) {
            
            self.userInfo = responseObj;
            [self refreshData];

        }
        
        
        
    } failedBlock:^(NSError *error) {
        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
    
}
// 更新用户数据
- (void)refreshData {
    
    self.nameLabel.text = self.userInfo[@"basicInfo"][@"nickname"];
    [self.iconView setImageWithURL:[NSURL URLWithString:self.userInfo[@"basicInfo"][@"headIconUrl"]] placeholder:[UIImage imageNamed:@"logo"]];
    [self.tableNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    // vip
    if ([self.userInfo[@"vip"][@"vipLevel"] isEqualToString:@"none"]) {
        
        self.vipButton.selected = NO;
        
    } else {
        
        self.vipButton.selected = YES;

    }
    
    [[XFUserInfoManager sharedManager] updateUserInfo:self.userInfo];

}

#pragma mark - headerDelegate
// 动态哦
- (void)headerDidClickStatuslabel {
    
    XFMyDetailViewController *detailVC = [[XFMyDetailViewController alloc] init];
    detailVC.userId = self.userInfo[@"basicInfo"][@"uid"];
    detailVC.userName = self.userInfo[@"basicInfo"][@"nickname"];
    detailVC.iconUrl = self.userInfo[@"basicInfo"][@"headIconUrl"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
//    XFAllMyStatusViewController *myStatusVC = [[XFAllMyStatusViewController alloc] init];
//
//    myStatusVC.hidesBottomBarWhenPushed = YES;
//
//    [self.navigationController pushViewController:myStatusVC animated:YES];
    
}
// 关注
- (void)headerDidClickCarelabel {
    
    XFMyCaresViewController *caresVC = [[XFMyCaresViewController alloc] init];
    caresVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:caresVC animated:YES];
}
// 粉丝
- (void)headerDidClickfanslabel {
    
    XFFansViewController *fansVC = [[XFFansViewController alloc] init];
    fansVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (void)headerDidClickInvitebutton {
    
    XFYwqAlertView *alert ;
    
//    if (_isUp) {
//
//        alert = [XFYwqAlertView showToView:self.view withTitle:@"邀请有礼" detail:@"邀请好友"];;
//
//    } else {
    
        alert = [XFYwqAlertView showToView:self.view withTitle:@"邀请有礼" detail:@"成功邀请好友将会获得好友消费1%的提成"];;
//    }
    
    [alert showAnimation];
    
    alert.doneBlock = ^{
      
//        [XFShareManager sharedUrl:self.userInfo[@"inviteUrl"]];
        
        
        XFShareCardViewController *shareSelectVC = [[XFShareCardViewController alloc] init];
        
        shareSelectVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:shareSelectVC animated:YES];
        
    };
    
}

- (void)headerDidSelectItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            // 我的资料
            
            XFRefreshInfoViewController *refreshInfoVC = [[XFRefreshInfoViewController alloc] init];
            refreshInfoVC.userInfo = self.userInfo;
            refreshInfoVC.refreshInfoBlock = ^{
              
                [self refreshUserInfo];
                [self loadBalanceInfo];
                
            };
            refreshInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:refreshInfoVC animated:YES];
            
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
            
            if (self.isUp) {
                
                // 富豪榜
                XFLeaderboardViewController *leaderBoardVC = [[XFLeaderboardViewController alloc] init];
                leaderBoardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:leaderBoardVC animated:YES];
            } else {
                
                // vip中心
                XFVIPCenterViewController *vipVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFVIPCenterViewController"];
                vipVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vipVC animated:YES];
                
            }
            

        }
            break;
        case 3:
        {
            if (self.isUp) {
                
                [XFToolManager showProgressInWindowWithString:@"敬请期待"];
                
                return;

                
            } else {
                
                // 我的钱包
                XFMyMoneyViewController *myMoneyVC = [[XFMyMoneyViewController alloc] init];
                myMoneyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myMoneyVC animated:YES];
            }
            

            
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
//            XFMyPhotoViewController *photoVC = [[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFMyPhotoViewController"];
//
//            photoVC.hidesBottomBarWhenPushed = YES;
//
//            photoVC.photoAlbums = self.userInfo[@"albums"];
//            [self.navigationController pushViewController:photoVC animated:YES];
            
            // 我的技能
            [XFToolManager showProgressInWindowWithString:@"敬请期待"];
            
            return;
            //            XFSkillsViewController *skillVC = [[XFSkillsViewController alloc] init];
            //
            //            skillVC.hidesBottomBarWhenPushed = YES;
            //
            //            [self.navigationController pushViewController:skillVC animated:YES];
            

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
    
    XFMyTableCellNode *node = [tableNode nodeForRowAtIndexPath:indexPath];
    
    [node setSelected:NO];
    
    switch (indexPath.row) {
            
        case 1:
        {
            // 下载页面
            XFDownloadViewController *downLoadVC = [[XFDownloadViewController alloc] init];
            downLoadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:downLoadVC animated:YES];
//            XFEverydayMissionViewController *missionVC = [[XFEverydayMissionViewController alloc] init];
//            missionVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:missionVC animated:YES];
        }
            break;
        case 2:
        {
            
            XFSetViewController *setVC  =[[UIStoryboard storyboardWithName:@"My" bundle:nil] instantiateViewControllerWithIdentifier:@"XFSetViewController"];
            
            setVC.hidesBottomBarWhenPushed = YES;
            
            setVC.tabbarVC = (XFMainTabbarViewController *)self.tabBarController;
            
            [self.navigationController pushViewController:setVC animated:YES];

            
        }
            break;
        case 3:
        {
            // 下载页面
            XFDownloadViewController *downLoadVC = [[XFDownloadViewController alloc] init];
            downLoadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:downLoadVC animated:YES];
        }
            break;
    }
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 1 + self.titles.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        XFMyHeaderNode *node = [[XFMyHeaderNode alloc] initWithUserinfo:self.userInfo];
        
        node.delegate = self;
        
        node.neverShowPlaceholders = YES;
        
        return node;
        
    } else {
        
        if (indexPath.row == self.titles.count) {
            
            XFMyTableCellNode *node = [[XFMyTableCellNode alloc] initWithEnd:YES];
            
            node.iconNode.image = [UIImage imageNamed:self.imgs[indexPath.row - 1]];
            
            [node.titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:self.titles[indexPath.row - 1] lineSpace:2 kern:0];
            node.neverShowPlaceholders = YES;
            
            return node;
            
        } else {
            
            XFMyTableCellNode *node = [[XFMyTableCellNode alloc] initWithEnd:NO];
            
            node.iconNode.image = [UIImage imageNamed:self.imgs[indexPath.row - 1]];
            
            [node.titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentCenter) textColor:[UIColor blackColor] offset:0 text:self.titles[indexPath.row - 1] lineSpace:2 kern:0];
            node.neverShowPlaceholders = YES;
            
            return node;
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
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 60))];
    
    NSString *contact = @"联系客服 4000 560 128";
    NSRange rangeofNumber = [contact rangeOfString:@"4000 560 128"];
    
    NSMutableAttributedString *contactStr = [[NSMutableAttributedString alloc] initWithString:contact];
    
    [contactStr setTextHighlightRange:rangeofNumber color:kRGBColorWith(0.093, 0.492, 1) backgroundColor:[UIColor whiteColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
       
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-560-128"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        NSLog(@"打电话");
    }];
    [contactStr setColor:[UIColor blueColor] range:rangeofNumber];

    YYLabel *contactLabel = [[YYLabel alloc] init];
    [contactLabel setAttributedText:contactStr];
    
    [footerView addSubview:contactLabel];

    
    UILabel *infoLabel = [[UILabel alloc] init];
    
    infoLabel.text = @"版本 1.0";
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:infoLabel];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_offset(10);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_offset(30);

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:@"正在保存"];
        
        // 上传头像
        
        [XFMineNetworkManager uploadIconWithImage:image successBlock:^(id responseObj) {
            
            [XFToolManager changeHUD:HUD successWithText:@"保存成功"];
            self.iconView.image = image;

            
        } failedBlock:^(NSError *error) {
            
            [HUD hideAnimated:YES];

        } progressBlock:^(CGFloat progress) {
            
            
        }];

    }];
    
}

- (void)clickTapImage {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *actionCar = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *actionphoto = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];

    }];
    
    [alert addAction:actionphoto];
    [alert addAction:actionCar];
    [alert addAction:actionCancel];

    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)clickAddMoneyButton:(UIButton *)sender {
    
    if (sender == self.addDiamondsButton) {
        
        XFPayViewController *payVC = [[XFPayViewController alloc] init];
        payVC.type = XFPayVCTypeCharge;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
        [self presentViewController:navi animated:YES completion:nil];
        
    } else {
        
        XFAlertViewController *alertVC = [[XFAlertViewController alloc] init];
        alertVC.type = XFAlertViewTypeChangeCoin;
        
        __weak typeof(alertVC) weakAlert = alertVC;
        alertVC.clickDoneButtonBlock = ^(XFAlertViewController *alert) {
          
            // 点击兑换
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:[UIApplication sharedApplication].keyWindow];
            [XFMineNetworkManager exchangeCoinsNumForDiamonds:[weakAlert.numberTextField.text longValue] successBlock:^(id responseObj) {
                
                [XFToolManager changeHUD:HUD successWithText:@"兑换成功"];
                
                [self loadBalanceInfo];
                
            } failedBlock:^(NSError *error) {
                
                [HUD hideAnimated:YES];
                
            } progressBlock:^(CGFloat progress) {
                
                
            }];
            
        };
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    

    
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
    
//    self.vipButton = [[UIButton alloc] init];
//    [self.vipButton setImage:[UIImage imageNamed:@"mine_vip"] forState:(UIControlStateNormal)];
//    [self.vipButton setImage:[UIImage imageNamed:@"mine_vip"] forState:(UIControlStateSelected)];
//    [self.vipButton setTitle:@"会员" forState:(UIControlStateNormal)];
//    self.vipButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.vipButton addTarget:self action:@selector(clickVipButton) forControlEvents:(UIControlEventTouchUpInside)];
//    self.vipButton.contentMode = UIViewContentModeScaleToFill;
//    [self.headerInfoView addSubview:self.vipButton];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.headerInfoView addSubview:self.locationLabel];
    self.locationLabel.text = @"福田区, 深圳";

    self.locationLabel.font = [UIFont systemFontOfSize:11];
    self.locationLabel.textColor = [UIColor whiteColor];

    
//    self.diamondsButton = [[UIButton alloc] init];
//    [self.diamondsButton setImage:[UIImage imageNamed:@"zuanshi"] forState:(UIControlStateNormal)];
//    [self.diamondsButton setTitle:@"12345" forState:(UIControlStateNormal)];
//    self.diamondsButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.headerInfoView addSubview:self.diamondsButton];
    
//    self.goldButton = [[UIButton alloc] init];
//    [self.goldButton setImage:[UIImage imageNamed:@"money_jinbi"] forState:(UIControlStateNormal)];
//    [self.goldButton setTitle:@"12345" forState:(UIControlStateNormal)];
//    self.goldButton.titleLabel.font = [UIFont systemFontOfSize:12];

//    [self.headerInfoView addSubview:self.goldButton];
//
//    self.addDiamondsButton = [[UIButton alloc] init];
//    [self.addDiamondsButton setImage:[UIImage imageNamed:@"money_addwhite"] forState:(UIControlStateNormal)];
//    [self.headerInfoView addSubview:self.addDiamondsButton];
//
//    self.addGoldButton = [[UIButton alloc] init];
//    [self.addGoldButton setImage:[UIImage imageNamed:@"money_addwhite"] forState:(UIControlStateNormal)];
//    [self.headerInfoView addSubview:self.addGoldButton];
//
//    [self.addGoldButton addTarget:self action:@selector(clickAddMoneyButton:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.addDiamondsButton addTarget:self action:@selector(clickAddMoneyButton:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.top.mas_offset(60);
        
    }];
    
//    [self.vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.mas_equalTo(self.nameLabel);
////        make.left.mas_equalTo(self.nameLabel.mas_right);
//        make.right.mas_offset(-10);
//        make.width.height.mas_equalTo(50);
//    }];
//
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        
    }];
    
//    [self.addDiamondsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.bottom.mas_offset(-7);
//        make.right.mas_equalTo(self.headerInfoView.mas_centerX).offset(-70);
//        make.height.width.mas_equalTo(20);
//
//    }];
//
//    [self.goldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.bottom.mas_offset(-7);
//        make.left.mas_equalTo(self.headerInfoView.mas_centerX).offset(70);
//
//    }];
//
//    [self.addGoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.goldButton.mas_right).offset(10);
//        make.centerY.mas_equalTo(self.addDiamondsButton);
//        make.height.width.mas_equalTo(20);
//
//    }];
//
//    [self.diamondsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.mas_equalTo(self.addDiamondsButton.mas_left).offset(-10);
//        make.centerY.mas_equalTo(self.addDiamondsButton);
//
//    }];
    
//        [self.addGoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.bottom.mas_offset(-7);
//            make.right.mas_equalTo(self.headerInfoView.mas_centerX).offset(-70);
//            make.height.width.mas_equalTo(20);
//
//        }];
//
//        [self.goldButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.right.mas_equalTo(self.addGoldButton.mas_left).offset(-10);
//            make.centerY.mas_equalTo(self.addGoldButton);
//
//        }];
//
//            [self.diamondsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                make.bottom.mas_equalTo(self.goldButton.mas_top).offset(-7);
//                make.right.mas_equalTo(self.goldButton);
//
//            }];
//
//            [self.addDiamondsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//                make.right.height.width.mas_equalTo(self.addGoldButton);
//                make.centerY.mas_equalTo(self.diamondsButton);
//
//            }];
//
//        [self.vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.right.mas_offset(-20);
//            make.width.height.mas_equalTo(70);
//            make.centerY.mas_equalTo(self.goldButton.mas_top).offset(-3);
//
//        }];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_tou1"]];
    
    self.iconView.frame = CGRectMake((kScreenWidth - 90)/2, -60, 90, 90);
    
    [self.tableNode.view addSubview:self.iconView];
    
    self.iconView.layer.cornerRadius = 45;
    self.iconView.layer.masksToBounds = YES;
    
//    // TODO:
//    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapImage)];
//    self.iconView.userInteractionEnabled = YES;
//    [self.iconView addGestureRecognizer:tapHeader];
//
}

- (void)clickVipButton {
    
    XFPayViewController *payVC = [[XFPayViewController alloc] init];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

@end
