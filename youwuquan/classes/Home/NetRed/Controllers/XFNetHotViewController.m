//
//  XFHomeViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/10/27.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeViewController.h"
#import "XFOutsideButtonView.h"
#import "XFHomeTopHeaderReusableView.h"
#import "XFHomeCollectionViewCell.h"
#import "XFHomeSecondReusableView.h"

#import "XFActorViewController.h"
#import "XFNetHotViewController.h"
#import "XFVideoViewController.h"
#import "XFHomeTableNode.h"
#import "XFHomeSectionHeader.h"
#import "XFHomeNearNode.h"
#import "XFStatusDetailViewController.h"
#import "XFFindDetailViewController.h"


#define kHomeHeaderHeight (15 + 15 + 17 + 210 + 15 + 100 + 15 + 15 + 17)
#define kSecondHeaderHeight (195 + 15 + 17 + 15)




@interface XFNetHotViewController () <ASTableDelegate,ASTableDataSource,UICollectionViewDelegateFlowLayout,XFHomeNodedelegate>

@property (nonatomic,copy) NSArray *titleButtons;

@property (nonatomic,weak) UIButton *whButton;

@property (nonatomic,weak) UIButton *yyButton;

@property (nonatomic,weak) UIButton *spButton;

@property (nonatomic,weak) UIView *titleView;

@property (nonatomic,strong) UIView *slideView;

@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,copy) NSArray *upPics;

@property (nonatomic,copy) NSArray *names;

@property (nonatomic,copy) NSArray *invitePics;

@end

@implementation XFNetHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.upPics = @[@"1",@"2"];
    self.invitePics = @[@"3",@"4",@"5",@"6",@"7",@"8"];
    
    
    
    [self setupTableNode];
    
    [self.view setNeedsUpdateConstraints];
    
}


- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    
    self.tableNode.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    
    [self.view addSubnode:self.tableNode];
    
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    
}

#pragma mark - cellNodeDelegate
- (void)homeNode:(XFHomeTableNode *)node didClickLikeButtonWithIndex:(NSIndexPath *)indexPath {
    
    node.likeNode.selected = !node.likeNode.selected;
    
    [XFToolManager popanimationForLikeNode:node.likeNode.imageNode.layer complate:^{
        
        
    }];
}

//去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableNode.view)
    {
        CGFloat sectionHeaderHeight = 47;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFFindDetailViewController *detailVC = [[XFFindDetailViewController alloc] init];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 2;
    
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        
        XFHomeTableNode *node = [[XFHomeTableNode alloc] init];
        
        node.delegate = self;
        
        switch (indexPath.section) {
            case 0:
            {
                
                node.shadowNode.image = [UIImage imageNamed:@"overlay-zise"];
                
                if (self.type == NetHot) {
                    
                    node.picNode.defaultImage = [UIImage imageNamed:self.upPics[indexPath.row]];

                } else {
                    
                    node.picNode.defaultImage = [UIImage imageNamed:kRandomPic];

                }
                
                
            }
                break;
            case 1:
            {
                
                node.shadowNode.image = [UIImage imageNamed:@"home_hongse"];
                
                if (self.type == NetHot) {
                    
                    node.picNode.defaultImage = [UIImage imageNamed:self.invitePics[indexPath.row]];

                } else {
                    
                    node.picNode.defaultImage = [UIImage imageNamed:kRandomPic];

                }

            }
                break;
                
            default:
                break;
        }
        
        node.delegate = self;
        
        return node;
    };
    return cellNodeBlock;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 47;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XFHomeSectionHeader *header = [[XFHomeSectionHeader alloc] init];
    
    header.backgroundColor = [UIColor whiteColor];
    
    switch (section) {
        case 0:
        {
            if (_type == XFNetHotVCTypeWh) {
                header.titleLabel.text = @"新晋网红";

                
            } else {
                
                header.titleLabel.text = @"新晋尤物";

                
            }
            header.moreButton.hidden = YES;

        }
            break;
        case 1:
        {
            if (_type == XFNetHotVCTypeWh) {
                
                header.titleLabel.text = @"推荐网红";

                
            } else {
                
                header.titleLabel.text = @"推荐尤物";

            }
            header.moreButton.hidden = YES;
        }
            break;

        default:
            break;
    }
    
    return header;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    } else {
        
        return 4;
    }
    
    
    return 4;
}





@end

