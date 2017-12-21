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


@end

@implementation XFStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    
    // 返回按钮
    UIButton *backButton = [UIButton naviBackButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.isOpen = NO;
    
    self.commentList = [NSArray array];
    
    [self setupTableNode];
    
    [self loadDataWithInset:NO];
    

}
// 发送评论
- (void)clickSendButton {
    
    if (![self.inputTextField.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入内容"];
        
        return;
    }
    
    [self hide];
    
    
    [XFStatusNetworkManager commentStatusWithId:self.status.id message:self.inputTextField.text userNoA:self.status.userNo successBlock:^(NSDictionary *reponseDic) {
       

        if (reponseDic) {
            
            
            [self loadDataWithInset:YES];
            
            self.inputTextField.text = nil;
        }
        
        
    } failedBlock:^(NSError *error) {
        

    }];
    
}

- (void)loadDataWithInset:(BOOL)inset {
    
    [XFStatusNetworkManager getStatusDetailWithReleaseId:self.status.id successBlock:^(NSDictionary *reponseDic) {
        
        if (reponseDic) {
            
            NSArray *allData = reponseDic[@"data"];
            
            NSArray *coments = allData[0];
            NSMutableArray *commentArr = [NSMutableArray array];
            for (NSInteger i = 0 ; i < coments.count ; i ++ ) {
                
                [commentArr addObject:[XFCommentModel modelWithDictionary:coments[i]]];
                
            }
            self.commentList = commentArr.copy;
            
            if (inset) {
                
//                if (self.commentList.count == 5) {
//
//                    [self.tableNode insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:(UITableViewRowAnimationTop)];
//
//
//                } else {
//
//                    if (self.isOpen) {
//
//                        [self.tableNode insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationTop)];
//                        [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
//
//                    } else {
//
//                        if (self.commentList.count == 1) {
//
//                            [self.tableNode insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationTop)];
//                            [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
//
//
//                        } else {
//
//                            [self.tableNode reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0],[NSIndexPath indexPathForRow:5 inSection:0],[NSIndexPath indexPathForRow:6 inSection:0],] withRowAnimation:(UITableViewRowAnimationFade)];
//                            [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
//
//                        }
//
//                    }
                
//                }
                
                self.tableNode.hidden = YES;

                [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                
                self.tableNode.hidden = NO;
                
                [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
            } else {
                self.tableNode.hidden = YES;

                [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                self.tableNode.hidden = NO;

            }
            
        }
       
        
    } failedBlock:^(NSError *error) {
        
        
    }];
    
    
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
    
//    NSArray *names = pics;
//    NSMutableArray *items = [NSMutableArray array];
//
//    for (int i = 0; i < names.count; i++) {
//
//        ASNetworkImageNode *picNode = picNodes[i];
//
//        CGRect frame = [statusCell.view convertRect:picNode.view.frame toView:self.view.window];
//
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:[UIImage imageNamed:names[i]]];
//        [items addObject:item];
//    }
//    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
//    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
//    [browser showFromViewController:self];
    
    if (self.unlock) {
        
        XFMyStatusViewController *photoVC = [[XFMyStatusViewController alloc] init];
        photoVC.type = XFMyStatuVCTypeOther;
        photoVC.model = self.status;
        [self.navigationController pushViewController:photoVC animated:YES];
        
        return;
    }
    
    // 解锁
    if (index > 1) {
        
        
        
        // TODO:
        XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"请先解锁" detail:@"解锁本条动态需要66钻石,是否支付"];
        
        alertView.doneBlock = ^{
            
//            [XFToolManager showProgressInWindowWithString:@"余额不足,请充值"];
//            // 充值页面
//            XFPayViewController *payVC = [[XFPayViewController alloc] init];
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
//            [self presentViewController:navi animated:YES completion:nil];
            
            // 充值成功,刷新页面
            
            self.unlock = YES;
            
            MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.navigationController.view withText:nil];
            
            [HUD hideAnimated:YES afterDelay:0.8];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 刷新页面
                [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                
            });
        };
        
        alertView.cancelBlock = ^{
        
                // 取消
            
        };
        
        [alertView showAnimation];
        
        
//        [XFToolManager showProgressInWindowWithString:@"私密美图/视频需要解锁才能查看"];

        
    } else {
        
        XFMyStatusViewController *photoVC = [[XFMyStatusViewController alloc] init];
        photoVC.type = XFMyStatuVCTypeOther;
        photoVC.model = self.status;
        [self.navigationController pushViewController:photoVC animated:YES];
    }

    
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *node = [tableNode nodeForRowAtIndexPath:indexPath];
    node.selected  = NO;
    
    if (indexPath.row > 1) {
    
        // 个人信息
        XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
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

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            return ^ASCellNode *{
                
                if (self.type == Mine) {
                    
                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithModel:self.status];
                    
                    node.followButton.hidden = YES;
                    
                    node.detailDelegate = self;
                    
                    return node;
                    
                } else {
                    
                    XFStatusDetailCellNode *node = [[XFStatusDetailCellNode alloc] initWithImages:@[@"find4",@"find5",@"find6",@"find7"] likeImgs:@[@"icon1",@"icon2",@"icon3",@"icon4",@"icon2",@"icon6",@"icon7",@"icon9",@"icon8",@"icon10",@"icon11",@"icon12",@"icon13",@"icon14",@"icon15",@"icon16"] unlock:self.unlock];
                    
                    if (self.type == Mine) {
                        
                        node.followButton.hidden = YES;
                    }
                    
                    node.detailDelegate = self;
                    
                    return node;
                    
                }
                
            };
        }
            break;
        case 1:
        {
            return ^ASCellNode *{
                
                XFStatusCenterNode *node = [[XFStatusCenterNode alloc] init];
                
                return node;
                
            };
            
        }
            break;
        default:
        {
            // 没有评论
            if (self.commentList.count == 0) {
                
                return ^ASCellNode *{
                    
                    XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                    
                    // 加载更多评论
                    node.clickMoreButtonBlock = ^{
                        
                        self.isOpen = YES;
                        [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                        
                        
                    };
                    
                    return node;
                    
                    
                };
                
            }
            
            
            if (self.isOpen) {
            
                return ^ASCellNode *{
                    
                    XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:self.commentList[indexPath.row - 2]];
                    
                    node.delegate = self;
                    
                    return node;
                    
                };
            } else {
                
                if (self.count == 8 && indexPath.row == self.count - 1) {
                    
                    return ^ASCellNode *{
                        
                        XFStatusBottomNode *node = [[XFStatusBottomNode alloc] init];
                        
                        // 加载更多评论
                        node.clickMoreButtonBlock = ^{
                            
                            self.isOpen = YES;
                            [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
                            
                            
                        };
                        
                        return node;
                        
                        
                    };
                    
                } else {
                    
                    return ^ASCellNode *{
                        
                        XFStatusCommentCellNode *node = [[XFStatusCommentCellNode alloc] initWithMode:self.commentList[indexPath.row - 2]];
                        
                        node.delegate = self;
                        
                        return node;
                        
                    };
                    
                }
                
            }
        }
            break;
            
            
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



@end
