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
#import "XFCarouselView.h"
#import "XFYwqAlertView.h"
#import "XFDateHerViewController.h"
#import "XFShareManager.h"
#import "XFChatViewController.h"
#import "XFStatusDetailViewController.h"
#import "XFFIndCacheManager.h"
#import "XFGiftViewController.h"

#import "XFFindNetworkManager.h"
#import "XFMineNetworkManager.h"
#import "SDCycleScrollView.h"
#import "XFPayViewController.h"
#import "XFDetailStatusCellNode.h"
#import "XFUpImageNode.h"
#import "XFMyAuthViewController.h"

#define kHeaderHeight kScreenWidth

@interface XFFindDetailViewController () <ASTableDelegate,ASTableDataSource,XFStatusCellNodeDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) UIView *myNavigationbar;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) SDCycleScrollView *headerImage;

@property (nonatomic,strong) UIView *infoView;

// 星座
@property (nonatomic,strong) UIButton *xzButton;
@property (nonatomic,strong) UIButton *distabceButton;
@property (nonatomic,strong) UILabel *idLabel;
@property (nonatomic,strong) UILabel *careLabel;
@property (nonatomic,strong) UILabel *fansLabel;

@property (nonatomic,strong) UIButton *followButton;

@property (nonatomic,strong) UIPageControl *wheelPageControl;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) NSIndexPath  *openIndexpath;

@property (nonatomic,copy) NSArray *datas;

@property (nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic,copy) NSArray *photoWallDatas;

@property (nonatomic,weak) UILabel *titleLabbel;

@property (nonatomic,copy) NSDictionary *relation;

@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation XFFindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小妹同学";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datas = [XFFIndCacheManager sharedManager].findData;

    
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
    
    self.HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    self.tableNode.alpha = 0;
    [self network];
}

- (void)network {
    
    // 获取广告
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadPicWall];
    }];
    // 获取认证信息列表
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadInfo];
    }];
    
    // 获取首页数据
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self loadStatusData];
    }];
    
    [operation3 addDependency:operation2];      //任务二依赖任务一

    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
    
}

- (void)loadPicWall {

    
    [XFMineNetworkManager getOtherPhotoWallWithUserId:self.userId successBlock:^(id responseObj) {
        
        NSArray *datas = (NSArray *)responseObj;
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < datas.count; i ++ ) {
            
            NSDictionary *info = datas[i];
            
            [arr addObject:info[@"image"][@"imageUrl"]];
            
        }
        
        self.photoWallDatas = arr.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self refreshPhotoWall];

        });
        

    } failedBlock:^(NSError *error) {
        

    } progressBlock:^(CGFloat progress) {
        
        
    }];

}

- (void)loadInfo {
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    [XFMineNetworkManager getOtherInfoWithUid:self.userId successBlock:^(id responseObj) {
        
        self.userInfo = ((NSDictionary *)responseObj)[@"info"];
        
        self.relation = ((NSDictionary *)responseObj)[@"relation"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshHeaderData];

        });
        
        
        dispatch_semaphore_signal(sema);

        
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(sema);

        
    } progressBlock:^(CGFloat progress) {
        
        
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

}

- (void)loadStatusData {

    [XFFindNetworkManager getOtherStatusListWithUserId:self.userId successBlock:^(id responseObj) {
        
        NSArray *datas = ((NSDictionary *)responseObj)[@"content"];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i< datas.count ; i ++ ) {
            
            [arr addObject:[XFStatusModel modelWithDictionary:datas[i]]];
            
        }
        self.datas = arr.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableNode reloadDataWithCompletion:^{
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.tableNode.alpha = 1;
                    
                }];
                [self.HUD hideAnimated:YES];
            }];
        });
        

        

        
    } failBlock:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.HUD hideAnimated:YES];

        });

    } progress:^(CGFloat progress) {
        
        
    }];
    
}

- (void)refreshHeaderData {
    
    [self.xzButton setTitle:self.userInfo[@"starSign"] forState:(UIControlStateNormal)];

    _idLabel.text = [NSString stringWithFormat:@"ID: %@",_userInfo[@"uid"]];
    _careLabel.text = [NSString stringWithFormat:@"关注 %@",_userInfo[@"followNum"]?_userInfo[@"followNum"]:@"0"];
    _fansLabel.text = [NSString stringWithFormat:@"粉丝 %@",_userInfo[@"fansNum"]?_userInfo[@"fansNum"]:@"0"];
//    _titleLabbel.text = self.userInfo[@"nickname"];
    _followButton.selected = [self.relation[@"followed"] boolValue];
    
    if (_followButton.selected) {
        
        _followButton.backgroundColor = UIColorHex(808080);
    } else {
        
        _followButton.backgroundColor = kMainRedColor;

    }
    
}

