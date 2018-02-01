//
//  XFStatusDetailViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/15.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFStatusDetailViewController.h"
#import "XFStatusDetailCellNode.h"
#import "XFStatusCommentCellNode.h"
#import <IQKeyboardManager.h>
#import "XFMyStatusViewController.h"
#import "XFStatusNetworkManager.h"
#import "XFCommentModel.h"
#import "XFFindDetailViewController.h"
#import "XFPayViewController.h"
#import "XFYwqAlertView.h"
#import "XFAlertViewController.h"
#import "XFFindNetworkManager.h"
#import "XFMineNetworkManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XFMyVideoStatusViewController.h"
#import <AVKit/AVKit.h>

@implementation XFStatusCenterNode


- (instancetype)init {
    
    if (self = [super init]) {
        
        _titleNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:@"评论"];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _titleNode.attributedText = str;
        _titleNode.maximumNumberOfLines = 1;
        [self addSubnode:_titleNode];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 0)) child:_titleNode];
    
}

@end

@implementation XFStatusBottomNode

- (instancetype)init {
    
    if (self = [super init]) {
        
        _bgNode = [[ASDisplayNode alloc] init];
        _bgNode.backgroundColor = [UIColor whiteColor];
        _bgNode.shadowColor = UIColorHex(040000).CGColor;
        _bgNode.shadowOffset = CGSizeMake(0, 0);
        _bgNode.shadowOpacity = 0.1;
        _bgNode.cornerRadius = 4;
        [self addSubnode:_bgNode];
        
        _moreButton = [[ASButtonNode alloc] init];
        
        [_moreButton setTitle:@"点击查看更多评论" withFont:[UIFont systemFontOfSize:13] withColor:kMainRedColor forState:(UIControlStateNormal)];
        [self addSubnode:_moreButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [_moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(ASControlNodeEventTouchUpInside)];
        
    }

    return self;
}
- (void)clickMoreButton {
    
    if (self.clickMoreButtonBlock) {
        
        self.clickMoreButtonBlock();
    }
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _moreButton.style.preferredSize = CGSizeMake(kScreenWidth, 45);

    ASBackgroundLayoutSpec *bgLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:[ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_moreButton] background:_bgNode];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 10, 0)) child:bgLayout];
    
}

@end



@interface XFStatusDetailViewController () <ASTableDelegate,ASTableDataSource,UITextFieldDelegate,XFStatusCommentDelegate,XFStatusDetailCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) UIView *inputView;

@property (nonatomic,assign) BOOL unlock;

@property (nonatomic,copy) NSArray *likeDatas;

@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) XFCommentModel *commentedModel;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,copy) NSArray *indexPathsTobeReload;

@property (nonatomic,strong) NSURL  *voiceUrl;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) AVPlayer *audioPLayer;

@end


