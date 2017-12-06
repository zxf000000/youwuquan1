//
//  XFFindTextureViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/1.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFFindTextureViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFFindCellNode.h"
#import "XFFIndHeaderCell.h"
#import "XFSlideView.h"

#import "XFFindDetailViewController.h"
#import "XFStatusDetailViewController.h"
#import "XFYwqAlertView.h"

@interface XFFindTextureViewController () <ASTableDelegate,ASTableDataSource,XFFindCellDelegate,XFFindHeaderdelegate>

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) XFSlideView *topView;

@property (nonatomic,strong) ASTableNode *rightNode;

@property (nonatomic,strong) NSIndexPath *openIndexPath;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) NSInteger hdCount;

@property (nonatomic,copy) NSArray *pics;

@property (nonatomic,assign) BOOL hdIsopen;

@end

@implementation XFFindTextureViewController

//- (instancetype)init
//{
//    _tableNode = [[ASTableNode alloc] init];
//    self = [super initWithNode:_tableNode];
//
//    if (self) {
//        self.navigationItem.title = @"发现";
//        [self.navigationController setNavigationBarHidden:YES];
//
//
//        _tableNode.dataSource = self;
//        _tableNode.delegate = self;
//    }
//
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发现";
    
    self.hdCount = 2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
    
    self.topView = [[XFSlideView alloc] initWithTitle:@[@"推荐",@"关注"]];
    self.navigationItem.titleView = self.topView;
    
    self.pics = @[kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic,kRandomPic];

    if (@available (ios 11 , *)) {
        
        self.topView.frame = CGRectMake(0, 0, kScreenWidth, 64);
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.mas_offset(0);
        }];
        
    }
    __weak typeof(self) weakSelf = self;
    self.topView.clickButtonBlock = ^(NSInteger tag) {
        
        switch (tag) {
                
            case 1001:
            {
                
                [weakSelf.scrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
            }
                break;
                
            case 1002:
            {
                [weakSelf.scrollView setContentOffset:(CGPointMake(kScreenWidth, 0)) animated:YES];

            }
                break;
                
        }
    };
    
    [self setupScrollView];
    

}

- (void)findCellclickMpreButtonWithIndex:(NSIndexPath *)index open:(BOOL)isOpen {
    
    if (isOpen) {
        self.openIndexPath = index;

    } else {
        
        self.openIndexPath = nil;

    }
    
    [self.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:(UITableViewRowAnimationMiddle)];

    
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableNode == tableNode) {
        
        if (indexPath.section == 0) {
            
            
        } else {
            
            XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
            statusVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:statusVC animated:YES];
        }
        
    } else {
        
        XFStatusDetailViewController *statusVC = [[XFStatusDetailViewController alloc] init];
        statusVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:statusVC animated:YES];
    }
    

    
}


- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    if (self.tableNode == tableNode) {
        
        return 2;
    }
    
    return 1;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (tableNode == self.tableNode) {
        
        if (section == 0) {
            
            return self.hdCount;
        } else {
            
            return 15;
        }
    }

    return 10;
}

- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    // 推荐
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubnode:self.tableNode];
    
    if (@available (ios 11 , * )) {
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
    }
    
    self.tableNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 关注
    self.rightNode = [[ASTableNode alloc] init];
    self.rightNode.delegate = self;
    self.rightNode.dataSource = self;
    self.rightNode.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49);
    self.rightNode.view.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubnode:self.rightNode];
    
    if (@available (ios 11 , * )) {
        self.rightNode.view.estimatedRowHeight = 0;
        self.rightNode.view.estimatedSectionHeaderHeight = 0;
        self.rightNode.view.estimatedSectionFooterHeight = 0;
    }
    
    self.rightNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.rightNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - cellNodeDelegate点赞
- (void)findCellNode:(XFFindCellNode *)node didClickLikeButtonForIndex:(NSIndexPath *)indexPath {
    
    node.likeButton.selected = !node.likeButton.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeButton.imageNode.layer];
    
}

- (void)findCellNode:(XFFindCellNode *)node didClickIconForIndex:(NSIndexPath *)indexPath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)findCellNode:(XFFindCellNode *)node didClickRewardButtonWithIndex:(NSIndexPath *)inexPath {
    
    XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.navigationController.view withTitle:@"打赏用户" icon:@"" remainNUmber:@"100"];
    
    [alertView dsShowanimation];
    
    alertView.doneBlock = ^{

        MBProgressHUD *HUD = [XFToolManager showProgressHUDtoView:self.tabBarController.view];
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

#pragma mark - 活动celldaili
- (void)didClickMoreButton {
    
    self.hdCount = 6;
    self.hdIsopen = YES;
    [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
    
}

- (void)didClickNoMoreButton {
    
    self.hdCount = 2;
    self.hdIsopen = NO;
    [self.tableNode reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationFade)];
    [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];

}


- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableNode == self.tableNode) {
        
        switch (indexPath.section) {
            case 0:
            {
                return ^ASCellNode *{
                    
                    XFFIndHeaderCell *node = [[XFFIndHeaderCell alloc] init];
                    
                    node.delegate = self;
                    
                    node.picNode.defaultImage = [UIImage imageNamed:kRandomPic];

                    
                    if (indexPath.row == self.hdCount - 1) {
                        
                        node.isEnd = YES;
                        node.isOpen = self.hdIsopen;
                        
                    } else {
                        
                        node.isEnd = NO;
                    }
                    
                    return node;
                    
                };
            }
                break;
            case 1:
            {
                return ^ASCellNode *{
                    
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    for (NSInteger i = 0 ; i < indexPath.row % 10 ; i ++ ) {
                        
                        [mutableArr addObject:kRandomPic];
                    }
                    
                    XFFindCellNode *node = [[XFFindCellNode alloc] initWithOpen:NO pics:mutableArr.copy];
                    
                    node.index = indexPath;
                    
                    node.delegate = self;
        
                    node.picNode.defaultImage = [UIImage imageNamed:kRandomPic];

                    return node;
                };
            }
                break;
            default:
                break;
        }
    } else {
        
        return ^ASCellNode *{
            
            XFFindCellNode *node = [[XFFindCellNode alloc] initWithOpen:NO pics:@[@"timg"]];
            
//            node.index = indexPath;
            
            node.delegate = self;
            
            node.picNode.defaultImage = [UIImage imageNamed:self.pics[indexPath.row]];
            
            return node;
        };
        
    }
    


    return nil;

}

@end
