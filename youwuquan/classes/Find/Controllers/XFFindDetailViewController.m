//
//  XFFindDetailViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/10.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindDetailViewController.h"
#import "XFFinddetailInfoTableViewCell.h"
#import "XFFindApproveNode.h"
#import "XFConnectNode.h"
#import "XFFindCellNode.h"
#import "XFCarouselView.h"
#import "XFYwqAlertView.h"
#import "XFDateHerViewController.h"
#import "XFShareManager.h"
#import "XFChatViewController.h"
#import "XFStatusDetailViewController.h"


#define kHeaderHeight kScreenWidth

@interface XFFindDetailViewController () <ASTableDelegate,ASTableDataSource,XFFindCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) UIView *myNavigationbar;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) XFCarouselView *headerImage;

@property (nonatomic,strong) UIView *infoView;

// 星座
@property (nonatomic,strong) UIButton *xzButton;
@property (nonatomic,strong) UIButton *distabceButton;

@property (nonatomic,strong) UIButton *followButton;

@property (nonatomic,strong) UIPageControl *wheelPageControl;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation XFFindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小妹同学";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];

    [self setupTableView];
    [self.view bringSubviewToFront:self.myNavigationbar];
    
    [self setupHeaderView];
    [self setupBottomView];
    
    if (@available (ios 11 , * )) {
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
    }

}

#pragma mark - cellNodeDelegate点赞
- (void)findCellNode:(XFFindCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    
    node.likeButton.selected = !node.likeButton.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"打赏用户" icon:@"" remainNUmber:@"100"];
    
    [alertView dsShowanimation];
    
    alertView.doneBlock = ^{
        
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        HUD.contentColor = [UIColor whiteColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.detailsLabel.text = @"打赏成功!";
            UIImageView *img = [[UIImageView alloc] init];
            img.image = [UIImage imageNamed:@"ds_ok"];
            HUD.customView = img;
            HUD.tintColor = [UIColor blackColor];
            HUD.animationType = MBProgressHUDAnimationZoom;
            [HUD hideAnimated:YES afterDelay:0.4];
        });
        
        
        
    };
    
    alertView.cancelBlock = ^{
        
        
    };
    
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 3) {
        
        XFStatusDetailViewController *statusDetailVC = [[XFStatusDetailViewController alloc] init];
        
        [self.navigationController pushViewController:statusDetailVC animated:YES];
        
    }
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            return ^ASCellNode *{
                
                XFFinddetailInfoTableViewCell *node = [[XFFinddetailInfoTableViewCell alloc] init];
                
                return node;
            };
        }
            break;
        case 1:
        {
            
            return ^ASCellNode *{
                
                XFFindApproveNode *node = [[XFFindApproveNode alloc] initWithType:Approve];
                
                
                
                return node;
            };
        }
            break;
        case 2:
        {
            
            return ^ASCellNode *{
                
                XFFindApproveNode *node = [[XFFindApproveNode alloc] initWithType:Skill];
                
                [node.titleNode setFont:[UIFont systemFontOfSize:14] alignment:(NSTextAlignmentLeft) textColor:[UIColor blackColor] offset:0 text:@"技能" lineSpace:2 kern:0];

                return node;
            };
        }
            break;
        case 3:
        {
            
            return ^ASCellNode *{
                
                XFConnectNode *node = [[XFConnectNode alloc] init];
                
                node.clickWechatButton = ^{
                  
                    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.view withTitle:kRandomName icon:nil needNUmber:@"100"];
                    
                    [alertView showAnimation];
                    
                    alertView.doneBlock = ^{
                        
                        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.tabBarController.view];
                        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
                        HUD.contentColor = [UIColor whiteColor];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            HUD.mode = MBProgressHUDModeCustomView;
                            HUD.detailsLabel.text = @"支付成功!";
                            UIImageView *img = [[UIImageView alloc] init];
                            img.image = [UIImage imageNamed:@"ds_ok"];
                            HUD.customView = img;
                            HUD.tintColor = [UIColor blackColor];
                            HUD.animationType = MBProgressHUDAnimationZoom;
                            [HUD hideAnimated:YES afterDelay:0.4];
                        });
                        
                    };
                    
                    
                };
                
                node.clickPhoneButton = ^{
                    
                    
                    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.view withTitle:kRandomName icon:nil needNUmber:@"100"];
                    
                    [alertView showAnimation];
                    alertView.doneBlock = ^{
                        
                        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.tabBarController.view];
                        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
                        HUD.contentColor = [UIColor whiteColor];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            HUD.mode = MBProgressHUDModeCustomView;
                            HUD.detailsLabel.text = @"支付成功!";
                            UIImageView *img = [[UIImageView alloc] init];
                            img.image = [UIImage imageNamed:@"ds_ok"];
                            HUD.customView = img;
                            HUD.tintColor = [UIColor blackColor];
                            HUD.animationType = MBProgressHUDAnimationZoom;
                            [HUD hideAnimated:YES afterDelay:0.4];
                        });
                        
                    };
                };
                
                return node;
            };
        }
            break;
        default:
        {
            
            return ^ASCellNode *{
                
                NSMutableArray *mutableArr = [NSMutableArray array];
                for (NSInteger i = 0 ; i < indexPath.row % 10 ; i ++ ) {
                    
                    [mutableArr addObject:kRandomPic];
                }
                
                XFFindCellNode *node = [[XFFindCellNode alloc] initWithType:Detail pics:mutableArr.copy];
                
                node.delegate = self;
                
                
                return node;
            };
        }
            break;
            
    }

    return nil;
}