@implementation XFStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    
    self.HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
    
    if (self.type == Mine) {
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 70, 30))];
//        [deleteButton setImage:[UIImage imageNamed:@"status_delete"] forState:(UIControlStateNormal)];
        [deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
        [deleteButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
        [deleteButton addTarget:self action:@selector(clickdeleteButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.isOpen = NO;
    
    self.commentList = [NSArray array];
    
    [self setupTableNode];
    
    self.tableNode.alpha = 0;

    [self loadStatusInfo];
    
}

- (void)reloadData {
    
    NSArray *nodes = [self.tableNode visibleNodes];
    
    NSMutableArray *array = [NSMutableArray array];
    if ( nodes.count > 0 ) {
        
        for (ASCellNode *node in nodes) {
            
            [array addObject:node.indexPath];
        }
        
    }
    
    _indexPathsTobeReload = array.copy;
    
    [self.tableNode reloadData];
    
}

// 获取点赞数据
- (void)loadLikeInfo {
    
    [XFFindNetworkManager getLikeLIstWithStatusId:self.status.id successBlock:^(id responseObj) {
    
        self.likeDatas = ((NSDictionary *)responseObj)[@"content"];
    
        [self loadDataWithInset:NO];

        
    } failBlock:^(NSError *error) {
        
//        [XFToolManager showProgressInWindowWithString:@"加载点赞数据失败"];
        
        [self.HUD hideAnimated:YES];

    } progress:^(CGFloat progress) {
        
        
    }];
    
}

// 加载动态数据
- (void)loadStatusInfo {
    
    [XFFindNetworkManager getOneStatusWithStatusId:self.status.id successBlock:^(id responseObj) {
        
        XFStatusModel *model = [XFStatusModel modelWithDictionary:(NSDictionary *)responseObj];
        
        model.user = self.status.user;
        model.likedIt = self.status.likedIt;
        self.status = model;
        
        [self loadLikeInfo];

    } failBlock:^(NSError *error) {
        
        [self.HUD hideAnimated:YES];

        
    } progress:^(CGFloat progress) {
        
        
    }];
    
    
}

// 发送评论
- (void)clickSendButton {
    
    if (![self.inputTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入内容"];
        
        return;
    }
    [self hide];

    
    if (!self.commentedModel) {
        
        [XFFindNetworkManager commentStatusWithId:self.status.id text:self.inputTextField.text successBlock:^(id responseObj) {
            
            [self loadDataWithInset:YES];
            
            self.inputTextField.text = nil;
            
        } failBlock:^(NSError *error) {
            
            NSLog(@"%@",error.description);
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFFindNetworkManager commentCommentWithId:self.status.id commentId:self.commentedModel.id text:self.inputTextField.text successBlock:^(id responseObj) {
            
            [self loadDataWithInset:NO];

            self.commentedModel = nil;
            self.inputTextField.text = nil;

        } failBlock:^(NSError *error) {
            NSLog(@"%@",error.description);

        } progress:^(CGFloat progress) {
            
        }];
    }
    

    

    
    
}

- (void)loadDataWithInset:(BOOL)inset {
    
    self.page = 0;
    // 获取评论列表
    [XFFindNetworkManager getStatusCommentListWithId:self.status.id page:self.page size:15 successBlock:^(id responseObj) {
        
        NSArray *comments = ((NSDictionary *)responseObj)[@"content"];
        
        self.commentList = [XFCommentModel modelsWithComments:comments farthName:@""];
        
        if (inset) {
            
//            [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
            
//            [self.tableNode reloadData];
            
            [self reloadData];
            
            [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        } else {
            
//            [self.tableNode reloadData];
            [self reloadData];

        }
        
        [UIView animateWithDuration:0.2 animations:^{
           
            self.tableNode.alpha = 1;
            
        }];
        
        [self.HUD hideAnimated:YES];
        
    } failBlock:^(NSError *error) {
        [self.HUD hideAnimated:YES];

        
    } progress:^(CGFloat progress) {
        
        
    }];
    
    
}

- (void)loadMoreComments {
    
    self.page += 1;
    // 获取评论列表
    [XFFindNetworkManager getStatusCommentListWithId:self.status.id page:self.page size:15 successBlock:^(id responseObj) {
        
        NSArray *comments = ((NSDictionary *)responseObj)[@"content"];
    
        if (comments.count > 0) {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.commentList];
            
            [arr addObjectsFromArray:[XFCommentModel modelsWithComments:comments farthName:@""]];
            
            self.commentList  =  arr.copy;
//            [self.tableNode reloadData];
            [self reloadData];

            
            [self.tableNode.view.mj_footer endRefreshing];
        } else {
            
//            [XFToolManager showProgressInWindowWithString:@"没有更多"];
            
        }

        
    } failBlock:^(NSError *error) {
        
        [self.tableNode.view.mj_footer endRefreshing];

    } progress:^(CGFloat progress) {
        
        
    }];
    
    
}

- (void)clickdeleteButton {
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除本条动态?" preferredStyle:(UIAlertControllerStyleAlert)];
             
             UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                 
                 
             }];
             
             UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                 
                 MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
                 
                 // 删除本条
                 [XFFindNetworkManager deleteStatusWithStatusId:self.status.id successBlock:^(id responseObj) {
                     
                     [XFToolManager changeHUD:HUD successWithText:@"删除成功"];
                     
                     if (self.deleteSUccessBlock) {
                         self.deleteSUccessBlock();
                     }
                     
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 } failBlock:^(NSError *error) {
                     
                     [HUD hideAnimated:YES];
                     
                 } progress:^(CGFloat progress) {
                     
                     
                 }];
             }];
             
             [alert addAction:actionCancel];
             [alert addAction:actionDone];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisppear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

}

#pragma mark - 点击图片查看大图的代理
- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didSelectedPicWithIndex:(NSInteger)index pics:(NSArray *)pics picnodes:(NSArray *)picNodes {
    
    // 我的动态
    if (self.type == Mine) {
        // 判断是video或picture
        if (self.status.video) {
            // 判断是否解锁
            if (self.status.video[@"video"][@"srcUrl"]) {
                // 直接跳转
                
                // 播放视频
                NSURL * videoURL = [NSURL URLWithString:self.status.video[@"video"][@"srcUrl"]];
                
                AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc] init];
                
                avPlayer.player = [[AVPlayer alloc] initWithURL:videoURL];
                
                avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
                
                [self presentViewController:avPlayer animated:YES completion:nil];
                
//                XFMyVideoStatusViewController *playerVC = [[XFMyVideoStatusViewController alloc] init];
//                playerVC.url = [NSURL URLWithString:self.status.video[@"video"][@"srcUrl"]];
//                [self presentViewController:playerVC animated:YES completion:nil];
                
            } else {
                // 解锁
                [self buyTheStatus];
                
            }
            
            
        } else {
            NSDictionary *picInfo = self.status.pictures[index];
            // 如果未解锁需要解锁,如果解锁则不需要解锁
            NSString *type = picInfo[@"albumType"];
            if ([type isEqualToString:@"open"]) {
                // open的不做处理
                XFMyStatusViewController *photoVC = [[XFMyStatusViewController alloc] init];
                photoVC.type = XFMyStatuVCTypeOther;
                photoVC.model = self.status;
                
                [self.navigationController pushViewController:photoVC animated:YES];
                
            } else {
                // close的要弹框购买
                [self buyTheStatus];
                
            }
        }
        return;
    }
    
    // 别人动态类型
    
    // 判断是video或picture
    if (self.status.video) {
        // 判断是否解锁
        if (self.status.video[@"video"][@"srcUrl"]) {
//            // 直接跳转
//            XFMyVideoStatusViewController *playerVC = [[XFMyVideoStatusViewController alloc] init];
//            playerVC.url = [NSURL URLWithString:self.status.video[@"video"][@"srcUrl"]];
//            [self presentViewController:playerVC animated:YES completion:nil];
            // 播放视频
            NSURL * videoURL = [NSURL URLWithString:self.status.video[@"video"][@"srcUrl"]];
            
            AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc] init];
            
            avPlayer.player = [[AVPlayer alloc] initWithURL:videoURL];
            
            avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
            
            [self presentViewController:avPlayer animated:YES completion:nil];
            
        } else {
            // 解锁
            [self buyTheStatus];

        }
        
        
    } else {
        NSDictionary *picInfo = self.status.pictures[index];
        // 如果未解锁需要解锁,如果解锁则不需要解锁
        NSString *type = picInfo[@"albumType"];
        if ([type isEqualToString:@"open"]) {
            // open的不做处理
            XFMyStatusViewController *photoVC = [[XFMyStatusViewController alloc] init];
            photoVC.type = XFMyStatuVCTypeOther;
            photoVC.model = self.status;
            [self.navigationController pushViewController:photoVC animated:YES];
            
        } else {
            // close的要弹框购买
            [self buyTheStatus];
            
        }
    }
    
    
    
    if (self.unlock) {
        
 
        return;
    }
    
}
#pragma mark - tableNodeDelegate
- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *node = [tableNode nodeForRowAtIndexPath:indexPath];
    node.selected  = NO;
    
    if (indexPath.row > 1) {
    
        XFCommentModel *model = self.commentList[indexPath.row - 2];
        self.commentedModel = model;
        // 回复
        [self.inputTextField becomeFirstResponder];
        
        // 个人信息
        
//        XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
//        detailVC.userId = model.uid;
//        detailVC.userName = model.username;
//        detailVC.iconUrl = model.headIconUrl;
//        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)buyTheStatus {
    
    XFAlertViewController *alertVC = [[XFAlertViewController alloc] init];
    alertVC.type = XFAlertViewTypeUnlockStatus;
    alertVC.unlockPrice = self.status.unlockPrice;
    alertVC.clickOtherButtonBlock = ^(XFAlertViewController *alert) {
        // 充值页面
        XFPayViewController *payVC = [[XFPayViewController alloc] init];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
        
        [self presentViewController:navi animated:YES completion:nil];
        
    };
    
    alertVC.clickDoneButtonBlock = ^(XFAlertViewController *alert) {
        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];

        [XFFindNetworkManager unlockStatusWithStatusId:self.status.id successBlock:^(id responseObj) {
            // 重新获取数据
            [XFToolManager changeHUD:HUD successWithText:@"解锁成功"];
            // 重新获取数据,刷新
            [self loadStatusInfo];
            // 刷新上层数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshLockStatusForModelNotification object:self.status];
            
        } failBlock:^(NSError *error) {
            // 解锁失败
            [HUD hideAnimated:YES];
            // 获取返回状态码
            if (!error) {
                // 余额不足
                // 充值页面
                XFPayViewController *payVC = [[XFPayViewController alloc] init];
                
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
                
                [self presentViewController:navi animated:YES completion:nil];
                
            }
            
        } progress:^(CGFloat progress) {
            
            
        }];
        

    };
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (self.isOpen) {
        
        self.count = self.commentList.count + 2;
        
    } else {
        
        if (self.commentList.count < 5) {

            self.count =  self.commentList.count + 2;

        } else {

            self.count =  8;

        }        
    }

    return self.count;

}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            
                if (self.type == Mine) {
                    
                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithModel:self.status likeDatas:self.likeDatas];
                    
                    node.followButton.hidden = YES;
                    
                    node.detailDelegate = self;
                    
                    node.neverShowPlaceholders = YES;
                    
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        node.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            node.neverShowPlaceholders = NO;
                            
                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                            
                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
                            
                        });
                        
                    }
                    
                    return node;
                    
                } else {
                    
                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithModel:self.status likeDatas:self.likeDatas];
                    //
                    node.detailDelegate = self;
                    
                    node.neverShowPlaceholders = YES;
                    
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        node.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            node.neverShowPlaceholders = NO;
                            
                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                            
                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
                            
                        });
                        
                    }
                    
                    return node;
                    
                }
                
            
        }
            break;
        case 1:
        {
            
                XFStatusCenterNode *node = [[XFStatusCenterNode alloc] init];
                
                return node;
                
            
            
        }
            break;
        default:
        {
            // 没有评论
            if (self.commentList.count == 0) {
                
                
                    XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                    
                    // 加载更多评论
                    node.clickMoreButtonBlock = ^{
                        
                        self.isOpen = YES;
                        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                        
                        
                    };
                    
                    return node;
                    
                    
                
                
            }
            
            
            if (self.isOpen) {
                
                    XFCommentModel *model = self.commentList[indexPath.row - 2];
                    
                    XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:model];
                    
                    node.delegate = self;
                    
                    if ([_indexPathsTobeReload containsObject:indexPath]) {
                        
                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                        
                        node.neverShowPlaceholders = YES;
                        oldCellNode.neverShowPlaceholders = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            node.neverShowPlaceholders = NO;
                            
                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                            //
                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
                            
                        });
                        
                    }
                    
                    return node;
                    
                
            } else {
                
                if (self.count == 8 && indexPath.row == self.count - 1) {
                    
                        XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                        
                        // 加载更多评论
                        node.clickMoreButtonBlock = ^{
                            
                            self.isOpen = YES;
                            [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                            
                            
                        };
                        
                        return node;
                        
                    
                } else {
                    
                        XFCommentModel *model = self.commentList[indexPath.row - 2];
                        
                        
                        XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:model];
                        node.delegate = self;
                        
                        if ([_indexPathsTobeReload containsObject:indexPath]) {
                            
                            ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
                            
                            node.neverShowPlaceholders = YES;
                            oldCellNode.neverShowPlaceholders = YES;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                node.neverShowPlaceholders = NO;
                                
                                //                                NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
                                //
                                //                                [self.indexPathsTobeReload removeObjectAtIndex:index];
                                
                            });
                            
                        }
                        
                        return node;
                    
                }
                
            }
        }
            break;
            
            
    }
    
    
}