- (void)refreshPhotoWall {
    
    if (self.photoWallDatas.count == 0) {
        
        
    } else {
        
        self.headerImage.imageURLStringsGroup = self.photoWallDatas;

    }
    
}

#pragma mark - cellNodeDelegate点赞
// 分享


- (void)statusCellNode:(XFDetailStatusCellNode *)node didClickShareButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFStatusModel *status = self.datas[inexPath.row - 4];
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:status.user[@"headIconUrl"]] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        // 分享
        [XFShareManager sharedImageWithBg:@"" icon:image name:status.user[@"nickname"] userid:[NSString stringWithFormat:@"ID:%@",status.user[@"uid"]] address:@"深圳南山区"];
    }];
    

    
}

- (void)statusCellNode:(XFDetailStatusCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    
    XFStatusModel *model = self.datas[indexPath.row - 4];
    
    if (model.likedIt) {
        
        [XFFindNetworkManager unlikeWithStatusId:model.id successBlock:^(id responseObj) {
            
            [self refreshlikeStatusWithModel:model witfFollowed:NO];
            [node.likeButton setTitle:model.likeNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
            
            node.likeButton.selected = NO;
            
            [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
                
                
            }];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFFindNetworkManager likeWithStatusId:model.id successBlock:^(id responseObj) {
            
            [self refreshlikeStatusWithModel:model witfFollowed:YES];
            
            [node.likeButton setTitle:model.likeNum withFont:[UIFont systemFontOfSize:13] withColor:UIColorHex(e0e0e0) forState:(UIControlStateNormal)];
            
            node.likeButton.selected = YES;
            
            [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
                
                
            }];
            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
    }
    
    
    node.likeButton.selected = !node.likeButton.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer complate:^{
        
        
    }];
    
}

- (void)refreshlikeStatusWithModel:(XFStatusModel *)model witfFollowed:(BOOL)liked {
    
    model.likedIt = liked;
    if (liked) {
        
        model.likeNum = [NSString stringWithFormat:@"%zd",[model.likeNum integerValue] + 1];
        
    } else {
        
        model.likeNum = [NSString stringWithFormat:@"%zd",[model.likeNum integerValue] - 1];
        
    }
    
}

- (void)statusCellNode:(XFDetailStatusCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFStatusModel *model = self.datas[inexPath.row - 4];
    
    XFGiftViewController *giftVC = [[XFGiftViewController alloc] init];
    giftVC.userName = model.user[@"nickname"];
    giftVC.uid = model.uid;
    giftVC.iconUrl = model.user[@"headIconUrl"];
    
    [self presentViewController:giftVC animated:YES completion:nil];
    
    return;
//
//    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"打赏用户" icon:@"" remainNUmber:@"100"];
//
//    [alertView dsShowanimation];
//
//    alertView.doneBlock = ^{
//
//        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
//        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
//        HUD.contentColor = [UIColor whiteColor];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//        });
//
//
//
//    };
//
//    alertView.cancelBlock = ^{
//
//
//    };
    
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row > 3) {
        
        XFStatusDetailViewController *statusDetailVC = [[XFStatusDetailViewController alloc] init];
        
        statusDetailVC.type = Other;
        statusDetailVC.status = self.datas[indexPath.row - 4];
        
        [self.navigationController pushViewController:statusDetailVC animated:YES];
        
    }
    
}

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen {
    
    if (isOpen) {
        self.openIndexpath = index;
        
    } else {
        
        self.openIndexpath = nil;
        
    }
    
    [self.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationNone)];

}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count + 4;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            return ^ASCellNode *{
                
                XFFinddetailInfoTableViewCell *node = [[XFFinddetailInfoTableViewCell alloc] initWithUserInfo:self.userInfo];
                
                return node;
            };
        }
            break;
        case 1:
        {
            
            return ^ASCellNode *{
                
                XFFindApproveNode *node = [[XFFindApproveNode alloc] initWithType:Approve auths:self.userInfo[@"identifications"]];
                node.moreAuthBlock = ^{
                  
                    // 跳转到认证页面
                    XFMyAuthViewController *authVC = [[XFMyAuthViewController alloc] init];
                    
                    [self.navigationController pushViewController:authVC animated:YES];
                    
                };
                return node;
            };
        }
            break;
        case 2:
        {
            
            return ^ASCellNode *{
                
                XFFindApproveNode *node = [[XFFindApproveNode alloc] initWithType:Skill auths:self.userInfo[@"identifications"]];
                
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
                        
//                        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.tabBarController.view];
//                        HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//                        HUD.bezelView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
//                        HUD.contentColor = [UIColor whiteColor];
//
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            HUD.mode = MBProgressHUDModeCustomView;
//                            HUD.detailsLabel.text = @"支付成功!";
//                            UIImageView *img = [[UIImageView alloc] init];
//                            img.image = [UIImage imageNamed:@"ds_ok"];
//                            HUD.customView = img;
//                            HUD.tintColor = [UIColor blackColor];
//                            HUD.animationType = MBProgressHUDAnimationZoom;
//                            [HUD hideAnimated:YES afterDelay:0.4];
//                        });
                        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
                        
                        [XFFindNetworkManager getUserWechatWithUid:self.userId successBlock:^(id responseObj) {
                            [XFToolManager changeHUD:HUD successWithText:@"支付成功!微信/手机会以短信形式发送给您的绑定手机"];
                            // 成功提示
                            
                        } failBlock:^(NSError *error) {
                            [HUD hideAnimated:YES];
                            if (!error) {
                                // 充值页面
                                XFPayViewController *payVC = [[XFPayViewController alloc] init];
                                
                                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
                                
                                [self presentViewController:navi animated:YES completion:nil];
                            }
                            
                        } progress:^(CGFloat progress) {
                            
                            
                        }];
                        
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
                    
                    [mutableArr addObject:@"34"];
                }
                BOOL isOpen;
                
                if (self.openIndexpath == indexPath) {
                    
                    isOpen = YES;
                    
                } else {
                    
                    isOpen = NO;
                }
                
                
                XFDetailStatusCellNode *node = [[XFDetailStatusCellNode alloc] initWithModel:self.datas[indexPath.row - 4]];
                
                node.index = indexPath;
                
                node.delegate = self;
                
                if (self.openIndexpath == indexPath) {
                    
                    node.shadowNode.hidden = YES;
                    
                } else {
                    node.shadowNode.hidden = NO;
                }
                
                return node;
            };
        }
            break;
            
    }

    return nil;
}
#pragma mark - 点击关注
- (void)clickFollowButton:(UIButton *)sender {
    
    MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    if (sender.selected) {
        [XFMineNetworkManager unCareSomeoneWithUid:self.userId successBlock:^(id responseObj) {
            // 取消关注成功
            XFStatusModel *model = [[XFStatusModel alloc] init];
            model.uid = self.userId;
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCareStatusNotification object:@{@"status":model,
                                                                                                               @"followed":@(NO)
                                                                                                               }];

            sender.selected = NO;
            
            if (sender.selected) {
                
                sender.backgroundColor = UIColorHex(808080);
                
            } else {
                
            }
            
            [HUD hideAnimated:YES];
            
        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];

            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFMineNetworkManager careSomeoneWithUid:self.userId successBlock:^(id responseObj) {
            [HUD hideAnimated:YES];

            // 关注成功
            XFStatusModel *model = [[XFStatusModel alloc] init];
            model.uid = self.userId;
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCareStatusNotification object:@{@"status":model,
                                                                                                               @"followed":@(YES)
                                                                                                               }];
            
            sender.selected = YES;
            
            if (sender.selected) {
                
                sender.backgroundColor = UIColorHex(808080);
                
            } else {
                
            }
        } failedBlock:^(NSError *error) {
            [HUD hideAnimated:YES];

            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
    }
    

    
}