#pragma mark - 马上约
- (void)clickYueButton {
    
    XFDateHerViewController *dateHerVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"XFDateHerViewController"];
    
    [self.navigationController pushViewController:dateHerVC animated:YES];
    
}

- (void)setupHeaderView {
    
    self.headerView = [[UIView alloc] init];
    
    self.headerView.backgroundColor = [UIColor whiteColor];

    self.headerImage = [[XFCarouselView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    self.headerImage.wheelPageControl = self.wheelPageControl;
    self.wheelPageControl.numberOfPages = 5;
    [self.headerImage setupWithLocalArray:@[@"find_T2",@"find_T3",@"find_pic7",@"find_pic17",@"find_pic19"]];
    
    [self.headerView addSubview:self.headerImage];
    
//    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.right.bottom.mas_offset(0);
//
//    }];
    
    self.tableNode.view.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.headerView.frame = CGRectMake(0, -kHeaderHeight, kScreenWidth, kHeaderHeight);
    [self.tableNode.view addSubview:self.headerView];
    
    // 遮罩
    UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"find_T1"]];
    
    [self.headerView addSubview:shadowView];
    
    shadowView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderHeight);
    
//    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.right.bottom.mas_offset(0);
//
//    }];
    
    // 个人信息view
    self.infoView = [[UIView alloc] initWithFrame:(CGRectMake(0, -100, kScreenWidth, 100))];
    
    [self.tableNode.view addSubview:self.infoView];
    
    // 个人资料
    _xzButton = [[UIButton alloc] init];
    [_xzButton setTitle:@"天蝎座" forState:(UIControlStateNormal)];
    [_xzButton setImage:[UIImage imageNamed:@"find_sign"] forState:(UIControlStateNormal)];
    [_xzButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _xzButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _xzButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.infoView addSubview:_xzButton];
    
    _distabceButton = [[UIButton alloc] init];
    [_distabceButton setTitle:@"1.63km" forState:(UIControlStateNormal)];
    [_distabceButton setImage:[UIImage imageNamed:@"定位"] forState:(UIControlStateNormal)];
    _distabceButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _distabceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [_distabceButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [self.infoView addSubview:_distabceButton];
    
    _followButton = [[UIButton alloc] init];
    [_followButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:14];

    _followButton.backgroundColor = kMainRedColor;
    [self.infoView addSubview:_followButton];
    [_followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    _followButton.layer.cornerRadius = 4;
    
    [self.infoView addSubview:self.wheelPageControl];
    
    [_xzButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.bottom.mas_offset(-13);
        make.width.mas_equalTo(50);
        
    }];
    [_distabceButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(_xzButton.mas_top).offset(-10);
        make.width.mas_equalTo(50);

    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-25);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.wheelPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_offset(-10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(10);
        
    }];
}