#pragma mark - 点赞
- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickLikeButton:(ASButtonNode *)followButton {
    
    if (_status.likedIt) {
        
        [XFFindNetworkManager unlikeWithStatusId:self.status.id successBlock:^(id responseObj) {
            
            // 取消点赞
            followButton.selected = NO;
            NSString *like = [NSString stringWithFormat:@"%zd",[[followButton.titleNode.attributedText string] intValue] - 1] ;
            _status.likeNum = like;
            _status.likedIt = NO;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshLikeStatusNotification object:@{@"status":self.status,
                                                                                                               @"liked":@(NO)
                                                                                                               }];
            [self loadLikeInfo];


        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];

    } else {
        
        [XFFindNetworkManager likeWithStatusId:self.status.id successBlock:^(id responseObj) {
            
            // 点赞
            followButton.selected = YES;
            NSString *like = [NSString stringWithFormat:@"%zd",[[followButton.titleNode.attributedText string] intValue] + 1] ;
            _status.likeNum = like;
            _status.likedIt = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshLikeStatusNotification object:@{@"status":self.status,
                                                                                                               @"liked":@(YES)
                                                                                                               }];

            [self loadLikeInfo];

            
        } failBlock:^(NSError *error) {
            
            
        } progress:^(CGFloat progress) {
            
            
        }];
        

    }
    
}