#pragma mark - 马上约
- (void)clickYueButton {
    
    XFDateHerViewController *dateHerVC = [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"XFDateHerViewController"];
    
    [self.navigationController pushViewController:dateHerVC animated:YES];
    
}

- (void)setupHeaderView {
    
    self.headerView = [[UIView alloc] init];
    
    self.headerView.backgroundColor = [UIColor whiteColor];

//    self.headerImage = [[XFCarouselView alloc] initWithFrame:];
//    self.headerImage.wheelPageControl = self.wheelPageControl;
//    self.wheelPageControl.numberOfPages = 5;
//    [self.headerImage setupWithLocalArray:@[@"find_T2",@"find_T3",@"find_pic7",@"find_pic17",@"find_pic19"]];
//
    // 网络加载图片的轮播器
//    self.headerImage = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight) delegate:self placeholderImage:nil];
//    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    // 本地加载图片的轮播器
    
    self.headerImage = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight) imageNamesGroup:@[]];
    
    self.headerImage.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    [self.headerView addSubview:self.headerImage];
    
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
    [_distabceButton setTitle:@"  1.63km" forState:(UIControlStateNormal)];
    [_distabceButton setImage:[UIImage imageNamed:@"定位"] forState:(UIControlStateNormal)];
    _distabceButton.titleLabel.font = [UIFont systemFontOfSize:11];
