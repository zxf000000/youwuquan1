//
//  ASSearchManCellNode.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/16.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "ASSearchManCellNode.h"
#import "XFSearchViewController.h"

@implementation XFSearchManCollectioNCell

- (instancetype)init {
    
    if (self = [super init]) {
        
        _iconNode = [[ASNetworkImageNode alloc] init];
        _iconNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
            
            UIGraphicsBeginImageContext(image.size);
            
            UIBezierPath *path = [UIBezierPath
                                  bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height)
                                  cornerRadius:MIN(image.size.width,image.size.height)/2];
            
            [path addClip];
            
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            
            UIImage *refinedImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return refinedImg;
            
        };
        _iconNode.defaultImage = [UIImage imageNamed:@"zhanweitu44"];
        [self addSubnode:_iconNode];
        

        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:@""];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                           NSForegroundColorAttributeName:UIColorHex(808080)
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
    }
    return self;
}

- (void)setModel:(XFSearchUserModel *)model{
    
    _model = model;
    _iconNode.URL = [NSURL URLWithString:_model.headIconUrl];
    [_nameNode setFont:[UIFont systemFontOfSize:12] alignment:(NSTextAlignmentCenter) textColor:UIColorHex(808080) offset:0 text:_model.nickname lineSpace:0 kern:1];
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    
    _iconNode.style.preferredSize = CGSizeMake(60, 60);
    
    _iconNode.style.spacingBefore = 0;
    _nameNode.style.spacingBefore = 10;
    
    _iconNode.style.flexGrow = YES;
    
    ASStackLayoutSpec *alllayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,_nameNode]];
    
    alllayout.style.flexGrow = YES;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 5, 10, 5)) child:alllayout];
    
}

@end

@implementation ASSearchManCellNode

- (instancetype)initWithDatas:(NSArray *)datas {
    
    if (self = [super init]) {
        
        _datas = datas;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:@"相关用户"];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:12],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _titleNode.attributedText = str;
        
        _titleNode.maximumNumberOfLines = 1;
        [self addSubnode:_titleNode];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.itemSize = CGSizeMake(81, 105);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        
        [self addSubnode:_collectionNode];
        
    }
    return self;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelecSearchMan) {
        self.didSelecSearchMan(self.datas[indexPath.item]);
    }
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode *() {
        
        XFSearchManCollectioNCell *cell = [[XFSearchManCollectioNCell alloc] init];
        
        cell.iconNode.defaultImage = [UIImage imageNamed:@"zhanweitu44"];
        
        cell.model = self.datas[indexPath.item];
        
        return cell;
        
    };
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASInsetLayoutSpec *titleInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 10, 0)) child:_titleNode];
    
    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, 105);
    
    ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[titleInset,_collectionNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(0, 0, 0, 0)) child:stackLayout];
}

@end