#pragma mark - 点击头像查看个人信息
- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickIconNode:(ASButtonNode *)iconNode {
    
    XFFindDetailViewController *userDetailVC =  [[XFFindDetailViewController alloc] init];
    userDetailVC.userId = self.status.user[@"uid"];
    userDetailVC.userName = self.status.user[@"nickname"];
    userDetailVC.iconUrl = self.status.user[@"headIconUrl"];
    [self.navigationController pushViewController:userDetailVC animated:YES];
    
}

#pragma mark - 点击声音
- (void)playbackFinished:(NSNotification *)notice {
    
    self.isPlaying = NO;
    
}

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickVoiceNodeWithUrl:(NSString *)url {
    
    self.voiceUrl = [NSURL URLWithString:url];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:self.voiceUrl];
    if (!self.audioPLayer) {
        self.audioPLayer = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    }
    
    [self.audioPLayer replaceCurrentItemWithPlayerItem:songItem];
    
    if (self.isPlaying) {
        [self.audioPLayer pause];
        self.isPlaying = NO;
        
    } else {
        
        [self.audioPLayer play];
        self.isPlaying = YES;
        self.HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view];
        [_HUD hideAnimated:YES afterDelay:0.5];
        
    }
    
}

#pragma mark - 关注按钮点