//    _distabceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);

    [_distabceButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [self.infoView addSubview:_distabceButton];
    
    _followButton = [[UIButton alloc] init];
    [_followButton setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    [_followButton setTitle:@"已关注" forState:(UIControlStateSelected)];

    _followButton.titleLabel.font = [UIFont systemFontOfSize:14];

    _followButton.backgroundColor = kMainRedColor;
    [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.infoView addSubview:_followButton];
    [_followButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    _followButton.layer.cornerRadius = 4;
    
    [self.infoView addSubview:self.wheelPageControl];
    
    _idLabel = [[UILabel alloc] init];
    _idLabel.textColor = [UIColor whiteColor];
    _idLabel.font = [UIFont systemFontOfSize:11];
    _idLabel.text = @"ID: 1122334455";
    
    [_infoView addSubview:_idLabel];
    
    _careLabel = [[UILabel alloc] init];
    _careLabel.textColor = [UIColor whiteColor];
    _careLabel.font = [UIFont systemFontOfSize:14];
    _careLabel.text = @"关注 666";
    
    [_infoView addSubview:_careLabel];
    
    _fansLabel = [[UILabel alloc] init];
    _fansLabel.textColor = [UIColor whiteColor];
    _fansLabel.font = [UIFont systemFontOfSize:14];
    _fansLabel.text = @"粉丝 666";
    
    [_infoView addSubview:_fansLabel];
    
    [_careLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.bottom.mas_offset(-13);
    }];
    
    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_careLabel.mas_right).offset(10);
        make.bottom.mas_equalTo(_careLabel);
    }];
    
    [_distabceButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_offset(10);
        make.bottom.mas_equalTo(_careLabel.mas_top).offset(-8);
//        make.width.mas_equalTo(50);
        
    }];
    
    
    [_xzButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_distabceButton.mas_right).offset(10);
        make.bottom.mas_equalTo(_xzButton);
//        make.width.mas_equalTo(50);
    }];
    
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(_distabceButton.mas_top).offset(-10);
        make.left.mas_equalTo(_distabceButton);
        
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
    backButton.frame = CGRectMake(0, 20, 60, 44);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -33, 0, 0);
    [self.myNavigationbar addSubview:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.text = self.userName;
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [self.myNavigationbar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(20);
        make.centerX.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    self.titleLabbel = titleLabel;
    
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

    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:self.iconUrl] options:(YYWebImageOptionSetImageWithFadeAnimation) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return image;
        
        
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
            [XFShareManager sharedImageWithBg:@"backgroundImage" icon:image name:self.userName userid:[NSString stringWithFormat:@"ID:%@",self.userId] address:@"福田区,深圳"];
    }];
    

    
}
#pragma mark - 底部点击
- (void)clickGiftButton {
    
    // 送礼物
    XFGiftViewController *giftVC = [[XFGiftViewController alloc] init];
    
    giftVC.userName = self.userName;
    giftVC.uid = self.userId;
    giftVC.iconUrl = self.iconUrl;
    
    [self presentViewController:giftVC animated:YES completion:nil];

}
// 聊天
- (void)clickChatButton {
    
    XFChatViewController *chatVC = [[XFChatViewController alloc] initWithConversationType:(ConversationType_PRIVATE) targetId:[NSString stringWithFormat:@"%@",self.userId]];
    
    chatVC.title = self.userName;
    
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
    
    XFUpImageNode *chatButton = [[XFUpImageNode alloc] initWithImage:[UIImage imageNamed:@"find_comment2"] title:@"聊TA"];
    

    chatButton.frame = CGRectMake(0, 0, (kScreenWidth / 4.f), 44);
    [self.bottomView addSubnode:chatButton];
    
    XFUpImageNode *giftButton = [[XFUpImageNode alloc] initWithImage:[UIImage imageNamed:@"find_sendgift"] title:@"送礼物"];
    giftButton.frame = CGRectMake((kScreenWidth / 4.f) + 1, 0, (kScreenWidth / 4.f), 44);
    [self.bottomView addSubnode:giftButton];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorHex(e6e6e6);
    lineView.frame = CGRectMake((kScreenWidth / 4.f), 5, 1, 34);
    [self.bottomView addSubview:lineView];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = UIColorHex(e6e6e6);
    line2.frame = CGRectMake((kScreenWidth / 2.f), 5, 1, 34);
    [self.bottomView addSubview:line2];
    UIButton *yueButton = [[UIButton alloc] init];
    [yueButton setTitle:@"马上约Ta" forState:(UIControlStateNormal)];
    yueButton.backgroundColor = kMainRedColor;
    yueButton.layer.cornerRadius = 5;
    yueButton.titleLabel.font = [UIFont systemFontOfSize:14];
    yueButton.frame = CGRectMake((kScreenWidth/2 + 11), 5, (kScreenWidth/2 - 23), 34);
    [chatButton addTarget:self action:@selector(clickChatButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
    [giftButton addTarget:self action:@selector(clickGiftButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
    [yueButton addTarget:self action:@selector(clickYueButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView addSubview:yueButton];
    

    
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
    
//    [self.tableNode reloadData];

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
