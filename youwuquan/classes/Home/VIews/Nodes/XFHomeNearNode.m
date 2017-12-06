//
//  XFHomeNearNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/7.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFHomeNearNode.h"

#import "XFNearbyCellNode.h"

@implementation XFHomeNearNode

- (instancetype)init {
    
    if (self = [super init]) {
        
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
    
    return 10;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode* (){
        
        XFNearbyCellNode *node = [[XFNearbyCellNode alloc] init];
    
        NSString *imgStr = [XFIconmanager sharedManager].headImages[indexPath.item % 5];
        
        node.iconNode.defaultImage  = [UIImage imageNamed:imgStr];
        node.nameNode.attributedText  = [[NSMutableAttributedString alloc] initWithString:self.names[indexPath.item%5]];

        if (self.type == Search) {
            
            [node.distanceButton setImage:nil forState:(UIControlStateNormal)];
            [node.distanceButton setTitle:@"" withFont:nil withColor:nil forState:(UIControlStateNormal)];
            
        }
        
    
        
        return node;
    };
    
    return cellNodeBlock;
    
}

@end