- (void)statusCellNode:(XFStatusDetailCellNode *)statusCell didClickFollowButton:(ASButtonNode *)followButton {
    
    [self followSomeoneWithId:self.status.user[@"uid"] followed:[self.status.user[@"followed"] boolValue] button:statusCell.followButton];
    
}

- (void)followSomeoneWithId:(NSString *)uid followed:(BOOL)followed button:(ASButtonNode *)button {
    
    if (followed) {
        // 取消关注
        [XFMineNetworkManager unCareSomeoneWithUid:uid successBlock:^(id responseObj) {
            
            button.selected = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                if (button.selected) {
                    
                    [button setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                    
                    button.backgroundColor = [UIColor lightGrayColor];
                    
                } else {
                    [button setBackgroundImage:[UIImage imageNamed:@"find_careBg"] forState:(UIControlStateNormal)];
                    
                    button.backgroundColor = kMainRedColor;
                    
                }
                

                
            }];

                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_status.user];
                    
                    [dic setObject:@(NO) forKey:@"followed"];
                    
                    _status.user = dic.copy;
            
            // 刷新上一级页面数据
//            if (self.followedBlock) {
//
//                self.followedBlock(self.status, NO);
//            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCareStatusNotification object:@{@"status":self.status,
                                                                                                               @"followed":@(NO)
                                                                                                               }];
        
            
        } failedBlock:^(NSError *error) {

            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    } else {
        
        [XFMineNetworkManager careSomeoneWithUid:uid successBlock:^(id responseObj) {
            
            button.selected = YES;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                if (button.selected) {
                    
                    [button setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                    
                    button.backgroundColor = [UIColor lightGrayColor];
                    
                } else {
                    [button setBackgroundImage:[UIImage imageNamed:@"find_careBg"] forState:(UIControlStateNormal)];
                    
                    button.backgroundColor = kMainRedColor;
                    
                }
                
            }];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_status.user];
            
            [dic setObject:@(YES) forKey:@"followed"];
            
            _status.user = dic.copy;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCareStatusNotification object:@{@"status":self.status,
                                                                                                               @"followed":@(YES)
                                                                                                               }];
//
//            // 刷新上一级页面数据
//            if (self.followedBlock) {
//
//                self.followedBlock(self.status, YES);
//            }
            
        } failedBlock:^(NSError *error) {
            
            
        } progressBlock:^(CGFloat progress) {
            
            
        }];
        
    }
    
}

