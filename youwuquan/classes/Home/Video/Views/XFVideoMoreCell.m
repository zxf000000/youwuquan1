//
//  XFVideoMoreCell.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/20.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFVideoMoreCell.h"

@implementation XFVideoMoreSubCell

- (instancetype)init {
    
    if (self = [super init]) {
        
        _picNode = [[ASNetworkImageNode alloc] init];
        _picNode.defaultImage = [UIImage imageNamed:@"zhanweitu22"];
        
        [self addSubnode:_picNode];
        
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:kRandomName];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        _numberNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *numStr = [[NSMutableAttributedString  alloc] initWithString:@"播放3.3W次"];
        
        numStr.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:10],
                           NSForegroundColorAttributeName:UIColorHex(808080)
                           };
        
        _numberNode.attributedText = numStr;
        
        _numberNode.maximumNumberOfLines = 1;
        [self addSubnode:_numberNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _picNode.style.preferredSize = CGSizeMake(125, 75);
    
    _nameNode.style.spacingBefore = 10;
    _numberNode.style.spacingBefore = 5;
    
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_picNode,_nameNode,_numberNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 0, 12, 0)) child:allLayout];
    
}

@end

@implementation XFVideoMoreCell

- (instancetype)init {
    
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _iconNode = [ASNetworkImageNode new];
//        _iconNode.delegate = self;
        _iconNode.defaultImage = [UIImage imageNamed:@"zhanweitu44"];
        
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
        
        [self addSubnode:_iconNode];
        
        _nameNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString  alloc] initWithString:kRandomName];
        
        str.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _nameNode.attributedText = str;
        
        _nameNode.maximumNumberOfLines = 1;
        [self addSubnode:_nameNode];
        
        // 关注
        _followButton = [[ASButtonNode alloc] init];
        [_followButton setTitle:@"+ 关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_followButton setTitle:@"已关注" withFont:[UIFont systemFontOfSize:13] withColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        
        _followButton.backgroundColor = UIColorHex(F72F5E);
        [self addSubnode:_followButton];
        _followButton.cornerRadius = 4;
        _followButton.clipsToBounds = YES;
        
        _moreNode = [[ASTextNode alloc] init];
        
        NSMutableAttributedString *moreStr = [[NSMutableAttributedString  alloc] initWithString:@"更多视频"];
        
        moreStr.attributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                           NSForegroundColorAttributeName: [UIColor blackColor]
                           };
        
        _moreNode.attributedText = str;
        
        _moreNode.maximumNumberOfLines = 1;
        [self addSubnode:_moreNode];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake(125, 135);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        [self addSubnode:_collectionNode];
        
    }
    return self;
}

- (void)setColl {
    
    self.collectionNode.view.showsHorizontalScrollIndicator = NO;
    
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^ASCellNode *() {
      
        XFVideoMoreSubCell *cell = [[XFVideoMoreSubCell alloc] init];
        
        return cell;
        
    };
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    _collectionNode.style.preferredSize = CGSizeMake(kScreenWidth, 135);
    _iconNode.style.preferredSize = CGSizeMake(44, 44);
    _followButton.style.preferredSize = CGSizeMake(68, 29);
    
    ASStackLayoutSpec *nameIconLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:5 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsStart) children:@[_nameNode]];
    
    // 名字和头像
    ASStackLayoutSpec *iconNameLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:10 justifyContent:(ASStackLayoutJustifyContentStart) alignItems:(ASStackLayoutAlignItemsCenter) children:@[_iconNode,nameIconLayout]];
    
    // 上面一层
    ASStackLayoutSpec *upLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionHorizontal) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsCenter) flexWrap:(ASStackLayoutFlexWrapWrap) alignContent:(ASStackLayoutAlignContentSpaceBetween) children:@[iconNameLayout,_followButton]];
    
    ASInsetLayoutSpec *upInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 0, 10)) child:upLayout];
    ASInsetLayoutSpec *moreInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsMake(10, 10, 0, 10)) child:_moreNode];

    // label
    ASStackLayoutSpec *allLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:(ASStackLayoutDirectionVertical) spacing:0 justifyContent:(ASStackLayoutJustifyContentSpaceBetween) alignItems:(ASStackLayoutAlignItemsStretch) children:@[upInset,moreInset,_collectionNode]];

    
    return allLayout;
    
}

@end
