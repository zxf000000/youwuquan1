//
//  XFAllMyStatusViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/8.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAllMyStatusViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "XFMyStatusCellNode.h"

@interface XFAllMyStatusViewController () <ASTableDelegate,ASTableDataSource,XFMyStatusCellDelegate>

@property (nonatomic,strong) ASTableNode *tableNode;


@end

@implementation XFAllMyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的动态";
    
    [self setupNavigationBar];
    [self setupTableNode];
}


- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return ^ASCellNode *{
        
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSInteger i = 0 ; i < indexPath.row % 10 ; i ++ ) {
            
            [mutableArr addObject:kRandomPic];
        }
        
        XFMyStatusCellNode *node = [[XFMyStatusCellNode alloc] initWithPics:mutableArr.copy];
        
        node.delegate = self;
        
        return node;
    };

}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    
    return 1;
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (void)setupTableNode {
    
    self.tableNode = [[ASTableNode alloc] init];
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    self.tableNode.view.showsVerticalScrollIndicator = NO;
    self.tableNode.backgroundColor = UIColorHex(f4f4f4);

    [self.view addSubnode:self.tableNode];
    
    if (@available (ios 11 , * )) {
        
        self.tableNode.view.estimatedRowHeight = 0;
        self.tableNode.view.estimatedSectionHeaderHeight = 0;
        self.tableNode.view.estimatedSectionFooterHeight = 0;
        
    }
    
    self.tableNode.view.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}
- (void)setupNavigationBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
    
}


@end