#pragma mark - statusCommentDelegate
- (void)statusCommentNode:(XFStatusCommentCellNode *)commentNode didClickComplyTextWithIndex:(NSIndexPath *)indexPath {
    // 回复评论内容
    NSLog(@"开始回复");
    
}


- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44);
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available (ios 11 , * )) {
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
    }
    
    self.tableNode.view.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
       
        [self loadMoreComments];
        
    }];
    
}
- (void)clickBackButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}
// 设置IQkeyboard不滑动导航栏
-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}


//------------------------------------------- 可爱的分割线 --------------------------------------//
//- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    switch (indexPath.row) {
//
//        case 0:
//        {
//
//            return ^ASCellNode *{
//
//                if (self.type == Mine) {
//
//                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithModel:self.status likeDatas:self.likeDatas];
//
//                    node.followButton.hidden = YES;
//
//                    node.detailDelegate = self;
//
//                    node.neverShowPlaceholders = YES;
//
//                    if ([_indexPathsTobeReload containsObject:indexPath]) {
//
//                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
//
//                        node.neverShowPlaceholders = YES;
//                        oldCellNode.neverShowPlaceholders = YES;
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            node.neverShowPlaceholders = NO;
//
//                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
//
//                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
//
//                        });
//
//                    }
//
//                    return node;
//
//                } else {
//
//                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithModel:self.status likeDatas:self.likeDatas];
//                    //
//                    node.detailDelegate = self;
//
//                    node.neverShowPlaceholders = YES;
//
//                    if ([_indexPathsTobeReload containsObject:indexPath]) {
//
//                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
//
//                        node.neverShowPlaceholders = YES;
//                        oldCellNode.neverShowPlaceholders = YES;
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            node.neverShowPlaceholders = NO;
//
//                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
//
//                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
//
//                        });
//
//                    }
//
//                    return node;
//
//                }
//
//            };
//        }
//            break;
//        case 1:
//        {
//            return ^ASCellNode *{
//
//                XFStatusCenterNode *node = [[XFStatusCenterNode alloc] init];
//
//                return node;
//
//            };
//
//        }
//            break;
//        default:
//        {
//            // 没有评论
//            if (self.commentList.count == 0) {
//
//                return ^ASCellNode *{
//
//                    XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
//
//                    // 加载更多评论
//                    node.clickMoreButtonBlock = ^{
//
//                        self.isOpen = YES;
//                        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
//
//
//                    };
//
//                    return node;
//
//
//                };
//
//            }
//
//
//            if (self.isOpen) {
//
//                return ^ASCellNode *{
//
//                    XFCommentModel *model = self.commentList[indexPath.row - 2];
//
//                    XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:model];
//
//                    node.delegate = self;
//
//                    if ([_indexPathsTobeReload containsObject:indexPath]) {
//
//                        ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
//
//                        node.neverShowPlaceholders = YES;
//                        oldCellNode.neverShowPlaceholders = YES;
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            node.neverShowPlaceholders = NO;
//
//                            //                            NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
//                            //
//                            //                            [self.indexPathsTobeReload removeObjectAtIndex:index];
//
//                        });
//
//                    }
//
//                    return node;
//
//                };
//            } else {
//
//                if (self.count == 8 && indexPath.row == self.count - 1) {
//
//                    return ^ASCellNode *{
//
//                        XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
//
//                        // 加载更多评论
//                        node.clickMoreButtonBlock = ^{
//
//                            self.isOpen = YES;
//                            [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
//
//
//                        };
//
//                        return node;
//
//
//                    };
//
//                } else {
//
//                    return ^ASCellNode *{
//
//                        XFCommentModel *model = self.commentList[indexPath.row - 2];
//
//
//                        XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:model];
//                        node.delegate = self;
//
//                        if ([_indexPathsTobeReload containsObject:indexPath]) {
//
//                            ASCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:indexPath];
//
//                            node.neverShowPlaceholders = YES;
//                            oldCellNode.neverShowPlaceholders = YES;
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                node.neverShowPlaceholders = NO;
//
//                                //                                NSInteger index = [self.indexPathsTobeReload indexOfObject:indexPath];
//                                //
//                                //                                [self.indexPathsTobeReload removeObjectAtIndex:index];
//
//                            });
//
//                        }
//
//                        return node;
//
//                    };
//
//                }
//
//            }
//        }
//            break;
//
//
//    }
//
//}




@end