- (void)setupNavigationBar {
    self.myNavigationbar = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kScreenWidth, 64))];
    [self.view addSubview:self.myNavigationbar];
    
    self.myNavigationbar.backgroundColor = kMainRedColor;
    
    UIButton *backButton = [[UIButton alloc] init];
    
    [backButton setImage:[UIImage imageNamed:@"find_back"] forState:(UIControlStateNormal)];
    [backButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    backButton.frame = CGRectMake(10, 33, 60, 30);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [self.myNavigationbar addSubview:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.text = self.title;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [self.myNavigationbar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(35);
        make.centerX.mas_offset(0);
        
    }];
    
    // 分享
    UIButton *shareButton = [[UIButton alloc] init];
    
    [shareButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [shareButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:16];

    [shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myNavigationbar addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_offset(-10);
        
    }];
}

#pragma mark - 分享海报
- (void)clickShareButton {
    
    [XFShareManager sharedImageWithBg:@"backgroundImage" icon:@"find_pic3" name:kRandomName userid:@"ID:2334530" address:@"福田区,深圳"];
    
}

// 聊天
- (void)clickChatButton {
    
    XFChatViewController *chatVC = [[XFChatViewController alloc] initWithConversationType:(ConversationType_PRIVATE) targetId:@""];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)setupTableView {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44);
    self.tableNode.backgroundColor = [UIColor whiteColor];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubnode:self.tableNode];
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    if (@available (ios 11, *)) {
        
        self.tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

- (void)setupBottomView {
    
    self.bottomView = [[UIView alloc] initWithFrame:(CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44))];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.bottomView setMyShadow];
    [self.view addSubview:self.bottomView];
    
    UIButton *chatButton = [[UIButton alloc] init];
    [chatButton setTitle:@"聊天/送钻石" forState:(UIControlStateNormal)];
    [chatButton setImage:[UIImage imageNamed:@"find_comment2"] forState:(UIControlStateNormal)];
    [chatButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    chatButton.titleLabel.font = [UIFont systemFontOfSize:14];
    chatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.bottomView addSubview:chatButton];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(e6e6e6);
    [self.bottomView addSubview:lineView];
    UIButton *yueButton = [[UIButton alloc] init];
    [yueButton setTitle:@"马上约Ta" forState:(UIControlStateNormal)];
    yueButton.backgroundColor = kMainRedColor;
    yueButton.layer.cornerRadius = 5;
    yueButton.titleLabel.font = [UIFont systemFontOfSize:14];

    [chatButton addTarget:self action:@selector(clickChatButton) forControlEvents:(UIControlEventTouchUpInside)];

    [yueButton addTarget:self action:@selector(clickYueButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView addSubview:yueButton];
    
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_offset(0);
        make.width.mas_equalTo(kScreenWidth/2-1);
        
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(chatButton.mas_right);
        make.top.mas_offset(6);
        make.bottom.mas_offset(-6);
        make.width.mas_equalTo(1);
        
    }];
    
    [yueButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(lineView.mas_right).offset(10);
        make.right.mas_offset(-10);
        make.top.mas_offset(5);
        make.bottom.mas_offset(-5);
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsety = self.tableNode.view.contentOffset.y;

    if (offsety < -kScreenWidth + 200) {
        
        CGFloat progress = (offsety + kScreenWidth)/200.f;
        
        self.myNavigationbar.backgroundColor = [UIColor colorWithRed:247/255.f green:47/255.f blue:94/255.f alpha:progress];
        
    } else {
        
        self.myNavigationbar.backgroundColor = [UIColor colorWithRed:247/255.f green:47/255.f blue:94/255.f alpha:1];

    }
    
    if (offsety < -kScreenWidth){
        
        CGFloat progress = offsety / kHeaderHeight;
        
        CGAffineTransform scale = CGAffineTransformMakeScale(-progress, -progress);
        
        CGAffineTransform translation = CGAffineTransformMakeTranslation(0, (progress + 1)*kScreenWidth/2);
        
        self.headerView.transform = CGAffineTransformConcat(scale, translation);

        
    }
}

- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
}
-(UIPageControl *)wheelPageControl{
    if (!_wheelPageControl) {
        _wheelPageControl = [[UIPageControl alloc] init];
        _wheelPageControl.currentPage = 0;
        //        _wheelPageControl.numberOfPages = self.imageNum;
        
    }
    return _wheelPageControl;
}


@end
