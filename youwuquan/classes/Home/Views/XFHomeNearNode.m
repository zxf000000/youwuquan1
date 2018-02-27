//
//  XFHomeNearNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeNearNode.h"

#import "XFNearbyCellNode.h"
#import "XFNearModel.h"

@implementation XFHomeNearNode

- (instancetype)initWithDatas:(NSArray *)datas {
    
    if (self = [super init]) {
        
        _datas = datas;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 7, 0, 7);
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        layout.itemSize = CGSizeMake(88 + 12, 185);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        
        [self addSubnode:_collectionNode];
        
        _collectionNode.backgroundColor = [UIColor whiteColor];
        
        _names = @[@"尹素婉",@"陈冠希",@"周杰伦",@"盘羊角",@"李狗蛋",@"王尼玛"];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, 185);
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:_collectionNode];
    
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(homeNearNode:didClickNodeWithindexPath:)]) {
        
        [self.delegate homeNearNode:self didClickNodeWithindexPath:self.indexPath];
        
    }
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode* (){
        
        XFNearbyCellNode *node = [[XFNearbyCellNode alloc] init];
    
        XFNearModel *model = self.datas[indexPath.item];
        
        NSString *imgStr = model.headIconUrl;
        
        node.iconNode.URL  = [NSURL URLWithString:imgStr];
        node.nameNode.attributedText  = [[NSMutableAttributedString alloc] initWithString:model.nickname];
        
        [node.distanceButton setTitle:[NSString stringWithFormat:@"%.2fkm",[model.distance floatValue]] withFont:[UIFont systemFontOfSize:11] withColor:kMainRedColor forState:(UIControlStateNormal)];
        
        if (self.type == Search) {
            
            [node.distanceButton setImage:nil forState:(UIControlStateNormal)];
            [node.distanceButton setTitle:@"" withFont:nil withColor:nil forState:(UIControlStateNormal)];
            
        }
    
        return node;
    };
    
    return cellNodeBlock;
    
}

@end
